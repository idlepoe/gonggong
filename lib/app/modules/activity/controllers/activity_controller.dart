import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../data/models/activity.dart';

class ActivityController extends GetxController {
  final activities = <Activity>[].obs;

  @override
  void onInit() {
    FirebaseFirestore.instance
        .collection('activity')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      activities.value = snapshot.docs.map((doc) {
        return Activity.fromJson(doc.data());
      }).toList();
    });
    super.onInit();
  }
}