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

  @override
  void onInit() {
    super.onInit();
    fetchMeasurementInfos();
  }

  Future<void> fetchMeasurementInfos() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection("measurements").get();
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final Map<String, MeasurementInfo> loaded = {};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final parentId = doc.id;

      // values
      final valuesSnap = await doc.reference
          .collection("values")
          .orderBy("startDate", descending: true)
          .limit(24)
          .get();

      final values = valuesSnap.docs
          .map((v) => MeasurementValue.fromJson(v.data()))
          .toList();

      // ✅ myBet 추가
      Bet? myBet;
      if (uid != null) {
        logger.i(uid);
        final betSnap = await FirebaseFirestore.instance
            .collection("bets")
            .doc(parentId)
            .collection("entries")
            .doc(uid)
            .get();

        if (betSnap.exists) {
          myBet = Bet.fromJson(betSnap.data()!);
        }
      }

      // ✅ MeasurementInfo with myBet
      final info = MeasurementInfo.fromJson({
        ...data,
        'values': values.map((v) => v.toJson()).toList(),
      }).copyWith(myBet: myBet);

      loaded[parentId] = info;
    }

    measurementInfos.assignAll(loaded);
    logger.d(loaded);
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
      final res = await ApiService().cancelBet(bet.uid, bet.site_id, bet.type_id);
      logger.i("🪙 베팅 취소 성공: ${res.data}");
      Get.snackbar("베팅 취소 완료", res.data.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      logger.e("❌ 베팅 취소 실패: $e");
      Get.snackbar("베팅 취소 실패", "다시 시도해주세요.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
