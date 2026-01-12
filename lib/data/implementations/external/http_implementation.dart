import 'dart:io';

import 'package:imdumb_dependencies/imdumb_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:imdumb/core/app/app_types.dart';
import 'package:imdumb/core/app/env.dart';
import 'package:imdumb/core/utils/extensions.dart';
import 'package:imdumb/data/repositories/external/http_repository.dart';
import 'package:imdumb/domain/models/http_exeption_model.dart';
import 'package:imdumb/domain/models/http_response_model.dart';
import 'package:imdumb/domain/providers/global_riverpod.dart';
import 'package:imdumb/presentation/screens/home/home_screen.dart';
// import 'package:imdumb/presentation/pages/login_page.dart';

class HttpImpl implements IHttp {
  HttpImpl._(
    this.context, {
    required this.onCall,
    required this.onDone,
    required this.onFail,
    required this.read,
    required this.appVersion,
  });

  factory HttpImpl.initialize({
    required Future<void> Function() onCall,
    required Future<void> Function() onDone,
    required Future<void> Function() onFail,
    required BuildContext context,
    required Reader read,
    required String version,
  }) {
    _instance = HttpImpl._(context, onCall: onCall, onDone: onDone, onFail: onFail, read: read, appVersion: version);
    return _instance!;
  }

  final BuildContext context;
  final Future<void> Function() onCall;
  final Future<void> Function() onDone;
  final Future<void> Function() onFail;
  final Reader read;
  final String appVersion;
  static HttpImpl? _instance;

  /// If you know, your widet will be disposed, use this method to replace you old context in the widget tree
  static void useNewContext(BuildContext context) {
    assert(_instance != null, 'First initialize HTTP Client to use this method, use: HttpImpl.initialize()');
    _instance = _instance!.copyWith(context: context);
  }

  HttpImpl copyWith({
    Future<void> Function()? onCall,
    Future<void> Function()? onDone,
    Future<void> Function()? onFail,
    BuildContext? context,
  }) => HttpImpl._(
    context ?? this.context,
    onCall: onCall ?? this.onCall,
    onDone: onDone ?? this.onDone,
    onFail: onFail ?? this.onFail,
    read: read,
    appVersion: appVersion,
  );

  Future<void> _onFail(dynamic e) async {
    await onFail();
    String error = 'Algo salio mal, comunicate con nuestro soporte para que podamos ayudarte';
    if (e is SocketException || e is HttpExeptionModel && e.statusCode == 0) {
      error = 'Tuvimos un problema al procesar tu solicitud, verifica tu conexion a internet';
    }

    if (e is DioException) {
      final status = e.response?.statusCode ?? 0;

      // Detectar 401 Unauthorized - sesión expirada
      if (status == 401) {
        if (read(globalProvider).showError) {
          toast('Sesión expirada. Por favor, inicia sesión nuevamente');
        }
        // Limpiar JWT y navegar a login
        read(globalProvider.notifier).setJwt('');
        // Limpiar SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        // Navegar a login
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.route, (_) => false);
        }
        return;
      }

