import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DioInterceptor extends Interceptor {
  bool isDebug;

  DioInterceptor(this.isDebug);

  @override
  onRequest(RequestOptions options) async {
    // options.uri.path.
    // Uri.parse("uri").normalizePath().path.
    return options;
  }

  @override
  onResponse(Response response) async {
    log("------------------------------------------------------------------------------------------------------------------------------------------------\n");
    log(response.data.toString());
    return response;
  }

  Map<String, dynamic> _decodeData(Response response) {
    if (response == null ||
        response.data == null ||
        response.data.toString().isEmpty) {
      return new Map();
    }
    var decode = json.decode(response.data.toString());
    return decode;
  }

  @override
  onError(DioError err) async {
    try {
      String message = err.message;
      switch (err.response.statusCode) {
        case HttpStatus.badRequest: // 400
          err.response.data = _decodeData(err.response);
          message = err.response.data['msg'] ?? '请求失败，请联系我们';
          break;
        case HttpStatus.unauthorized: // 401
          err.response.data = _decodeData(err.response);
          message = err.response.data['msg'] ?? '未授权，请登录';
          break;
        case HttpStatus.forbidden: // 403
          message = '拒绝访问';
          break;
        case HttpStatus.notFound: // 404
          message = '请求地址出错';
          break;
        case HttpStatus.requestTimeout: // 408
          message = '请求超时';
          break;
        case HttpStatus.internalServerError: // 500
          message = '服务器内部错误';
          break;
        case HttpStatus.notImplemented: // 501
          message = '服务未实现';
          break;
        case HttpStatus.badGateway: // 502
          message = '网关错误';
          break;
        case HttpStatus.serviceUnavailable: // 503
          message = '服务不可用';
          break;
        case HttpStatus.gatewayTimeout: // 504
          message = '网关超时';
          break;
      }
      err.error = message;
    } on TypeError {
      err.error = '信息转换错误';
    } catch (e) {
      err.error = '网络链接异常或服务器已停机！';
    }
    log(err.message.toString());
    Fluttertoast.showToast(
        msg: err.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    return err;
  }
}
