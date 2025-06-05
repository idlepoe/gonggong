import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

    final Map<String, MeasurementInfo> loaded = {};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final parentId = doc.id;

      // 서브컬렉션 values 가져오기
      final valuesSnap = await doc.reference
          .collection("values")
          .orderBy("startDate", descending: true)
          .limit(24)
          .get();
      print(data);
      final values = valuesSnap.docs
          .map((v) => MeasurementValue.fromJson(v.data()))
          .toList();

      print(values);

      final info = MeasurementInfo.fromJson({
        ...data,
        'values': values.map((v) => v.toJson()).toList(),
        // 👈 fromJson이 map<String, dynamic>를 받기 때문
      });

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
}
