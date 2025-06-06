import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/user_profile.dart';

class ProfileController extends GetxController {
  final Rxn<UserProfile> userProfile = Rxn<UserProfile>();
  Timer? _pointTimer;

  @override
  void onInit() {
    super.onInit();
    _initProfileStream();
  }

  @override
  void onClose() {
    _pointTimer?.cancel();
    super.onClose();
  }

  void _initProfileStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    docRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        userProfile.value = UserProfile.fromJson({'uid': uid, ...data});
        _handlePointReward(data['points'] ?? 0);
      }
    });
  }

  void _handlePointReward(int currentPoints) {
    // 이미 100 이상이면 타이머 종료
    if (currentPoints >= 100) {
      _pointTimer?.cancel();
      _pointTimer = null;
      return;
    }

    // 이미 타이머 작동 중이면 건너뜀
    if (_pointTimer != null && _pointTimer!.isActive) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _pointTimer = Timer.periodic(const Duration(minutes: 10), (_) async {
      final newPoints = currentPoints + 20;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'points': newPoints});
    });
  }

  Future<void> updateNickname(String newNickname) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'nickname': newNickname});
  }

  Future<void> updateAvatarUrl(String imageUrl) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'avatarUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    userProfile.update((profile) {
      if (profile != null) {
        userProfile.value = profile.copyWith(avatarUrl: imageUrl);
      }
    });
  }
}
