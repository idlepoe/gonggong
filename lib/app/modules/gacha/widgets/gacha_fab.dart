import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/gacha_controller.dart';

class GachaFAB extends StatelessWidget {
  const GachaFAB({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GachaController>();

    return Obx(
      () => FloatingActionButton(
        onPressed: controller.isLoading.value ? null : controller.drawGacha,
        backgroundColor: Colors.lightBlue,
        child: controller.isLoading.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Icon(Icons.casino, color: Colors.white),
        tooltip: "🎲 뽑기!",
        mini: true,
      ),
    );
  }
}
