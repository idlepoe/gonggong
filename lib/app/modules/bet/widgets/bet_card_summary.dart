import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/bet.dart';
import '../../../data/widgets/button_loading.dart';
import '../controllers/bet_card_stats_controller.dart';
import '../controllers/bet_controller.dart';

class BetCardSummary extends StatelessWidget {
  final Bet bet;
  final VoidCallback onCancel;

  const BetCardSummary({super.key, required this.bet, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🪙 퀴즈 금액: ${bet.amount.toStringAsFixed(0)}P",
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            "💸 취소 시 반환 금액: ${(bet.amount * 0.85).floor()}P",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text("📊 퀴즈: "),
              Text(
                bet.direction == 'up' ? "오를 것 같아" : "내릴 것 같아",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.black87,
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed:
                Get.find<BetController>().isLoading.value
                    ? null
                    : () async {
                      await Get.find<BetController>().cancelBet(bet);
                      onCancel();
                    },
            child:
                Get.find<BetController>().isLoading.value
                    ? ButtonLoading()
                    : const Text("퀴즈 취소"),
          ),
        ],
      ),
    );
  }
}
