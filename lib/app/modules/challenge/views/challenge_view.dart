import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/challenge_controller.dart';

class ChallengeView extends GetView<ChallengeController> {
  const ChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.challenges;

      return RefreshIndicator(
        onRefresh: controller.fetchChallenges,
        child: list.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: Get.height * 0.3),
            Center(child: Text('no_bets_yet'.tr)),
          ],
        )
            : ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final challenge = list[index];
            final now = DateTime.now();
            final isExpired = challenge.deadline.isBefore(now);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: isExpired ? Colors.grey.shade200 : Colors.white,
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("🎯", style: TextStyle(fontSize: 24)),
                  ],
                ),
                title: Text(
                  challenge.title,
                  style: TextStyle(
                    color: isExpired ? Colors.grey : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${challenge.siteId} • ${DateFormat('HH:mm').format(challenge.deadline)} ${'deadline'.tr}',
                      style: TextStyle(color: isExpired ? Colors.grey : null),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.water_drop, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text('${challenge.baseValue}℃'),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Icon(Icons.flag, size: 16, color: Colors.redAccent),
                        const SizedBox(width: 4),
                        Text('${challenge.targetValue}℃'),
                      ],
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${challenge.odds.toStringAsFixed(1)}x',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isExpired ? Colors.grey : Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: isExpired
                    ? null
                    : () {
                  // TODO: 베팅 상세 또는 참여
                },
              ),
            );
          },
        ),
      );
    });
  }
}