import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import '../../../data/constants/api_constants.dart';
import '../../../data/controllers/profile_controller.dart';
import '../../../data/widgets/show_app_snackbar.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final statusText = '앱 업데이트 확인 중...'.obs;
  final updater = ShorebirdUpdater();

  @override
  void onInit() {
    super.onInit();
    _checkForUpdateAndSignIn();
  }

  Future<void> _checkForUpdateAndSignIn() async {
    try {
      final status = await updater.checkForUpdate();

      if (status == UpdateStatus.outdated) {
        statusText.value = '업데이트 다운로드 중...';
        await updater.update(); // 자동 다운로드 + 재시작

        // 다운로드 후 상태를 주기적으로 확인
        await _waitForRestartRequired();
        return;
      }

      if (status == UpdateStatus.unavailable) {
        statusText.value = '업데이트 확인 실패. 계속 진행합니다.';
        await Future.delayed(const Duration(seconds: 2));
      }

      // 업데이트가 없거나 실패한 경우 로그인 진행
      await _signInAnonymously();
    } catch (e) {
      showAppSnackbar("오류", "업데이트 확인 중 오류: $e");
      await _signInAnonymously();
    }
  }

  Future<void> _waitForRestartRequired() async {
    statusText.value = '업데이트 적용 대기 중...';

    while (true) {
      final status = await updater.checkForUpdate();
      if (status == UpdateStatus.restartRequired) {
        statusText.value = '업데이트 완료! 앱을 재시작합니다.';

        // 안내 메시지를 잠시 보여주고 재시작
        await Future.delayed(const Duration(seconds: 2));
        _restartApp();
        return;
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  void _restartApp() {
    if (GetPlatform.isWindows) {
      // Windows용 간단 재시작 방법 (실행 파일명 알아야 함)
      Process.run('cmd', ['/c', 'start', 'gonggong.exe']); // EXE 이름에 맞게 수정
      exit(0);
    } else {
      Restart.restartApp(); // shorebird 업데이트 후 restart
    }
  }

  Future<void> _signInAnonymously() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await ensureUserProfileExists(user.uid);
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
    if (!GetPlatform.isWeb && !GetPlatform.isWindows) {
      FirebaseMessaging.instance.subscribeToTopic('user_$uid');
    }

    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().initProfileStream();
    }
  }
}
