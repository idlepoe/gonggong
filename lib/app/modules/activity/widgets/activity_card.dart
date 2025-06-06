import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/activity.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ActivityCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String message;
  final DateTime createdAt;

  const ActivityCard({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.message,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  radius: 20,
                ),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  _buildRichMessage(message),
                  const SizedBox(height: 6),
                  Text(
                    _formatRelativeTime(createdAt),
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 마크업 처리기: <point>123P</point> → 주황색, <dir_up>상승</dir_up> → 초록색 등
  Widget _buildRichMessage(String message) {
    final spans = <TextSpan>[];

    final regex = RegExp(r'<(.*?)>(.*?)</\1>|([^<]+)');
    final matches = regex.allMatches(message);

    for (final match in matches) {
      if (match.group(3) != null) {
        spans.add(TextSpan(text: match.group(3)));
      } else {
        final tag = match.group(1);
        final content = match.group(2);
        TextStyle style;

        switch (tag) {
          case 'point':
            style = const TextStyle(
                color: Colors.orange, fontWeight: FontWeight.bold);
            break;
          case 'strong':
            style = const TextStyle(fontWeight: FontWeight.bold);
            break;
          case 'dir_up':
            style = const TextStyle(color: Colors.green);
            break;
          case 'dir_down':
            style = const TextStyle(color: Colors.red);
            break;
          default:
            style = const TextStyle();
        }

        spans.add(TextSpan(text: content, style: style));
      }
    }

    return RichText(
      text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: spans),
    );
  }

  String _formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) return '${diff.inSeconds}초 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }
}
