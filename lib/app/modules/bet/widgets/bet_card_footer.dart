import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/measurement_info.dart';
import '../controllers/bet_card_stats_controller.dart';
import '../controllers/bet_controller.dart';
import 'interval_with_timer.dart';

class BetCardFooter extends StatelessWidget {
  final MeasurementInfo info;

  const BetCardFooter({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stats = Get.find<BetCardStatsController>()
          .getStats(info.site_id, info.type_id);
      final total = stats?.total ?? 0;
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.monetization_on_outlined, size: 18, color: Colors.orange),
              const SizedBox(width: 4),
              Text("$total pt",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
            ],
          ),
          SizedBox(width: 8),
          IntervalWithTimer(
            interval: info.interval,
            endDate: info.values.first.endDate,
          ),
          Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () => Get.find<BetController>().toggleFavorite(info),
            child: Obx(() {
              final isFav = Get.find<BetController>().isFavorite(info);
              return Icon(
                isFav ? Icons.bookmark : Icons.bookmark_border,
                size: 20,
                color: isFav ? Colors.orange : Colors.grey.shade600,
              );
            }),
          ),
        ],
      );
    });
  }
}
