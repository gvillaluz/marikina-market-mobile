import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio dio;
  static const _storage = FlutterSecureStorage();
  final Future<bool> Function()? refreshAction;
  final Future<void> Function()? onAuthFailure;

  Completer<bool>? _refreshCompleter;

  ApiClient({Dio? dio, this.refreshAction, this.onAuthFailure})
    : dio = dio ?? Dio() {
    _configure();
  }

  Future<bool> handleRefresh() {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    refreshAction!()
        .then((success) {
          _refreshCompleter!.complete(success);
          _refreshCompleter = null;
        })
        .catchError((_) {
          _refreshCompleter!.complete(false);
          _refreshCompleter = null;
        });

    return _refreshCompleter!.future;
  }

  void _configure() {
    dio.options = BaseOptions(
      baseUrl: 'https://motocross-lifter-modified.ngrok-free.dev/api',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: kDebugMode
          ? const Duration(seconds: 60)
          : const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    );

    if (kDebugMode) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
                return host == '192.168.1.57';
              };
          return client;
        },
      );
    }

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final skipAuth = options.extra['skipAuth'] == true;

          if (!skipAuth) {
            if (_refreshCompleter != null) {
              await _refreshCompleter!.future;
            }

            final token = await _storage.read(key: 'access_token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          final isAlreadyRetried = e.requestOptions.extra['isRetry'] ?? false;
          final isRefreshCall = e.requestOptions.path.contains('/auth/refresh');

          if (e.response?.statusCode == 401 &&
              refreshAction != null &&
              !isAlreadyRetried &&
              !isRefreshCall) {
            final isRefreshSuccess = await handleRefresh();

            if (isRefreshSuccess) {
              final requestOptions = e.requestOptions;
              requestOptions.extra['isRetry'] = true;

              final newAccessToken = await _storage.read(key: 'access_token');

              if (newAccessToken != null) {
                requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';

                if (requestOptions.data is FormData) {
                  final oldFormData = requestOptions.data as FormData;
                  final clonedFormData = FormData();

                  clonedFormData.fields.addAll(oldFormData.fields);

                  for (final file in oldFormData.files) {
                    clonedFormData.files.add(
                      MapEntry(file.key, file.value.clone()),
                    );
                  }

                  requestOptions.data = clonedFormData;
                }

                try {
                  final clonedResponse = await dio.fetch(requestOptions);
                  return handler.resolve(clonedResponse);
                } on DioException catch (retryError) {
                  return handler.next(retryError);
                }
              }
            }

            await onAuthFailure?.call();
            return handler.next(e);
          } else if (isRefreshCall && e.response?.statusCode == 401) {
            await onAuthFailure?.call();
          }

          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(String path, {Options? options}) {
    return dio.delete(path, options: options);
  }
}
