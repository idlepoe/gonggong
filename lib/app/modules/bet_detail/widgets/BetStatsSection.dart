import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../data/models/measurement_info.dart';
import '../../bet/controllers/bet_card_stats_controller.dart';
import '../../bet/controllers/bet_controller.dart';
import '../../bet/widgets/interval_with_timer.dart';

class BetStatsSection extends StatelessWidget {
  final String betId;

  const BetStatsSection({super.key, required this.betId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BetCardStatsController>();

    return Obx(() {
      final stats = controller.statsMap[betId];
      if (stats == null) {
        return const Center(child: SizedBox());
      }
      MeasurementInfo? info = Get.find<BetController>().getInfoById(betId);
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "📊 퀴즈 통계",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                  "⬆ 총 참여액: ${stats.totalUp}P / 점수: ${stats.upOdds.toStringAsFixed(2)}"),
              Text(
                  "⬇ 총 참여액: ${stats.totalDown}P / 점수: ${stats.downOdds.toStringAsFixed(2)}"),
              const SizedBox(height: 12),
              if (info!.values.isNotEmpty)
                IntervalWithTimer(
                  interval: info.interval,
                  endDate: info.values.first.endDate,
                ),
            ],
          ),
        ),
      );
    });
  }
}
