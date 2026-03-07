import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moitube_app/main.dart';
import 'package:moitube_app/routes/app_routes.dart';
import 'package:moitube_app/services/auth_service.dart';
import 'package:moitube_app/services/storage_service.dart';

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
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService.getAccessToken();  
        if(token != null) {
          options.headers['Authorization'] = 'Bearer $token'; 
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if(error.response?.statusCode == 401) {
          try {
            final newToken = await AuthService().refreshToken();
            if(newToken !=  null) {
              await StorageService.saveTokens(
                accessToken: newToken,
                refreshToken: (await StorageService.getRefreshToken())!
              );
            }

            final opts = error.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newToken';

            final res = await dio.fetch(opts);
            return handler.resolve(res);
          } catch (_) {}
          await StorageService.clearTokens();
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => false,
          );
        }
        return handler.next(error);
      }
    )
  );
}