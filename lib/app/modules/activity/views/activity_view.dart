import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/models/activity.dart';
import '../controllers/activity_controller.dart';
import '../widgets/activity_card.dart';

class ActivityView extends StatelessWidget {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ActivityController());

    return Scaffold(
      appBar: AppBar(title: const Text('활동')),
      body: Obx(() {
        if (controller.activities.isEmpty) {
          return const Center(child: Text('아직 활동이 없습니다.'));
        }

        return ListView.builder(
          itemCount: controller.activities.length,
          itemBuilder: (context, index) {
            Activity row = controller.activities[index];
            return ActivityCard(activity: row);
          },
        );
      }),
    );
  }
}
