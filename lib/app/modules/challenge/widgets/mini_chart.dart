import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/water_measurement.dart';

Widget buildMiniChart(List<WaterMeasurement> list) {
  if (list.length < 2) return const Text("데이터 부족");

  final validList = list
      .where((e) => double.tryParse(e.W_TEMP) != null && e.createdAt != null)
      .toList();

  if (validList.length < 2) return const Text("유효 데이터 부족");

  final spots = validList.map((e) {
    return FlSpot(
      e.createdAt!.millisecondsSinceEpoch.toDouble() / 1000,
      double.parse(e.W_TEMP),
    );
  }).toList();

  final start = double.parse(validList.first.W_TEMP);
  final end = double.parse(validList.last.W_TEMP);
  final min = validList
      .map((e) => double.parse(e.W_TEMP))
      .reduce((a, b) => a < b ? a : b);
  final max = validList
      .map((e) => double.parse(e.W_TEMP))
      .reduce((a, b) => a > b ? a : b);
  final delta24h = end - start;
  final lineColor = delta24h >= 0 ? Colors.green : Colors.red;

  const chartWidth = 180.0;
  const chartHeight = 80.0;

  return SizedBox(
    width: chartWidth,
    height: chartHeight,
    child: Stack(
      children: [
        // 배경 차트
        Positioned.fill(
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  barWidth: 2,
                  color: lineColor,
                  dotData: FlDotData(show: false),
                ),
              ],
              minY: min - 0.5,
              maxY: max + 0.5,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(show: false),
            ),
          ),
        ),

        // 우측 하단 수온 정보
        // Positioned(
        //   right: 0,
        //   bottom: 0,
        //   child: Row(
        //     children: [
        //       _labelWithIcon("🔺 최고", max),
        //       _labelWithIcon("🔻 최저", min),
        //     ],
        //   ),
        // ),
      ],
    ),
  );
}

Widget _labelWithIcon(String label, double value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const SizedBox(width: 4),
        Text(
          '${value.toStringAsFixed(1)}℃',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

double? getCurrentTemp(List<WaterMeasurement> list) {
  final last = list.lastOrNull;
  return last != null ? double.tryParse(last.W_TEMP) : null;
}

double? getDelta(List<WaterMeasurement> list, Duration duration) {
  if (list.isEmpty) return null;

  // 최신 값 (마지막 측정 기준)
  final base = list.last;
  final baseTime = base.measuredAt;
  if (baseTime == null) return null;

  final cutoff = baseTime.subtract(duration);

  // 기준 시간 이전 중 가장 가까운 데이터
  final reference = list
      .where((e) =>
          e.measuredAt != null &&
          e.measuredAt!.isBefore(baseTime) &&
          e.measuredAt!.isAfter(cutoff))
      .firstOrNull;

  if (reference == null) return null;

  final curr = double.tryParse(base.W_TEMP);
  final prev = double.tryParse(reference.W_TEMP);

  if (curr == null || prev == null) return null;

  return curr - prev;
}

extension WaterMeasurementTime on WaterMeasurement {
  DateTime? get measuredAt {
    if (MSR_DATE == null || MSR_TIME == null) return null;

    try {
      final datePart = MSR_DATE!; // "20250603"
      final timePart = MSR_TIME!; // "22:00"

      final year = int.parse(datePart.substring(0, 4));
      final month = int.parse(datePart.substring(4, 6));
      final day = int.parse(datePart.substring(6, 8));
      final hour = int.parse(timePart.split(":")[0]);
      final minute = int.parse(timePart.split(":")[1]);

      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }
}
