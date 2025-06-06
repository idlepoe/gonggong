import 'package:flutter/material.dart';

import '../../../data/models/measurement_info.dart';
import '../../../data/widgets/build_linkable_question.dart';
import 'mini_trend_chart.dart';

class BetCardHeader extends StatelessWidget {
  final MeasurementInfo info;

  const BetCardHeader({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final last = info.values.firstOrNull?.value;
    final subtitle = "${info.type_name} ${last?.toStringAsFixed(1) ?? '-'}${info.unit}";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          info.type_id == "water_temp"
              ? "assets/images/ic_water_temp.png"
              : "assets/images/ic_dust_level.png",
          height: 40,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLinkableQuestion(info.question, info.site_name),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        MiniTrendChart(values: info.values),
      ],
    );
  }
}
