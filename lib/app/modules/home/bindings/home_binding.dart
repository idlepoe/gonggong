import 'package:get/get.dart';
import 'package:gonggong/app/modules/gacha/controllers/gacha_controller.dart';
import 'package:gonggong/app/modules/profile/controllers/profile_controller.dart';
import 'package:gonggong/app/modules/ranking/controllers/ranking_controller.dart';

import '../../bet/controllers/bet_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());

    Get.put<BetController>(BetController());
    Get.put<GachaController>(GachaController());
    Get.put<RankingController>(RankingController());
    Get.put<ProfileController>(ProfileController());
  }
}
