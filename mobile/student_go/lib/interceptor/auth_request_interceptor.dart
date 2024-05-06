import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRequestInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      request.headers[HttpHeaders.acceptHeader] =
          'application/json; charset=utf-8';
      request.headers[HttpHeaders.contentTypeHeader] = 'application/json;';
      request.headers[HttpHeaders.authorizationHeader] =
          'Bearer ${prefs.getString('token')!}';
    } catch (e) {
      rethrow;
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) {
    return Future.value(response);
  }

  @override
  Future<bool> shouldInterceptRequest() {
    return Future.value(true);
  }

  @override
  Future<bool> shouldInterceptResponse() {
    return Future.value(true);
  }
}
