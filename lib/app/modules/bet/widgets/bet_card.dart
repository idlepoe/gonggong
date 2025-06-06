import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gonggong/app/data/widgets/button_loading.dart';
import '../../../data/models/bet.dart';
import '../../../data/models/measurement_info.dart';
import '../../../data/widgets/build_linkable_question.dart';
import '../controllers/bet_card_stats_controller.dart';
import '../controllers/bet_controller.dart';
import 'bet_card_collapsed.dart';
import 'bet_card_footer.dart';
import 'bet_card_form.dart';
import 'bet_card_header.dart';
import 'bet_card_summary.dart';
import 'interval_with_timer.dart';
import 'mini_trend_chart.dart';

class BetCard extends StatefulWidget {
  final MeasurementInfo info;

  const BetCard({super.key, required this.info});

  @override
  State<BetCard> createState() => _BetCardState();
}

class _BetCardState extends State<BetCard> {
  bool expanded = false;
  bool bettingUp = true;
  double amount = 100;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: amount.toStringAsFixed(0));
    Get.find<BetCardStatsController>()
        .listen(widget.info.site_id, widget.info.type_id);
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
    final myBet = info.myBet;

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
          /// 상단 아이콘 + 질문 + 미니차트
          BetCardHeader(info: info),
          const SizedBox(height: 12),

          /// 확장 여부에 따라 폼/요약/선택 버튼 스위칭
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                SizeTransition(sizeFactor: animation, child: child),
            child: expanded
                ? BetCardForm(
                    info: info,
                    controller: _controller,
                    amount: amount,
                    bettingUp: bettingUp,
                    color: bettingUp ? Colors.green : Colors.red,
                    label: bettingUp ? "오를 것 같아" : "내릴 것 같아",
                    onAmountChanged: _updateAmount,
                    onClose: collapse,
                    onSubmit: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return;

                      final bet = Bet(
                        uid: user.uid,
                        site_id: info.site_id,
                        type_id: info.type_id,
                        direction: bettingUp ? 'up' : 'down',
                        amount: amount,
                        odds: 2.1,
                        userName: user.displayName,
                        avatarUrl: user.photoURL,
                        question: info.question,
                        createdAt: DateTime.now(),
                      );

                      await Get.find<BetController>().placeBet(bet);
                      collapse();
                    },
                  )
                : myBet != null
                    ? BetCardSummary(
                        bet: myBet,
                        onCancel: collapse,
                      )
                    : BetCardCollapsed(
                        info: widget.info,
                        onUpPressed: () => toggle(true),
                        onDownPressed: () => toggle(false),
                      ),
          ),

          const SizedBox(height: 12),

          /// 타이머 + 즐겨찾기
          BetCardFooter(info: info),
        ],
      ),
    );
  }
}
