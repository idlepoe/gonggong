import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/gacha_controller.dart';

class GachaView extends GetView<GachaController> {
  const GachaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GachaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'GachaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
