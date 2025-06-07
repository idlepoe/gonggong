import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../constants/api_constants.dart';
import '../models/user_profile.dart';

class ProfileController extends GetxController {
  final Rxn<UserProfile> userProfile = Rxn<UserProfile>();

  // ✅ 반응형 getter
  int get userPoints => userProfile.value?.points ?? 0;

  Timer? _pointTimer;

  @override
  void onInit() {
    super.onInit();
    initProfileStream();
  }

  @override
  void onClose() {
    _pointTimer?.cancel();
    super.onClose();
  }

  Future<void> initProfileStream() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      docRef.snapshots().listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data()!;
          userProfile.value = UserProfile.fromJson({'uid': uid, ...data});
          _handlePointReward(data['points'] ?? 0);
        }
      });
    }
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

  Future<void> updateName(String name) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'name': name});
  }

  String generateRandomNickname() {
    final random = Random();
    final prefix = ApiConstants
        .nicknamePrefixes[random.nextInt(ApiConstants.nicknamePrefixes.length)];
    final number = (100 + random.nextInt(900)).toString(); // 100 ~ 999
    return '$prefix$number';
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

  // 💡 포인트 기반 베팅 한도 계산
  double getMaxBet(double points) {
    final points = userPoints.toDouble();
    if (points >= 2000) return 1000;
    if (points >= 1000) return 500;
    // 보유 포인트가 1000 미만이면 본인의 포인트만큼만 베팅 가능
    return points.clamp(1, 100);
  }

  double get maxBetAmount => getMaxBet(userPoints.toDouble());
}
