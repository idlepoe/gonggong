import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:gonggong/app/data/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/utils/logger.dart';
import '../controllers/bet_controller.dart';
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

        return CustomScrollView(
          slivers: [
            SliverStickyHeader(
              header: _buildHeader(
                title: '서울시 한강 및 주요지천 수질 측정 자료',
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
            // SliverStickyHeader(
            //   header: _buildHeader(title: '다른 섹션', onInfoPressed: () {}),
            //   sliver: SliverList(
            //     delegate: SliverChildBuilderDelegate(
            //       (context, index) => ListTile(title: Text('기타 항목 $index')),
            //       childCount: 20,
            //     ),
            //   ),
            // )
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
