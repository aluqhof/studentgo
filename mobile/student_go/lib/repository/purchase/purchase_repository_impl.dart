import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:student_go/interceptor/auth_request_interceptor.dart';
import 'package:student_go/models/dto/purchase_dto.dart';
import 'package:student_go/models/response/event_overview_response/event_overview_response.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/purchase_response.dart';
import 'package:student_go/repository/purchase/purchase_repository.dart';

class PurchaseRepositoryImpl extends PurchaseRepository {
  final Client _httpClient = InterceptedClient.build(interceptors: [
    AuthRequestInterceptor(),
  ]);

  @override
  Future<PurchaseResponse> doEventPurchase(PurchaseDto purchase) async {
    try {
      final response = await _httpClient.post(
          Uri.parse('http://10.0.2.2:8080/purchase/'),
          body: purchase.toJson());
      if (response.statusCode == 201) {
        return PurchaseResponse.fromJson(response.body);
      } else if (response.statusCode == 404 ||
          response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        throw GeneralException.fromJson(response.body);
      } else {
        throw Exception('Failed to do purchase');
      }
    } catch (e) {
      if (e is GeneralException) {
        rethrow;
      } else {
        throw Exception('Something wrong');
      }
    }
  }

  @override
  Future<List<EventOverviewResponse>> getAllEventsPurchasedByUser() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('http://10.0.2.2:8080/purchase/all-by-student'),
        //Uri.parse('http://localhost:8080/auth/login'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<EventOverviewResponse> events =
            jsonData.map((x) => EventOverviewResponse.fromMap(x)).toList();
        return events;
      } else if (response.statusCode == 404 ||
          response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        return Future.error(GeneralException.fromJson(response.body));
      } else {
        throw Exception('Failed to get event');
      }
    } catch (e) {
      if (e is GeneralException) {
        rethrow;
      }
      throw Exception('Something wrong');
    }
  }
}
