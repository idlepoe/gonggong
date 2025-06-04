import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../data/models/challenge.dart';
import '../../../data/models/water_measurement.dart';
import '../../../data/utils/logger.dart';

class ChallengeController extends GetxController {
  final RxList<Challenge> challenges = <Challenge>[].obs;
  final RxList<WaterMeasurement> measurements = <WaterMeasurement>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchMeasurements();

    // fetchChallenges();
  }

  Future<void> fetchChallenges() async {
    try {
      final snapshot = await _firestore
          .collection("bets")
          .orderBy("createdAt", descending: true)
          .get();

      final list = snapshot.docs.map((doc) {
        return Challenge.fromJson({
          ...doc.data(),
          "id": doc.id,
        });
      }).toList();

      challenges.assignAll(list);
    } catch (e) {
      logger.e(e);
      Get.snackbar("Error", "Failed to load challenges");
    }
  }

  Future<void> fetchMeasurements() async {
    try {
      final now = DateTime.now().toUtc().add(Duration(hours: 9));
      final past = now.subtract(Duration(hours: 24));

      final snapshot = await _firestore
          .collection("water_snapshots")
          .where("createdAt", isGreaterThanOrEqualTo: past)
          .orderBy("createdAt", descending: false)
          .get();

      final List<WaterMeasurement> result = [];

      for (final doc in snapshot.docs) {
        final createdAt = (doc.data()['createdAt'] as Timestamp).toDate();
        final dataList = doc.data()['data'] as List;

        for (final raw in dataList) {
          final parsed = WaterMeasurement.fromJson(raw);
          result.add(parsed.copyWith(createdAt: createdAt));
        }
      }

      measurements.assignAll(result);
    } catch (e) {
      logger.e(e);
      Get.snackbar("Error", "Failed to load water data");
    }
  }

  Map<String, List<WaterMeasurement>> get groupedBySite {
    final Map<String, List<WaterMeasurement>> grouped = {};

    for (final m in measurements) {
      grouped.putIfAbsent(m.SITE_ID, () => []).add(m);
    }

    // 시간순 정렬 (필수)
    for (final entry in grouped.entries) {
      entry.value.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    }

    return grouped;
  }
}
