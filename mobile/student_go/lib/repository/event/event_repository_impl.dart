import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:student_go/interceptor/auth_request_interceptor.dart';
import 'package:student_go/models/response/event_details_response/event_details_response.dart';
import 'package:student_go/models/response/list_events_response/content.dart';
import 'package:student_go/models/response/list_events_response/list_events_response.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/validation_exception/validation_exception.dart';
import 'package:student_go/repository/event/event_repository.dart';
import 'package:intl/intl.dart';

class EventRepositoryImpl extends EventRepository {
  final Client _httpClient = InterceptedClient.build(interceptors: [
    AuthRequestInterceptor(),
  ]);

  @override
  Future<ListEventsResponse> getUpcomingEventsLimited(
      String city, int page, int size) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(
            'http://10.0.2.2:8080/event/upcoming-limit/$city?page=$page&size=$size'),
      );

      if (response.statusCode == 200) {
        return ListEventsResponse.fromJson(response.body);
      } else if (response.statusCode == 404 ||
          response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        throw GeneralException.fromJson(response.body);
      } else {
        throw Exception('Failed to get events');
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
  Future<ListEventsResponse> getAccordingEventsLimited(
      String city, int page, int size) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(
            'http://10.0.2.2:8080/event/according-limit/$city?page=$page&size=$size'),
        //Uri.parse('http://localhost:8080/auth/login'),
      );

      if (response.statusCode == 200) {
        return ListEventsResponse.fromJson(response.body);
      } else if (response.statusCode == 404 ||
          response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        throw GeneralException.fromJson(response.body);
      } else {
        throw Exception('Failed to get events');
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
  Future<ListEventsResponse> getEventsByEventType(
      String city, int eventTypeId, int page, int size) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(
            'http://10.0.2.2:8080/event/by-event-type/$city/$eventTypeId?page=$page&size=$size'),
        //Uri.parse('http://localhost:8080/auth/login'),
      );

      if (response.statusCode == 200) {
        return ListEventsResponse.fromJson(response.body);
      } else if (response.statusCode == 404 ||
          response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        return Future.error(GeneralException.fromJson(response.body));
      } else {
        throw Exception('Failed to get events');
      }
    } catch (e) {
      if (e is GeneralException) {
        rethrow;
      }
      throw Exception('Something wrong');
    }
  }

  @override
  Future<EventDetailsResponse> getEventDetails(String eventId) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('http://10.0.2.2:8080/event/details/$eventId'),
        //Uri.parse('http://localhost:8080/auth/login'),
      );

      if (response.statusCode == 200) {
        return EventDetailsResponse.fromJson(response.body);
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

  @override
  Future<List<Content>> getAllEvents(String cityName) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('http://10.0.2.2:8080/event/upcoming/$cityName'),
        //Uri.parse('http://localhost:8080/auth/login'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Content> events =
            jsonData.map((x) => Content.fromMap(x)).toList();
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

  @override
  Future<List<Content>> getUpcomingEventsFiltered(
      String city,
      String name,
      List<int>? eventTypes,
      DateTime? startDate,
      DateTime? endDate,
      double minPrice,
      double maxPrice) async {
    try {
      String eventTypeString = '';
      String startFormatted = '';
      String endFormatted = '';
      if (eventTypes != null && eventTypes.isNotEmpty) {
        eventTypeString = eventTypes.join(',');
      }

      if (startDate != null) {
        startFormatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(startDate);
      }

      if (endDate != null) {
        endFormatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(endDate);
      }

      final response = await _httpClient.get(
        Uri.parse(
            'http://10.0.2.2:8080/event/upcoming/$city?&eventName=$name&eventTypes=$eventTypeString&start=$startFormatted&end=$endFormatted&min=$minPrice&max=$maxPrice'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Content> events =
            jsonData.map((x) => Content.fromMap(x)).toList();
        return events;
      } else if (response.statusCode == 404 ||
          response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        throw GeneralException.fromJson(response.body);
      } else {
        throw Exception('Failed to get events');
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
  Future<Uint8List> getEventPhoto(String eventId, int index) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(
            'http://10.0.2.2:8080/event/download-event-photo/$eventId/number/$index'),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse.containsKey('type') &&
            decodedResponse.containsKey('title') &&
            decodedResponse.containsKey('status') &&
            decodedResponse.containsKey('detail') &&
            decodedResponse.containsKey('instance')) {
          throw GeneralException.fromMap(decodedResponse);
        } else {
          throw Exception('Failed load photo');
        }
      }
    } catch (e) {
      if (e is GeneralException) {
        rethrow;
      } else if (e is ValidationException) {
        rethrow;
      } else if (e is SocketException) {
        throw Exception('No Internet connection');
      } else if (e is HttpException) {
        throw Exception('Failed to connect to the server');
      } else if (e is FormatException) {
        throw Exception('Bad response format');
      } else {
        rethrow;
      }
    }
  }
}
