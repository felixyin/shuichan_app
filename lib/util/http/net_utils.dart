import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shuichan_app/api/api.dart';
import 'package:shuichan_app/util/http/dio_interceptor.dart';
import 'package:url/url.dart';

class NetUtils {
  static Dio _dio;

  // 全局变量
  static String _jSessionId = '';

  static void setJSESSIONID(v) {
    log('====================================> _JSESSIONID    :    ' + v);
    _jSessionId = v;
  }

  static String authUrl(url) {
    if (_jSessionId != null && _jSessionId != '') {
      var url2 = Url.parse(url);
      var path = url2.path + ';JSESSIONID=' + _jSessionId;
      log(path);
      url2 = url2.replace(path: path);
      path = url2.normalizePath().toString();
      log(path);
      return path;
    }
    return url;
  }

  static Dio getDio() {
    if (_dio == null) {
      BaseOptions _baseOptions = BaseOptions(
        baseUrl: Api.BASE_URL,
        connectTimeout: 150000,
        receiveTimeout: 150000,
        // followRedirects: false,
        // validateStatus: (status) {
        // return status < 500;
        // },
        // 默认为ajax请求
        contentType: "application/x-www-form-urlencoded",
      );
      _dio = new Dio(_baseOptions);
      bool _isDebug = !bool.fromEnvironment("dart.vm.product");
      _isDebug = true;

      _dio.interceptors
        ..add(LogInterceptor(
            requestBody: _isDebug, responseBody: _isDebug)) // 日志拦截器
        ..add(DioInterceptor(_isDebug)); // Dio 拦截器
    }

    return _dio;
  }

  /// 添加拦截器
  addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  static Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) {
    if (queryParameters == null) {
      queryParameters = Map.identity();
    }
    queryParameters.addAll({"__ajax": true, "mobileLogin": true});
    var authUrl2 = authUrl(path);
//    log('get:' + authUrl2);
    return getDio().get<T>(
      authUrl2,
      queryParameters: queryParameters,
      options: options,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }

  static Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) {
    if (queryParameters == null) {
      queryParameters = Map.identity();
    }
    queryParameters.addAll({"__ajax": true, "mobileLogin": true});
    var authUrl2 = authUrl(path);
//    log('post:' + authUrl2);
    return getDio().post<T>(
      authUrl2,
      data: data,
      options: options,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
