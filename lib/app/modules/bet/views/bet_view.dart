import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bet_controller.dart';
import '../widgets/bet_card.dart';

class BetView extends GetView<BetController> {
  const BetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  return BetCard(
                    info: info,
                  );
                },
              );
      }),
    );
  }
}
