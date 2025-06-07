import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/controllers/profile_controller.dart';
import '../../../data/models/bet.dart';
import '../../../data/models/measurement_info.dart';
import '../../../data/models/measurement_value.dart';
import '../../../data/utils/api_service.dart';
import '../../../data/utils/logger.dart';
import '../../../data/widgets/show_app_snackbar.dart';

class BetController extends GetxController {
  final measurementInfos = <String, MeasurementInfo>{}.obs;
  StreamSubscription? _subscription;

  final String kFavoriteMeasurementsKey = 'favorite_measurements';
  final favorites = <String>{}.obs; // 즐겨찾기 ID 목록

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
    _bindMeasurementStream();
  }

  void _bindMeasurementStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _subscription = FirebaseFirestore.instance
        .collection("measurements")
        .snapshots()
        .listen((snapshot) async {
      final Map<String, MeasurementInfo> loaded = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final parentId = doc.id;

        // 🔹 fetch values (서브컬렉션)
        final valuesSnap = await doc.reference
            .collection("values")
            .orderBy("startDate", descending: true)
            .limit(24)
            .get();

        final values = valuesSnap.docs
            .map((v) => MeasurementValue.fromJson(v.data()))
            .toList();

        // 🔹 fetch myBet
        Bet? myBet;
        final betSnap = await FirebaseFirestore.instance
            .collection("bets")
            .doc(parentId)
            .collection("entries")
            .doc(uid)
            .get();

        if (betSnap.exists) {
          myBet = Bet.fromJson(betSnap.data()!);
        }

        // 🔹 MeasurementInfo 조립
        final info = MeasurementInfo.fromJson({
          ...data,
          'values': values.map((v) => v.toJson()).toList(),
        }).copyWith(myBet: myBet);

        loaded[parentId] = info;
      }

      measurementInfos.assignAll(loaded);
      sortMeasurementInfos();
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  /// ✅ SharedPreferences에서 즐겨찾기 불러오기
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(kFavoriteMeasurementsKey) ?? [];
    favorites.assignAll(stored);
  }

  /// ✅ 즐겨찾기 여부 확인
  bool isFavorite(MeasurementInfo info) {
    final id = "${info.site_id}_${info.type_id}";
    return favorites.contains(id);
  }

  /// ✅ 즐겨찾기 토글
  Future<void> toggleFavorite(MeasurementInfo info) async {
    final id = "${info.site_id}_${info.type_id}";
    final prefs = await SharedPreferences.getInstance();

    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    await prefs.setStringList(kFavoriteMeasurementsKey, favorites.toList());
    sortMeasurementInfos(); // 우선순위 정렬 반영
  }

  /// ✅ 우선순위 정렬 (즐겨찾기 먼저)
  void sortMeasurementInfos() {
    final entries = measurementInfos.entries.toList();

    entries.sort((a, b) {
      final isAFav = favorites.contains(a.key);
      final isBFav = favorites.contains(b.key);
      if (isAFav && !isBFav) return -1;
      if (!isAFav && isBFav) return 1;
      return 0;
    });

    measurementInfos.assignAll({for (var e in entries) e.key: e.value});
  }

  Future<void> placeBet(Bet bet) async {
    try {
      if (isLoading.value) return; // 중복 클릭 방지
      isLoading.value = true;

      // ✅ 포인트 확인
      final profile = Get.find<ProfileController>().userProfile.value;
      final currentPoints = profile?.points ?? 0;

      if (currentPoints < bet.amount) {
        showAppSnackbar("베팅 실패", "포인트가 부족합니다. 현재 보유: $currentPoints P");
        return;
      }

      await ApiService().placeBetWithModel(bet);

      // ✅ topic 구독
      final topic =
          "${bet.site_id}_${bet.type_id}_${_resolveBetKey(bet.createdAt)}";
      await FirebaseMessaging.instance.subscribeToTopic(topic);

      showAppSnackbar("베팅 완료", "${bet.amount.toInt()}포인트 베팅 성공!");
      // 필요시 포인트 또는 베팅 목록 갱신
    } catch (e) {
      showAppSnackbar("베팅 실패", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelBet(Bet bet) async {
    try {
      if (isLoading.value) return; // 중복 클릭 방지
      isLoading.value = true;

      await ApiService().cancelBet(bet.uid, bet.site_id, bet.type_id);

      // ✅ topic 구독 해제
      final topic =
          "${bet.site_id}_${bet.type_id}_${_resolveBetKey(bet.createdAt)}";
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);

      final refund = (bet.amount * 0.85).floor();
      final directionLabel = bet.direction == 'up' ? '오를 것' : '내릴 것';

      logger.i("🪙 ${bet.amount}P 베팅 취소 → ${refund}P 환불");

      showAppSnackbar(
        "베팅 취소 완료",
        "$directionLabel 에 걸었던 ${bet.amount.toStringAsFixed(0)}P 중\n수수료 제외 ${refund}P가 환불되었습니다.",
      );
    } catch (e) {
      logger.e("❌ 베팅 취소 실패: $e");
      showAppSnackbar(
        "베팅 취소 실패",
        "다시 시도해주세요.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 🔧 topic key resolver (예: 202506052400)
  String _resolveBetKey(DateTime dt) {
    final date =
        "${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}";
    final hour = dt.hour.toString().padLeft(2, '0');
    return "${date}${hour}00";
  }
}
