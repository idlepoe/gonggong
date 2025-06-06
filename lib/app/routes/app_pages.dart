import 'package:get/get.dart';

import '../modules/activity/bindings/activity_binding.dart';
import '../modules/activity/views/activity_view.dart';
import '../modules/bet/bindings/bet_binding.dart';
import '../modules/bet/views/bet_view.dart';
import '../modules/bet_detail/bindings/bet_detail_binding.dart';
import '../modules/bet_detail/views/bet_detail_view.dart';
import '../modules/gacha/bindings/gacha_binding.dart';
import '../modules/gacha/views/gacha_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
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
      name: _Paths.BET,
      page: () => BetView(),
      binding: BetBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITY,
      page: () => const ActivityView(),
      binding: ActivityBinding(),
    ),
    GetPage(
      name: _Paths.BET_DETAIL,
      page: () => const BetDetailView(),
      binding: BetDetailBinding(),
    ),
  ];
}
