import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../challenge/views/challenge_view.dart';
import '../../gacha/views/gacha_view.dart';
import '../../profile/views/profile_view.dart';
import '../../ranking/views/ranking_view.dart';
import '../controllers/home_controller.dart';
import '../widgets/user_profile_badge.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Obx(() => Text('온라인 접속자 수: ${controller.onlineCount}명')),
          actions: [
            UserProfileBadge(),
          ],
        ),
        body: PageView(
          controller: controller.pageController,
          physics: const BouncingScrollPhysics(),
          children: [
            ChallengeView(),
            const GachaView(),
            const RankingView(),
            const ProfileView(),
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
                icon: Text('🎯', style: TextStyle(fontSize: 20)),
                label: 'challenge'),
            BottomNavigationBarItem(
                icon: Text('🎁', style: TextStyle(fontSize: 20)),
                label: 'gacha'),
            BottomNavigationBarItem(
                icon: Text('🏆', style: TextStyle(fontSize: 20)),
                label: 'ranking'),
            BottomNavigationBarItem(
                icon: Text('👤', style: TextStyle(fontSize: 20)),
                label: 'profile'),
          ],
        ),
      );
    });
  }
}
