import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../data/models/bet.dart';
import '../../../data/models/measurement_info.dart';
import '../../../data/models/measurement_value.dart';
import '../../../data/utils/api_service.dart';
import '../../../data/utils/logger.dart';

class BetController extends GetxController {
  final measurementInfos = <String, MeasurementInfo>{}.obs;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
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
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> placeBet(Bet bet) async {
    try {
      await ApiService().placeBetWithModel(bet);
      Get.snackbar("베팅 완료", "${bet.amount.toInt()}포인트 베팅 성공!");
      // 필요시 포인트 또는 베팅 목록 갱신
    } catch (e) {
      Get.snackbar("베팅 실패", e.toString());
    }
  }

  Future<void> cancelBet(Bet bet) async {
    try {
      await ApiService().cancelBet(bet.uid, bet.site_id, bet.type_id);

      final refund = (bet.amount * 0.85).floor();
      final directionLabel = bet.direction == 'up' ? '오를 것' : '내릴 것';

      logger.i("🪙 ${bet.amount}P 베팅 취소 → ${refund}P 환불");

      Get.snackbar(
        "베팅 취소 완료",
        "$directionLabel 에 걸었던 ${bet.amount.toStringAsFixed(0)}P 중\n수수료 제외 ${refund}P가 환불되었습니다.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      logger.e("❌ 베팅 취소 실패: $e");
      Get.snackbar(
        "베팅 취소 실패",
        "다시 시도해주세요.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
