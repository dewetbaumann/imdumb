import 'package:imdumb/core/app/app_types.dart';
import 'package:imdumb/domain/models/http_response_model.dart';

abstract class IHttp {
  Future<HttpResponseModel<dynamic>> get<T>(String url, {JSON? headers, JSON? params, dynamic data});
  Future<HttpResponseModel<dynamic>> post<T>(String url, {JSON? headers, JSON? params, dynamic data});
  Future<HttpResponseModel<dynamic>> put<T>(String url, {JSON? headers, JSON? params, dynamic data});
  Future<HttpResponseModel<dynamic>> delete<T>(String url, {JSON? headers, JSON? params, dynamic data});
}
