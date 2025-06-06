import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gonggong/app/data/widgets/button_loading.dart';
import '../../../data/models/bet.dart';
import '../../../data/models/measurement_info.dart';
import '../../../data/widgets/build_linkable_question.dart';
import '../controllers/bet_controller.dart';
import 'interval_with_timer.dart';
import 'mini_trend_chart.dart';

class ExpandableBetCard extends StatefulWidget {
  final MeasurementInfo info;

  const ExpandableBetCard({super.key, required this.info});

  @override
  State<ExpandableBetCard> createState() => _ExpandableBetCardState();
}

class _ExpandableBetCardState extends State<ExpandableBetCard> {
  bool expanded = false;
  bool bettingUp = true;
  double amount = 100;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: amount.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateAmount(double value) {
    if (value > 100) value = 100;
    setState(() {
      amount = value;
      _controller.text = value.toStringAsFixed(0);
    });
  }

  void toggle(bool up) {
    setState(() {
      bettingUp = up;
      expanded = true;
    });
  }

  void collapse() {
    setState(() {
      expanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    final last = info.values.firstOrNull?.value;
    final typeName = info.type_name;
    final unit = info.unit;
    final subtitle = "$typeName ${last?.toStringAsFixed(1) ?? '-'}$unit";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단: 아이콘 + 질문 + 미니 차트
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/images/ic_water_temp.png", height: 40),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildLinkableQuestion(info.question, info.site_name),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(color: Colors.grey.shade700)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              MiniTrendChart(values: info.values),
            ],
          ),
          const SizedBox(height: 12),

          /// ✅ 여기에 AnimatedSwitcher 적용
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  SizeTransition(sizeFactor: animation, child: child),
              child: expanded
                  ? Column(
                      key: const ValueKey('expanded'),
                      children: [
                        const SizedBox(height: 12),
                        _buildExpandedForm(
                          bettingUp ? Colors.green : Colors.red,
                          bettingUp ? "오를 것 같아" : "내릴 것 같아",
                          (amount * 2.1).toStringAsFixed(0),
                        ),
                      ],
                    )
                  : info.myBet != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "🪙 베팅 금액: ${info.myBet!.amount.toStringAsFixed(0)}P",
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(
                              "💸 취소 시 반환 금액: ${(info.myBet!.amount * 0.85).floor()}P",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text("📊 예측: "),
                                Text(
                                  info.myBet!.direction == 'up'
                                      ? "오를 것 같아"
                                      : "내릴 것 같아",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.black87,
                                minimumSize: const Size.fromHeight(48),
                              ),
                              onPressed:
                                  Get.find<BetController>().isLoading.value
                                      ? null
                                      : () async {
                                          final user =
                                              FirebaseAuth.instance.currentUser;
                                          if (user == null) return;

                                          await Get.find<BetController>()
                                              .cancelBet(info.myBet!);
                                          collapse(); // 폼 닫기
                                        },
                              child: Get.find<BetController>().isLoading.value
                                  ? ButtonLoading()
                                  : const Text("베팅 취소"),
                            ),
                          ],
                        )
                      : Row(
                          key: const ValueKey('collapsed'),
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    Get.find<BetController>().isLoading.value
                                        ? null
                                        : () => toggle(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade100,
                                  foregroundColor: Colors.green.shade800,
                                ),
                                child: Get.find<BetController>().isLoading.value
                                    ? ButtonLoading()
                                    : const Text("오를 것 같아"),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    Get.find<BetController>().isLoading.value
                                        ? null
                                        : () => toggle(false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade100,
                                  foregroundColor: Colors.red.shade800,
                                ),
                                child: Get.find<BetController>().isLoading.value
                                    ? ButtonLoading()
                                    : const Text("내릴 것 같아"),
                              ),
                            ),
                          ],
                        ),
            ),
          ),

          const SizedBox(height: 12),
          // 하단 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IntervalWithTimer(
                interval: info.interval,
                endDate: info.values.first.endDate,
              ),
              GestureDetector(
                onTap: () {
                  Get.find<BetController>().toggleFavorite(info);
                },
                child: Obx(() {
                  final isFav = Get.find<BetController>().isFavorite(info);
                  return Icon(
                    isFav ? Icons.bookmark : Icons.bookmark_border,
                    size: 20,
                    color: isFav ? Colors.orange : Colors.grey.shade600,
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedForm(Color color, String label, String reward) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text(widget.info.question,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: collapse,
              visualDensity: VisualDensity.compact,
              splashRadius: 16,
            )
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixText: "\$",
                ),
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) _updateAmount(parsed);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.lightBlue,
            // 슬라이더 이동된 부분 색상
            inactiveTrackColor: Colors.lightBlue[100],
            // 이동되지 않은 부분 색상
            thumbColor: Colors.lightBlue,
            // 손잡이 색상
            overlayColor: Colors.lightBlue.withOpacity(0.2),
            // 손잡이 터치 시 주변 원
            valueIndicatorColor: Colors.lightBlue,
            // label 배경색
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white, // label 텍스트 색상
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Slider(
            value: amount,
            min: 1,
            max: 100,
            divisions: 99,
            label: "${amount.toStringAsFixed(0)}P",
            onChanged: _updateAmount,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: Get.find<BetController>().isLoading.value
                ? null
                : () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) return;

                    final bet = Bet(
                      uid: user.uid,
                      site_id: widget.info.site_id,
                      type_id: widget.info.type_id,
                      direction: bettingUp ? 'up' : 'down',
                      amount: amount,
                      odds: 2.1,
                      userName: user.displayName,
                      avatarUrl: user.photoURL,
                      question: widget.info.question,
                      createdAt: DateTime.now(),
                    );

                    await Get.find<BetController>().placeBet(bet);
                    collapse();
                  },
            child: Get.find<BetController>().isLoading.value
                ? ButtonLoading()
                : Text("$label\n예상 수익: $reward\P", textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}
