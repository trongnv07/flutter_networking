library networking;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum Method { post, get, put, delete }

class DioManager1 {
  var dio = Dio();
  var domainRequest = 'https://trungtamcanhbao.vn/api';

  Future<void> request({
    @required String path,
    @required Method method,
    Function(dynamic) onSuccess,
    Map<String, dynamic> param,
    Map<String, dynamic> headers,
    Function(dynamic) onFailure,
    Function(dynamic) onErrorHttp,
  }) async {
    var _param = {};

    if (param == null) param = {};
    _param.addAll(param);

    print('~~~> param: $_param');

    final fullUrl = domainRequest + path;
    //final token = await UserManager.instance.getAccessToken();
    final header = {"Authorization": "Bearer "};

    try {
      Response response = Response();
      Options options = new Options();
      options.headers = header;

      switch (method) {
        case Method.get:
          response = await dio.get(fullUrl, options: options);
          break;
        case Method.post:
          response = await dio.post(fullUrl, data: _param, options: options);
          break;
        case Method.put:
          response = await dio.put(fullUrl, data: _param, options: options);
          break;
        case Method.delete:
          response = await dio.delete(fullUrl, data: _param, options: options);
          break;
      }

      print(response);

      if (response.data is Map) {
        onSuccess(response.data);
      } else if (response.data is String) {
        onSuccess(response.data);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404 || e.response.statusCode == 400) {
        print(e.response.statusCode);
        onFailure(json.decode(e.response.toString()));
      } else {
        print(e.message);
        print(e.request);
        onErrorHttp(e.type);
      }
    }
  }
}

class DataRequest<T> {
  Function(T data) onSuccess;
  Function(dynamic error) onFailure;
  Function(dynamic error) onErrorHttp;

  DataRequest({this.onSuccess, this.onFailure, this.onErrorHttp});
}
