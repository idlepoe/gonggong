import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

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
      Get.snackbar("오류", "로그인 실패: $e");
    }
  }

  final List<String> nicknamePrefixes = [
    '강남의배당왕🐯',
    '강동의승부사🐲',
    '강북의올인러🃏',
    '강서의예측러🔮',
    '관악의물고기🎣',
    '광진의포인트헌터🦊',
    '구로의주사위🎲',
    '금천의배팅달인🐵',
    '노원의찬스왕🐶',
    '도봉의승률러📈',
    '동대문의파도타기🌊',
    '동작의핫핸드🔥',
    '마포의스탯러📊',
    '서대문의잔고부자💰',
    '서초의올인마스터🧙',
    '성동의한방러⚡️',
    '성북의도전왕👑',
    '송파의랠리러🏁',
    '양천의포인트먹깨비🍭',
    '영등포의배팅야수🐻',
    '용산의타짜🦈',
    '은평의박수꾼👏',
    '종로의예측신🎯',
    '중구의꾼🎩',
    '중랑의승부욕🐺',
  ];

  String generateRandomNickname() {
    final random = Random();
    final prefix = nicknamePrefixes[random.nextInt(nicknamePrefixes.length)];
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
        'nickname': nickname,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    FirebaseAuth.instance.currentUser!.updateDisplayName(nickname);
    FirebaseMessaging.instance.subscribeToTopic('user_$uid');
  }
}
