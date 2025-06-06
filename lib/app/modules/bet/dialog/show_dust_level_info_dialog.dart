import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showDustLevelInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('서울시 실시간 자치구별 대기환경 현황'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: [
                const TextSpan(
                    text:
                    '서울시 자치구별 대기환경정보를 파악할 수 있는 OpenAPI 서비스입니다. 매시간 갱신되는 정보로서, 25개 자치구 전체 또는 원하는 자치구만의 대기환경정보를 볼 수 있습니다. 제공되는 데이터는 통합대기환경 지수와 등급, 지수결정 물질 및 미세먼지(PM-10), 오존, 이산화질소, 일산화탄소, 아황산가스 측정값입니다.\n\n'),
                TextSpan(
                  text: '출처: 서울 열린데이터 광장',
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url =
                          'https://data.seoul.go.kr/dataList/OA-1200/S/1/datasetView.do';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      }
                    },
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('닫기')),
      ],
    ),
  );
}