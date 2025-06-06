import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showWaterTempInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('서울시 한강 및 주요지천 수질 측정 자료'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: [
                const TextSpan(
                    text:
                    '4개 수질자동측정소에서 측정된 서울시 한강 및 주요 지천의 수질 측정 자료입니다. pH, 용존산소 농도 등의 수질 측정 자료를 매시간 단위로 제공합니다.\n본 자료는 확정 전 실시간 자료이며, 참고용으로만 활용 가능합니다.\n\n'),
                TextSpan(
                  text: '출처: 서울 열린데이터 광장',
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url =
                          'https://data.seoul.go.kr/dataList/OA-15488/S/1/datasetView.do';
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