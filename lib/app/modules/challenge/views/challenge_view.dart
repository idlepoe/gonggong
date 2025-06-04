import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/challenge.dart';
import '../../../data/models/water_measurement.dart';
import '../controllers/challenge_controller.dart';
import '../widgets/mini_chart.dart';
import '../widgets/water_up_down_bet_sheet.dart';

class ChallengeView extends GetView<ChallengeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchMeasurements(); // 다시 불러오기
          },
          child: controller.measurements.isEmpty
              ? ListView(
                  // RefreshIndicator는 반드시 scrollable child가 필요
                  children: const [
                    SizedBox(height: 200),
                    Center(child: CircularProgressIndicator()),
                  ],
                )
              : buildGroupedWaterList(controller.groupedBySite),
        );
      }),
    );
  }
}

Widget buildGroupedWaterList(Map<String, List<WaterMeasurement>> grouped) {
  return ListView(
    children: grouped.entries.map((entry) {
      final siteId = entry.key;
      final list = entry.value;

      final current = getCurrentTemp(list);
      final delta1h = getDelta(list, Duration(hours: 1, minutes: 1));
      final delta24h = getDelta(list, Duration(hours: 24, minutes: 1));

      final odds = calculateOdds(list); // ✅ 여기서 odds 계산
      final oddsUp = odds['up']!;
      final oddsDown = odds['down']!;

      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final infoWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "현재 수온: ${current?.toStringAsFixed(1) ?? '-'}℃",
                    style: const TextStyle(
                      color: Colors.blueAccent, // ✅ 파란색 강조
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: '1시간: ',
                      children: [
                        TextSpan(
                          text: formatDelta(delta1h),
                          style: TextStyle(
                            color: getDeltaColor(delta1h),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: '24시간: ',
                      children: [
                        TextSpan(
                          text: formatDelta(delta24h),
                          style: TextStyle(
                            color: getDeltaColor(delta24h),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(siteId,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Divider(height: 5, color: Colors.grey),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: infoWidget),
                      const SizedBox(width: 16),
                      buildMiniChart(list),
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () {
                          showWaterUpDownBetSheet(
                            context: context,
                            siteId: siteId,
                            currentTemp: current ?? 0.0,
                            oddsUp: oddsUp,
                            oddsDown: oddsDown,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    }).toList(),
  );
}

String formatDelta(double? value) {
  if (value == null) return '-';
  final abs = value.abs().toStringAsFixed(2);
  return value > 0
      ? '+$abs℃'
      : value < 0
          ? '-$abs℃'
          : '±0.00℃';
}

Color getDeltaColor(double? value) {
  if (value == null) return Colors.grey;
  if (value > 0) return Colors.green;
  if (value < 0) return Colors.red;
  return Colors.grey;
}

Map<String, double> calculateOdds(List<WaterMeasurement> list,
    {double delta = 0.3}) {
  final deltas = <double>[];

  for (int i = 1; i < list.length; i++) {
    final prev = double.tryParse(list[i - 1].W_TEMP);
    final curr = double.tryParse(list[i].W_TEMP);
    if (prev != null && curr != null) {
      deltas.add(curr - prev);
    }
  }

  final upCount = deltas.where((d) => d >= delta).length;
  final downCount = deltas.where((d) => d <= -delta).length;
  final total = deltas.length;

  final probUp = upCount / (total == 0 ? 1 : total);
  final probDown = downCount / (total == 0 ? 1 : total);

  final oddsUp = double.parse(
      (1 / (probUp > 0 ? probUp : 0.01)).clamp(1.0, 5.0).toStringAsFixed(1));
  final oddsDown = double.parse((1 / (probDown > 0 ? probDown : 0.01))
      .clamp(1.0, 5.0)
      .toStringAsFixed(1));

  return {
    'up': oddsUp,
    'down': oddsDown,
  };
}
