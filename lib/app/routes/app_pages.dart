import 'package:get/get.dart';

import '../modules/bet/bindings/bet_binding.dart';
import '../modules/bet/views/bet_view.dart';
import '../modules/gacha/bindings/gacha_binding.dart';
import '../modules/gacha/views/gacha_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/ranking/bindings/ranking_binding.dart';
import '../modules/ranking/views/ranking_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.GACHA,
      page: () => const GachaView(),
      binding: GachaBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.RANKING,
      page: () => const RankingView(),
      binding: RankingBinding(),
    ),
    GetPage(
      name: _Paths.BET,
      page: () => BetView(),
      binding: BetBinding(),
    ),
  ];
}
