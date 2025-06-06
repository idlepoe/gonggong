import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/utils/logger.dart';
import '../../activity/views/activity_view.dart';
import '../../bet/views/bet_view.dart';
import '../../gacha/views/gacha_view.dart';
import '../controllers/home_controller.dart';
import '../widgets/user_profile_badge.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Obx(() => InkWell(
              onTap: () async {
                await FirebaseMessaging.instance.subscribeToTopic(
                    'user_${FirebaseAuth.instance.currentUser!.uid}');

                logger.d(await FirebaseMessaging.instance.getToken());
              },
              child: Text('온라인 접속자 수: ${controller.onlineCount}명'))),
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
}
