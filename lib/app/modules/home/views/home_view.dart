import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import '../../../data/utils/logger.dart';
import '../../activity/views/activity_view.dart';
import '../../bet/views/bet_view.dart';
import '../../gacha/views/gacha_view.dart';
import '../controllers/home_controller.dart';
import '../widgets/user_profile_badge.dart';

class HomeView extends GetView<HomeController>
    with WindowListener, TrayListener {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    _initTrayAndWindow();
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: GetPlatform.isDesktop
              ? Text('공공놀이터')
              : Obx(() => Text('온라인 접속자 수: ${controller.onlineCount}명')),
          actions: [
            UserProfileBadge(),
          ],
        ),
        body: PageView(
          controller: controller.pageController,
          physics: const BouncingScrollPhysics(),
          children: [
            BetView(),
            const GachaView(),
            ActivityView(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
                icon: Text('📈', style: TextStyle(fontSize: 20)), label: '예측'),
            BottomNavigationBarItem(
                icon: Text('🖼️', style: TextStyle(fontSize: 20)), label: '작품'),
            BottomNavigationBarItem(
                icon: Text('🧾', style: TextStyle(fontSize: 20)), label: '활동'),
          ],
        ),
      );
    });
  }

  void _initTrayAndWindow() async {
    if (GetPlatform.isWindows) {
      windowManager.addListener(this); // 윈도우 리스너 등록
      trayManager.addListener(this); // 트레이 리스너 등록
      await trayManager.setToolTip('gonggong');
      await trayManager.setIcon('assets/icon/icon.ico');
      await trayManager.setContextMenu(Menu(
        items: [
          MenuItem(key: 'show', label: '창 열기'),
          MenuItem.separator(),
          MenuItem(key: 'exit', label: '종료'),
        ],
      ));
    }
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      windowManager.hide(); // 창 숨기기
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem item) {
    switch (item.key) {
      case 'show':
        windowManager.show();
        break;
      case 'exit':
        windowManager.destroy(); // 앱 완전 종료
        break;
    }
  }

  @override
  void onTrayIconRightMouseUp() async {
    await trayManager.popUpContextMenu(); // 수동으로 메뉴 표시
  }

  @override
  void onTrayIconMouseUp() async {
    await trayManager.popUpContextMenu(); // 모든 마우스 버튼에서 뜨도록
  }
}
