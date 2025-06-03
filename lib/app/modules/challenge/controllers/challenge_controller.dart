import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../data/models/challenge.dart';
import '../../../data/utils/logger.dart';

class ChallengeController extends GetxController {
  final RxList<Challenge> challenges = <Challenge>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchChallenges();
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
}
