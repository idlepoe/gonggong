import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/measurement_info.dart';
import '../../../data/widgets/button_loading.dart';
import '../controllers/bet_card_stats_controller.dart';
import '../controllers/bet_controller.dart';

class BetCardForm extends StatelessWidget {
  final MeasurementInfo info;
  final TextEditingController controller;
  final double amount;
  final bool bettingUp;
  final Color color;
  final String label;
  final void Function(double) onAmountChanged;
  final VoidCallback onClose;
  final VoidCallback onSubmit;

  const BetCardForm({
    super.key,
    required this.info,
    required this.controller,
    required this.amount,
    required this.bettingUp,
    required this.color,
    required this.label,
    required this.onAmountChanged,
    required this.onClose,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = Get.find<BetController>().isLoading.value;
    final stats = Get.find<BetCardStatsController>()
        .getStats(info.site_id, info.type_id);

    final rate = bettingUp ? stats?.upRate ?? 0.5 : stats?.downRate ?? 0.5;
    final odds = bettingUp ? stats?.upOdds ?? 2.0 : stats?.downOdds ?? 2.0;
    final reward = (amount * odds).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "${info.question} (${(rate * 100).toStringAsFixed(0)}%)",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(icon: const Icon(Icons.close), onPressed: onClose, splashRadius: 16),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: OutlineInputBorder(), prefixText: "\$"),
          onChanged: (value) {
            final parsed = double.tryParse(value);
            if (parsed != null) onAmountChanged(parsed);
          },
        ),
        const SizedBox(height: 12),
        Slider(
          value: amount,
          min: 1,
          max: 100,
          divisions: 99,
          label: "${amount.toStringAsFixed(0)}P",
          onChanged: onAmountChanged,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: isLoading ? null : onSubmit,
          child: isLoading
              ? ButtonLoading()
              : Text(
            "$label (${odds.toStringAsFixed(2)}x)\n예상 수익: ${reward}P",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
