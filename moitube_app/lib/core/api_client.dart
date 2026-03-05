import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {

  static final String baseUrl = kReleaseMode
      ? "https://moitube.onrender.com"
      : "http://10.0.2.2:3000";

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        "Content-Type": "application/json"
      }
    )
  );
}