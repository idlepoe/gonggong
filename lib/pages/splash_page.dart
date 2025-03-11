import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gonggong/controllers/api_contoller.dart';
import 'package:intl/intl.dart';

import '../constrant/define.dart';
import '../main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        init();
      },
    );
  }

  Future<void> init() async {
    String id = "";
    String name = "";

    if ((prefs.getString(Define.PREF_USER_ID) ?? "").isEmpty) {
      id = DateFormat("yyyyMMddHHmmssSSS").format(DateTime.now());
      prefs.setString(Define.PREF_USER_ID, id);

      while (name.isEmpty) {
        List<String>? result = await showTextInputDialog(
          context: context,
          title: "닉네임을 입력",
          textFields: [
            DialogTextField(
              hintText: "닉네임",
              maxLength: 10,
            ),
          ],
          okLabel: "확인",
          cancelLabel: "취소",
        );
        if (result != null && result.first.isNotEmpty) {
          name = result.first;
        }
      }
      prefs.setString(Define.PREF_USER_NAME, name);

      Get.find<ApiController>().addUser(id: id, name: name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text("splash"),
          onPressed: () async {
            await prefs.clear();
            init();
          },
        ),
      ),
    );
  }
}
