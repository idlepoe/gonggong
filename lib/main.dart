import 'dart:ui';
import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';

import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/data/constants/app_translations.dart';
import 'app/data/constants/theme.dart';
import 'app/data/controllers/profile_controller.dart';
import 'app/data/controllers/theme_controller.dart';
import 'app/data/utils/fcm.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeNotification();
  await initializeDateLocale();
  final themeController = Get.put(ThemeController());
  Get.put(ProfileController());
  await themeController.loadTheme();

  runApp(
    FlutterWebFrame(
      builder: (context) => GetMaterialApp(
        title: 'ulala'.tr,
        translations: AppTranslations(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
        theme: AppThemes.light(),
        darkTheme: AppThemes.dark(),
        themeMode: ThemeMode.system, // 또는 light / dark 강제 설정
      ),
      maximumSize: Size(475.0, 812.0),
      enabled: kIsWeb,
      backgroundColor: Colors.grey.shade300,
    ),
  );
}

Future<void> initializeDateLocale({String? overrideLocale}) async {
  final deviceLocale =
      overrideLocale ?? ui.PlatformDispatcher.instance.locale.languageCode;
  await initializeDateFormatting(deviceLocale);
}
