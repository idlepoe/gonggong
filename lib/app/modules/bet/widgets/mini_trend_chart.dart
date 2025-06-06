import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../data/models/measurement_value.dart';
import 'detailed_trend_chart.dart';

class MiniTrendChart extends StatelessWidget {
  final List<MeasurementValue> values;
  final String title;

  const MiniTrendChart({
    super.key,
    required this.values,
    this.title = '상세 차트',
  });

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) return const SizedBox(width: 100, height: 60);

    final reversed = values.reversed.toList(); // 시간 순 정렬
    final spots = reversed.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.value);
    }).toList();

    final start = reversed.first.value;
    final end = reversed.last.value;
    final isUp = end >= start;
    final color = isUp ? Colors.green : Colors.red;

    final minValue = values.map((v) => v.value).reduce((a, b) => a < b ? a : b);
    final maxValue = values.map((v) => v.value).reduce((a, b) => a > b ? a : b);

    return GestureDetector(
      onTap: () {
        final reversed = values.reversed.toList();

        final detailSpots = reversed
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.value))
            .toList();

        final timeLabels = reversed
            .map((v) =>
        "${v.startDate.hour.toString().padLeft(2, '0')}:${v.startDate.minute.toString().padLeft(2, '0')}")
            .toList();

        final minValue = values.map((v) => v.value).reduce((a, b) => a < b ? a : b) - 0.5;
        final maxValue = values.map((v) => v.value).reduce((a, b) => a > b ? a : b) + 0.5;

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: detailSpots.length * 50, // 가변 너비 확보
                  child: DetailedTrendChart(
                    title: '상세차트',
                    spots: detailSpots,
                    timeLabels: timeLabels,
                    minY: minValue,
                    maxY: maxValue,
                  ),
                ),
              ),
            );
          },
        );
      },
      child: SizedBox(
        width: 100,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(enabled: false),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              minY: minValue,
              maxY: maxValue,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: color,
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withOpacity(0.2),
                  ),
                  dotData: FlDotData(show: false),
                  barWidth: 2,
                )
              ],
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: maxValue,
                    color: Colors.grey.shade500,
                    strokeWidth: 0.5,
                    dashArray: [4, 2],
                    label: HorizontalLineLabel(
                      show: true,
                      labelResolver: (_) => maxValue.toStringAsFixed(1),
                      alignment: Alignment.topLeft,
                      style:
                          const TextStyle(fontSize: 10, color: Colors.black87),
                    ),
                  ),
                  HorizontalLine(
                    y: minValue,
                    color: Colors.grey.shade500,
                    strokeWidth: 0.5,
                    dashArray: [4, 2],
                    label: HorizontalLineLabel(
                      show: true,
                      labelResolver: (_) => minValue.toStringAsFixed(1),
                      alignment: Alignment.bottomLeft,
                      style:
                          const TextStyle(fontSize: 10, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
