import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggong/app/data/controllers/profile_controller.dart';

import '../../../data/models/activity.dart';

import 'package:flutter/widgets.dart';

import 'package:flutter/gestures.dart';

import '../../gacha/controllers/gacha_controller.dart';
import '../../gacha/widgets/show_artwork_bottom_sheet.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

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
                  backgroundImage: NetworkImage(activity.avatarUrl),
                  radius: 20,
                ),
                const SizedBox(height: 4),
                Text(activity.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  _buildRichMessage(context, activity.message, activity.type),
                  const SizedBox(height: 6),
                  Text(
                    _formatRelativeTime(activity.createdAt),
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

  /// 마크업을 RichText로 변환
  Widget _buildRichMessage(BuildContext context, String message, String type) {
    final spans = <InlineSpan>[];
    final regex = RegExp(r'<(.*?)>(.*?)</\1>|([^<]+)');
    final matches = regex.allMatches(message);

    for (final match in matches) {
      if (match.group(3) != null) {
        spans.add(TextSpan(text: match.group(3)));
      } else {
        final tag = match.group(1);
        final content = match.group(2);

        switch (tag) {
          case 'point':
            spans.add(TextSpan(
              text: content,
              style: const TextStyle(
                  color: Colors.orange, fontWeight: FontWeight.bold),
            ));
            break;
          case 'strong':
            spans.add(TextSpan(
              text: content,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
            break;
          case 'dir_up':
            spans.add(TextSpan(
              text: content,
              style: const TextStyle(color: Colors.green),
            ));
            break;
          case 'dir_down':
            spans.add(TextSpan(
              text: content,
              style: const TextStyle(color: Colors.red),
            ));
            break;
          case 'artwork':
            spans.add(TextSpan(
              text: content,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _handleArtworkTap(context);
                },
            ));
            break;
          default:
            spans.add(TextSpan(text: content));
        }
      }
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 14),
        children: spans,
      ),
    );
  }

  void _handleArtworkTap(BuildContext context) {
    if (activity.type == 'artwork') {
      final gachaController = Get.find<GachaController>();
      final profile = Get.find<ProfileController>().userProfile.value;

      final title = extractTitleFromMessage(activity.message);

      final artwork = gachaController.artworks
          .firstWhereOrNull((art) => art.nameKr == title);

      if (artwork != null && profile != null) {
        showArtworkBottomSheet(
          context,
          artwork,
          activity.uid == profile.uid,
          profile.points,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("작품 정보를 찾을 수 없습니다.")),
        );
      }
    }
  }

  String _formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) return '${diff.inSeconds}초 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }

  String extractTitleFromMessage(String message) {
    final regex = RegExp(r'<strong>(.*?)</strong>');
    final match = regex.firstMatch(message);
    return match?.group(1) ?? '';
  }
}
