import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

class UserProfileBadge extends StatefulWidget {
  const UserProfileBadge({super.key});

  @override
  State<UserProfileBadge> createState() => _UserProfileBadgeState();
}

class _UserProfileBadgeState extends State<UserProfileBadge> {
  Timer? _pointTimer;
  int? _currentPoints;

  @override
  void dispose() {
    _pointTimer?.cancel();
    super.dispose();
  }

  void _handlePointUpdate(String uid, int points) {
    _currentPoints = points;

    // 이미 100 이상이면 타이머 종료
    if (points >= 100) {
      _pointTimer?.cancel();
      _pointTimer = null;
      return;
    }

    // 이미 타이머 작동 중이면 건너뜀
    if (_pointTimer != null && _pointTimer!.isActive) return;

    // 타이머 시작 (10분마다 +20P)
    _pointTimer = Timer.periodic(const Duration(minutes: 10), (_) async {
      if (_currentPoints != null && _currentPoints! < 100) {
        final newPoints = _currentPoints! + 20;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'points': newPoints});
        _currentPoints = newPoints;

        // ✅ 하단 알림 추가
        Get.snackbar(
          '💰 포인트 지급',
          '10분 접속 보상으로 20포인트가 지급되었어요!',
          icon: const Icon(Icons.card_giftcard, color: Colors.amber),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );

        if (newPoints >= 100) {
          _pointTimer?.cancel();
          _pointTimer = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const SizedBox();

    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

    return StreamBuilder<DocumentSnapshot>(
      stream: userDoc.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const SizedBox();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final avatarUrl = data['avatarUrl'] as String? ?? '';
        final nickname = data['nickname'] as String? ?? '이름 없음';
        final points = data['points'] as int? ?? 0;

        // 포인트 업데이트 처리
        _handlePointUpdate(uid, points);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage:
                    avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                radius: 16,
                child: avatarUrl.isEmpty
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nickname,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on_outlined,
                          size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('$points pt',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
