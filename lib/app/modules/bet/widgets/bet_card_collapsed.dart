import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/measurement_info.dart';
import '../../../data/widgets/button_loading.dart';
import '../controllers/bet_card_stats_controller.dart';
import '../controllers/bet_controller.dart';

class BetCardCollapsed extends StatelessWidget {
  final MeasurementInfo info;
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;

  const BetCardCollapsed({
    super.key,
    required this.info,
    required this.onUpPressed,
    required this.onDownPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = Get.find<BetController>().isLoading.value;
      final stats = Get.find<BetCardStatsController>()
          .getStats(info.site_id, info.type_id);
      final upRate = stats?.upRate ?? 0.5;
      final downRate = stats?.downRate ?? 0.5;
      return Row(
        key: const ValueKey('collapsed'),
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isLoading ? null : onUpPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade100,
                foregroundColor: Colors.green.shade800,
              ),
              child: isLoading
                  ? ButtonLoading()
                  : Column(
                      children: [
                        const Text("오를 것 같아"),
                        Text("${(upRate * 100).toStringAsFixed(0)}%",
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: isLoading ? null : onDownPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade800,
              ),
              child: isLoading
                  ? ButtonLoading()
                  : Column(
                      children: [
                        const Text("내릴 것 같아"),
                        Text("${(downRate * 100).toStringAsFixed(0)}%",
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
            ),
          ),
        ],
      );
    });
  }
}
