import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;
  final RxInt onlineCount = 0.obs;

  final FirebaseDatabase database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://gong-nol-default-rtdb.asia-southeast1.firebasedatabase.app",
  );

  void changePage(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  @override
  void onInit() {
    super.onInit();
    registerOnlineStatus().then(
      (value) {
        listenToOnlineUsers();
        requestPushPermissionIfNeeded();
      },
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> registerOnlineStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = database.ref('presence/$uid');

    await ref.set(true); // 접속 중임을 표시
    await ref.onDisconnect().remove(); // 연결 끊기면 자동 제거
  }

  void listenToOnlineUsers() {
    final presenceRef = database.ref('presence');
    presenceRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      onlineCount.value = data?.length ?? 0;
    });
  }

  Future<void> requestPushPermissionIfNeeded() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        print('✅ 푸시 알림 권한 허용됨');
      } else {
        print('❌ 푸시 알림 권한 거부됨');
      }
    } else {
      print('✅ 이미 푸시 알림 권한 있음');
    }
  }
}
