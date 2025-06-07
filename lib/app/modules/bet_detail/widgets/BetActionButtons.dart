import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/controllers/profile_controller.dart';
import '../../../data/models/bet.dart';
import '../../../data/models/measurement_info.dart';
import '../../../data/widgets/button_loading.dart';
import '../../bet/controllers/bet_card_stats_controller.dart';
import '../../bet/controllers/bet_controller.dart';
import '../../bet/widgets/bet_card_summary.dart';
import '../controllers/bet_detail_controller.dart';

class BetActionButtons extends StatefulWidget {
  const BetActionButtons({super.key});

  @override
  State<BetActionButtons> createState() => _BetActionButtonsState();
}

class _BetActionButtonsState extends State<BetActionButtons> {
  late final TextEditingController _controller;
  double amount = 100;

  @override
  void initState() {
    super.initState();
    initAmount();
  }

  void initAmount() {
    final profileController = Get.find<ProfileController>();
    final maxBet = profileController.maxBetAmount;

    amount = maxBet.toDouble(); // ✅ 초기 amount 설정
    _controller = TextEditingController(text: amount.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      MeasurementInfo? info = Get.find<BetController>()
          .getInfoById(Get.find<BetDetailController>().betId);
      final myBet = info!.myBet;

      var betController = Get.find<BetController>();
      bool isLoading = betController.isLoading.value;

      if (myBet != null) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BetCardSummary(
              bet: myBet,
              onCancel: () async {
                await Get.find<BetController>().cancelBet(myBet);
                // 화면 상태 갱신 필요 시 여기에 추가
                Get.find<BetDetailController>().refreshData();
              },
            ),
          ),
        );
      }

      final stats = Get.find<BetCardStatsController>()
          .getStats(info.site_id, info.type_id);

      final upRate = stats?.upRate ?? 0.5;
      final downRate = stats?.downRate ?? 0.5;
      final upOdds = (1 / upRate).clamp(1.1, 10.0);
      final downOdds = (1 / downRate).clamp(1.1, 10.0);

      final profile = Get.find<BetController>();
      final maxBet = profile.isLoading.value
          ? 1000
          : Get.find<ProfileController>().maxBetAmount;

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ✅ 숫자 입력창
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  labelText: "베팅 포인트 입력",
                  border: OutlineInputBorder(),
                  suffixText: "P",
                ),
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null && parsed >= 1 && parsed <= maxBet) {
                    setState(() {
                      amount = parsed;
                    });
                  }
                },
              ),

              const SizedBox(height: 12),

              // ✅ 슬라이더
              Slider(
                value: amount,
                min: 1,
                max: maxBet.toDouble().clamp(1, 1000),
                divisions: maxBet > 1 ? (maxBet - 1).toInt() : null,
                label: "${amount.toStringAsFixed(0)}P",
                onChanged: isLoading
                    ? null
                    : (value) {
                        setState(() {
                          amount = value;
                          _controller.text = value.toStringAsFixed(0);
                        });
                      },
              ),
              const SizedBox(height: 12),

              // ✅ 버튼 2개
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade100,
                        foregroundColor: Colors.green.shade900,
                      ),
                      onPressed: isLoading
                          ? null
                          : () =>
                              _placeBet(info, true, amount, upOdds.toDouble()),
                      child: isLoading
                          ? ButtonLoading()
                          : Column(
                              children: [
                                const Text("오를 것 같아"),
                                Text("${(upRate * 100).toStringAsFixed(0)}%",
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        foregroundColor: Colors.red.shade900,
                      ),
                      onPressed: isLoading
                          ? null
                          : () => _placeBet(
                              info, false, amount, downOdds.toDouble()),
                      child: isLoading
                          ? ButtonLoading()
                          : Column(
                              children: [
                                const Text("내릴 것 같아"),
                                Text("${(downRate * 100).toStringAsFixed(0)}%",
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _placeBet(
      MeasurementInfo info, bool up, double amount, double odds) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final bet = Bet(
      uid: user.uid,
      site_id: info.site_id,
      type_id: info.type_id,
      direction: up ? 'up' : 'down',
      amount: amount,
      odds: odds,
      userName: user.displayName,
      avatarUrl: user.photoURL,
      question: info.question,
      createdAt: DateTime.now(),
    );

    await Get.find<BetController>().placeBet(bet);
    Get.find<BetDetailController>().refreshData();
  }
}
