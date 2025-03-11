import 'package:dio/dio.dart';

import '../main.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'https://asia-northeast3-seoul-game.cloudfunctions.net',
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  ),
)
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ),
  )
  ..interceptors.add(
    LogInterceptor(
      responseBody: true,
      error: true,
      requestHeader: false,
      responseHeader: false,
      request: false,
      requestBody: true,
    ),
  );
