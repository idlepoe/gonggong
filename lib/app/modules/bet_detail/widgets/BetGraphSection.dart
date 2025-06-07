import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../data/models/measurement_value.dart';
import '../../bet/controllers/bet_controller.dart';
import '../../bet/widgets/detailed_trend_chart.dart';

class BetGraphSection extends StatelessWidget {
  final String betId;

  const BetGraphSection({super.key, required this.betId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BetController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          final info = controller.measurementInfos[betId];
          if (info == null || info.values.isEmpty) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.all(16),
              child: Text("📉 차트 정보를 불러오는 중이거나 데이터가 없습니다."),
            ));
          }

          final values = info.values.reversed.toList();
          final spots = values
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.value))
              .toList();

          final timeLabels = values
              .map((v) => "${v.startDate.hour.toString().padLeft(2, '0')}:00")
              .toList();

          final minY =
              values.map((v) => v.value).reduce((a, b) => a < b ? a : b) - 0.5;
          final maxY =
              values.map((v) => v.value).reduce((a, b) => a > b ? a : b) + 0.5;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: DetailedTrendChart(
              title: info.question,
              spots: spots,
              timeLabels: timeLabels,
              minY: minY,
              maxY: maxY,
            ),
          );
        }),
      ),
    );
  }
}
