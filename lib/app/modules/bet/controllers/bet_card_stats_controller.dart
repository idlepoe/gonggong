import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../data/models/bet_card_stats.dart';

class BetCardStatsController extends GetxController {
  final RxMap<String, BetCardStats> statsMap = <String, BetCardStats>{}.obs;

  StreamSubscription? _sub;

  void listen(String siteId, String typeId) {
    final docId = '${siteId}_$typeId';
    if (statsMap.containsKey(docId)) return; // 이미 구독 중이면 패스

    final docRef = FirebaseFirestore.instance
        .collection('bets')
        .doc(docId)
        .collection('summary')
        .doc('totals');

    _sub = docRef.snapshots().listen((snap) {
      final data = snap.data();
      if (data == null) return;

      final stats = BetCardStats(
        totalUp: data['totalUpAmount'] ?? 0,
        totalDown: data['totalDownAmount'] ?? 0,
      );

      statsMap.update(docId, (_) => stats, ifAbsent: () => stats); // ✅ 변화 감지 확실
    });
  }

  BetCardStats? getStats(String siteId, String typeId) {
    return statsMap['${siteId}_$typeId'];
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
