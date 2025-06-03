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
      final cred = await FirebaseAuth.instance.signInAnonymously();
      print("✅ 로그인 성공: ${cred.user?.uid}");
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar("오류", "로그인 실패: $e");
    }
  }
}
