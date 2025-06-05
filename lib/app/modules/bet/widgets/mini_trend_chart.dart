import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../data/models/measurement_value.dart';

class MiniTrendChart extends StatelessWidget {
  final List<MeasurementValue> values;

  const MiniTrendChart({super.key, required this.values});

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

    return SizedBox(
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
                    style: const TextStyle(fontSize: 10, color: Colors.black87),
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
                    style: const TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
