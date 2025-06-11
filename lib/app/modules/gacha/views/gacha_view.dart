import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/gacha_controller.dart';
import '../widgets/artwork_grid_view.dart';
import '../widgets/gacha_fab.dart';

class GachaView extends GetView<GachaController> {
  const GachaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎨 서울시립미술관"),
        actions: [
          Obx(
            () => Row(
              children: [
                const Text('미보유 포함'),
                Checkbox(
                  value: controller.showUnowned.value,
                  onChanged:
                      (value) => controller.showUnowned.value = value ?? false,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.artworks.isEmpty && controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(strokeCap: StrokeCap.round),
          );
        }
        return ArtworkGridView();
      }),
      floatingActionButton: const GachaFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
