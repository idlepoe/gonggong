import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildLinkableQuestion(String question, String siteName) {
  final matchIndex = question.indexOf(siteName);

  if (matchIndex == -1) {
    // site_name이 포함되지 않았을 경우 일반 Text
    return Text(
      question,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // 앞, 하이라이트, 뒤 부분 나누기
  final before = question.substring(0, matchIndex);
  final highlight = question.substring(matchIndex, matchIndex + siteName.length);
  final after = question.substring(matchIndex + siteName.length);

  return RichText(
    text: TextSpan(
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      children: [
        TextSpan(text: before),
        TextSpan(
          text: highlight,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final url = 'https://namu.wiki/w/${Uri.encodeComponent(siteName)}';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              } else {
                print('❗️URL 실행 실패: $url');
              }
            },
        ),
        TextSpan(text: after),
      ],
    ),
  );
}
