import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/constants/api_constants.dart';
import '../../../data/widgets/show_app_snackbar.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    _signInAnonymously();
    super.onInit();
  }

  Future<void> _signInAnonymously() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await ensureUserProfileExists(user.uid);
        // 다음 화면 이동
        Get.offAllNamed(Routes.HOME);
      } else {
        await FirebaseAuth.instance.signInAnonymously();
        _signInAnonymously();
      }
    } catch (e) {
      showAppSnackbar("오류", "로그인 실패: $e");
    }
  }

  String generateRandomNickname() {
    final random = Random();
    final prefix = ApiConstants
        .nicknamePrefixes[random.nextInt(ApiConstants.nicknamePrefixes.length)];
    final number = (100 + random.nextInt(900)).toString(); // 100 ~ 999
    return '$prefix$number';
  }

  Future<void> ensureUserProfileExists(String uid) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await docRef.get();

    final nickname = generateRandomNickname();

    if (!snapshot.exists) {
      await docRef.set({
        'points': 1000,
        'name': nickname,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    FirebaseAuth.instance.currentUser!.updateDisplayName(nickname);
    if (!kIsWeb) {
      FirebaseMessaging.instance.subscribeToTopic('user_$uid');
    }
  }
}
