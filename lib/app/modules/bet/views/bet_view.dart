import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:gonggong/app/data/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/utils/logger.dart';
import '../../../data/widgets/button_loading.dart';
import '../controllers/bet_controller.dart';
import '../dialog/show_dust_level_info_dialog.dart';
import '../dialog/show_water_temp_info_dialog.dart';
import '../widgets/bet_card.dart';

class BetView extends GetView<BetController> {
  const BetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final allInfos = controller.measurementInfos.values.toList();
        final waterTempInfos =
            allInfos.where((e) => e.type_id == 'water_temp').toList();
        final dustLevelInfos =
            allInfos.where((e) => e.type_id == 'dust_level').toList();
        return allInfos.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                    ),
                    SizedBox(height: 30),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "배당률을 계산 중입니다...\n",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: "오를까? 내릴까? 숫자들이 싸우는 중이에요! 🤼‍♂️📊",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              )
            : CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverStickyHeader(
                    header: _buildHeader(
                      title: '서울시 주요지천 수온 측정 자료',
                      onInfoPressed: () async {
                        logger.i(await FirebaseMessaging.instance.getToken());
                        showWaterTempInfoDialog(context);
                      },
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final info = waterTempInfos[index];
                          return BetCard(info: info);
                        },
                        childCount: waterTempInfos.length,
                      ),
                    ),
                  ),
                  SliverStickyHeader(
                    header: _buildHeader(
                      title: '서울시 실시간 자치구별 미세먼지 현황',
                      onInfoPressed: () async {
                        logger.i(await FirebaseMessaging.instance.getToken());
                        showDustLevelInfoDialog(context);
                      },
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final info = dustLevelInfos[index];
                          return BetCard(info: info);
                        },
                        childCount: dustLevelInfos.length,
                      ),
                    ),
                  )
                ],
              );
      }),
    );
  }

  Widget _buildHeader(
      {required String title, required VoidCallback onInfoPressed}) {
    return Container(
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: onInfoPressed,
          ),
        ],
      ),
    );
  }
}
