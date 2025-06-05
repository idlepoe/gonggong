import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bet_controller.dart';
import '../widgets/expandable_bet_card.dart';

class BetView extends GetView<BetController> {
  const BetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("도전 베팅")),
      body: Obx(() {
        final infos = controller.measurementInfos.values.toList();

        return infos.isEmpty
            ? ListView(
                // RefreshIndicator는 반드시 스크롤 가능 위젯이 필요
                children: [
                  SizedBox(
                      height: 300,
                      child: Center(child: CircularProgressIndicator())),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: infos.length,
                itemBuilder: (context, index) {
                  final info = infos[index];
                  if (info.values.length < 2) return const SizedBox.shrink();

                  final recent = info.values[0].value;
                  final previous = info.values[1].value;
                  final probability =
                      ((recent - previous).clamp(-5, 5) / 10 + 0.5)
                          .clamp(0.0, 1.0);

                  return ExpandableBetCard(
                    info: info,
                  );
                },
              );
      }),
    );
  }
}
