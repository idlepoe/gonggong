import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showWaterUpDownBetSheet({
  required BuildContext context,
  required String siteId,
  required double currentTemp,
  required double oddsUp,
  required double oddsDown,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "지금 $siteId의 수온은 ${currentTemp.toStringAsFixed(1)}℃입니다.",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              "앞으로 1시간 안에 수온이 오를까요, 내릴까요?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: placeBet('up');
                  },
                  icon: const Icon(Icons.arrow_upward, color: Colors.white),
                  label: Text(
                    'UP (${oddsUp.toStringAsFixed(1)}x)',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: placeBet('down');
                  },
                  icon: const Icon(Icons.arrow_downward, color: Colors.white),
                  label: Text(
                    'DOWN (${oddsDown.toStringAsFixed(1)}x)',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
