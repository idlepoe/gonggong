import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gonggong/controllers/api_contoller.dart';
import 'package:gonggong/pages/splash_page.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

var logger = Logger(printer: PrettyPrinter());
late final SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      enableLog: true,
      logWriterCallback: localLogWriter,
      initialBinding: InitBinding(),
      home: SplashPage(),
    );
  }

  void localLogWriter(String text, {bool isError = false}) {
    if (isError) return logger.e(text);
    logger.d(text);
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiController());
  }
}
