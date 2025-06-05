import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import 'logger.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotification() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // 🔥 알림 클릭 시 실행
      final payload = response.payload;
      if (payload != null && payload.isNotEmpty) {
        if (Get.currentRoute != Routes.HOME) {
          // initialRoomId = payload;
        } else {
          // Get.toNamed(Routes.CHAT_ROOM, arguments: {'roomId': payload});
        }
      }
    },
  );

  // FCM foreground 수신 처리
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final avatarUrl = message.data['avatarUrl'] ?? '';
    final roomId = message.data['roomId'] ?? '';

    showLocalNotification(
      title: message.notification?.title ?? '새 메시지',
      body: message.notification?.body ?? '',
      avatarUrl: avatarUrl,
      roomId: roomId,
    );
  });

  // 앱이 종료되어 있는 상태
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    logger.w("getInitialMessage()");
    if (message != null && message.data.containsKey('roomId')) {
      if (Get.currentRoute != Routes.HOME) {
        // initialRoomId = message.data['roomId'];
      } else {
        // Get.toNamed(
        //   Routes.CHAT_ROOM,
        //   arguments: {'roomId': message.data['roomId']},
        // );
      }
    }
  });

  // 백그라운드 상태에서 알림 클릭
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    logger.w("onMessageOpenedApp");
    if (message.data.containsKey('roomId')) {
      if (Get.currentRoute != Routes.HOME) {
        // initialRoomId = message.data['roomId'];
      } else {
        // Get.toNamed(
        //   Routes.CHAT_ROOM,
        //   arguments: {'roomId': message.data['roomId']},
        // );
      }
    }
  });
}

Future<void> showLocalNotification({
  required String title,
  required String body,
  required String avatarUrl,
  required String roomId,
}) async {
  final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'default_channel',
    'Default',
    importance: Importance.max,
    priority: Priority.high,
    styleInformation:
        avatarUrl.isNotEmpty
            ? BigPictureStyleInformation(
              FilePathAndroidBitmap(avatarUrl), // 🔥 프로필 이미지 표시
              contentTitle: title,
              summaryText: body,
            )
            : null,
  );

  final NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformDetails,
    payload: roomId,
  );
}
