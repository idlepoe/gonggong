import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../data/controllers/profile_controller.dart';
import '../../../data/models/bet_comment.dart';
import '../../../data/models/measurement_info.dart';
import '../../bet/controllers/bet_controller.dart';
import '../views/bet_detail_view.dart';

class BetDetailController extends GetxController {
  final String betId;

  late final StreamSubscription commentSub;

  final RxList<BetComment> comments = <BetComment>[].obs;

  BetDetailController(this.betId);

  @override
  void onInit() {
    super.onInit();
    _listenToComments();
  }

  void refreshData() {
    // Get.off(() => BetDetailView(), binding: BindingsBuilder(() {
    //   Get.put(BetDetailController(betId));
    // }));
  }

  void _listenToComments() {
    commentSub = FirebaseFirestore.instance
        .collection('bets')
        .doc(betId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      comments.value =
          snapshot.docs.map((e) => BetComment.fromJson(e.data())).toList();
    });
  }

  Future<void> addComment(String text) async {
    if (text.trim().isEmpty) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final profile = Get.find<ProfileController>().userProfile.value;
    if (profile == null) return;

    await FirebaseFirestore.instance
        .collection('bets')
        .doc(betId)
        .collection('comments')
        .add(
          BetComment(
                  uid: profile.uid,
                  name: profile.name,
                  avatarUrl: profile.avatarUrl,
                  message: text,
                  createdAt: DateTime.now())
              .toJson(),
        );
  }

  @override
  void onClose() {
    commentSub.cancel();
    super.onClose();
  }
}
