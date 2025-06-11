import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bet_detail_controller.dart';
import '../widgets/BetActionButtons.dart';
import '../widgets/BetDiscussionSection.dart';
import '../widgets/BetGraphSection.dart';
import '../widgets/BetStatsSection.dart';

class BetDetailView extends GetView<BetDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("퀴즈 상세"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: BetGraphSection(betId: controller.betId)),
          SliverToBoxAdapter(child: BetStatsSection(betId: controller.betId)),
          SliverToBoxAdapter(child: BetActionButtons()),
          const SliverToBoxAdapter(
              child: Divider(
            color: Colors.grey,
            indent: 20,
            endIndent: 20,
          )),
          SliverFillRemaining(
            hasScrollBody: true,
            child: BetDiscussionSection(betId: controller.betId),
          ),
        ],
      ),
    );
  }
}
