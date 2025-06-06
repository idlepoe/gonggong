import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bet_detail_controller.dart';

class BetDetailView extends GetView<BetDetailController> {
  const BetDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BetDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BetDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
