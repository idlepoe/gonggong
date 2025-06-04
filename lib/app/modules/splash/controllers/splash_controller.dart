import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> ensureUserProfileExists(String uid) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      await docRef.set({
        'points': 1000,
        'nickname': '신입물고기🐟',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