      if (status >= 400) {
        error = e.response?.data.toString() ?? 'Error in format of response error';
        if (e.response?.data is Map && (e.response?.data as Map).containsKey('error')) {
          error = (e.response!.data as Map)['error'].toString();
        }
      }
    }
    if (read(globalProvider).showError) {
      toast(error);
    }
  }

  static HttpImpl get instance {
    assert(_instance != null, 'HTTP client was not initialized');
    return _instance!;
  }

  final _http = Dio();

  @override
  Future<HttpResponseModel<T?>> get<T>(
    String url, {
    JSON? headers,
    JSON? params,
    dynamic data,
    bool showError = true,
  }) async {
    await onCall();
    try {
      printMap(
        header: '========= HTTP REQUEST =========',
        {
          'GET': Uri.parse(url).toString(),
          'header': {'Authorization': 'Bearer ${Env.apiReadAccessToken}', 'App-Version': appVersion, ...?headers},
          'params': params,
          'data': data,
        }.removeNulls(),
        footer: '================================',
        timestamp: true,
      );
      final resp = await _http.get<T?>(
        Uri.parse(url).toString(),
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer ${Env.apiReadAccessToken}', 'App-Version': appVersion, ...?headers},
        ),
        queryParameters: params,
      );

      printMap(
        header: '========= HTTP RESPONSE =========',
        {'From': Uri.parse(url).toString(), 'Status': resp.statusCode, 'Response': resp.data},
        footer: '=================================',
        timestamp: true,
      );
      await onDone();
      return HttpResponseModel<T?>(statusCode: resp.statusCode!, data: resp.data);
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          await _onFail(e);
          throw HttpExeptionModel(statusCode: 0, error: {'error': 'Tuvimos un problema al resolver: $url'});
        }
        if (e.response != null) {
          await _onFail(e);
          throw HttpExeptionModel(statusCode: e.response!.statusCode!, error: e.response!.data);
        }
      }
      await _onFail(e);
      throw HttpExeptionModel(statusCode: 0, error: e);
    }
  }

  @override
  Future<HttpResponseModel<T?>> post<T>(
    String url, {
    JSON? headers,
    JSON? params,
    dynamic data,
    bool showError = true,
  }) async {
    await onCall();
    try {
      printMap(
        header: '========= HTTP REQUEST =========',
        {
          'POST': Uri.parse(url).toString(),
          'header': {'Authorization': 'Bearer ${Env.apiReadAccessToken}', 'App-Version': appVersion, ...?headers},
          'params': params,
          'data': data,
        }.removeNulls(),
        footer: '================================',
        timestamp: true,
      );

      final resp = await _http.post<T?>(
        Uri.parse(url).toString(),
        data: data,
        queryParameters: params,
        options: Options(
          headers: {'Authorization': 'Bearer ${Env.apiReadAccessToken}', 'App-Version': appVersion, ...?headers},
        ),
      );

      printMap(
        header: '========= HTTP REQUEST =========',
        {'From': Uri.parse(url).toString(), 'Status': resp.statusCode, 'Response': resp.data},
        footer: '================================',
        timestamp: true,
      );
      await onDone();
      return HttpResponseModel<T?>(statusCode: resp.statusCode!, data: resp.data);
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          await _onFail(e);
          throw HttpExeptionModel(statusCode: 0, error: {'error': 'Tuvimos un problema al resolver: $url'});
        }
        if (e.response != null) {
          await _onFail(e);
          throw HttpExeptionModel(statusCode: e.response!.statusCode!, error: e.response!.data);
        }
      }
      await _onFail(e);
      throw HttpExeptionModel(statusCode: 0, error: e);
    }
  }

  @override
  Future<HttpResponseModel<T?>> put<T>(
    String url, {
    JSON? headers,
    JSON? params,
    dynamic data,
    bool showError = true,
  }) async {
    await onCall();
    try {
      printMap(
        header: '========= HTTP REQUEST =========',
        {
          'PUT': Uri.parse(url).toString(),
          'header': {'Authorization': 'Bearer ${Env.apiReadAccessToken}', 'App-Version': appVersion, ...?headers},
          'params': params,
          'data': data,
        }.removeNulls(),
        footer: '================================',
        timestamp: true,
      );

      final resp = await _http.put<T?>(
        Uri.parse(url).toString(),
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer ${Env.apiReadAccessToken}', 'App-Version': appVersion, ...?headers},
        ),
        queryParameters: params,
      );
      printMap(
        header: '========= HTTP RESPONSE =========',
        {'From': Uri.parse(url).toString(), 'Status': resp.statusCode, 'Response': resp.data},
        footer: '================================',
        timestamp: true,
      );
      await onDone();
      return HttpResponseModel<T?>(statusCode: resp.statusCode!, data: resp.data);
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          await _onFail(e);
          throw HttpExeptionModel(statusCode: 0, error: {'error': 'Tuvimos un problema al resolver: $url'});
        }
        if (e.response != null) {
          await _onFail(e);
          throw HttpExeptionModel(statusCode: e.response!.statusCode!, error: e.response!.data);
        }
      }
      await _onFail(e);
      throw HttpExeptionModel(statusCode: 0, error: e);
    }
  }

  @override
  Future<HttpResponseModel<T?>> delete<T>(
    String url, {
    JSON? headers,
    JSON? params,
    dynamic data,
    bool showError = true,
  }) async {
    await onCall();
    try {
      printMap(
        header: '========= HTTP REQUEST =========',
        {
          'DELETE': Uri.parse(url).toString(),
          'header': {'Authorization': 'Bearer ${Env.apiReadAccessToken}', 'App-Version': appVersion, ...?headers},
          'params': params,
          'data': data,
        }.removeNulls(),
        footer: '================================',
        timestamp: true,
      );

      final response = await _http.delete<T?>(
        Uri.parse(url).toString(),
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer ${Env.apiReadAccessToken}', 'App-Version': appVersion, ...?headers},
        ),
        queryParameters: params,
      );

      printMap(
        header: '========= HTTP RESPONSE =========',
        {'From': Uri.parse(url).toString(), 'Status': response.statusCode, 'Response': response.data},
        footer: '================================',
        timestamp: true,
      );
      await onDone();
      return HttpResponseModel<T?>(statusCode: response.statusCode!, data: response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          await _onFail(e);
          throw HttpExeptionModel(statusCode: 0, error: {'error': 'Tuvimos un problema al resolver: $url'});
        }
        if (e.response != null) {
          await _onFail(e);
          throw HttpExeptionModel(statusCode: e.response!.statusCode!, error: e.response!.data);
        }
      }
      await _onFail(e);
      throw HttpExeptionModel(statusCode: 0, error: e);
    }
  }
}
