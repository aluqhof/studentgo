import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/models/response/general_exception.dart';

class AuthRequestInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print(prefs.getString('token')!);
      request.headers[HttpHeaders.acceptHeader] =
          'application/json; charset=utf-8';
      request.headers[HttpHeaders.authorizationHeader] =
          'Bearer ${prefs.getString('token')!}';
    } catch (e) {
      print(e);
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) {
    if (response.statusCode == HttpStatus.forbidden) {
      throw GeneralException();
    }
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
