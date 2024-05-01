import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/interceptor/auth_request_interceptor.dart';
import 'package:student_go/models/dto/change_username_request.dart';
import 'package:student_go/models/dto/update_profile_request.dart';
import 'package:student_go/models/response/change_user_name_response.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/list_events_response/content.dart';
import 'package:student_go/models/response/student_info_response/student_info_response.dart';
import 'package:student_go/models/response/upload_response.dart';
import 'package:student_go/models/response/validation_exception/validation_exception.dart';
import 'package:student_go/repository/student/student_repository.dart';
import 'package:http/http.dart' as http;

class StudentRepositoryImp extends StudentRepository {
  final Client _httpClient = InterceptedClient.build(interceptors: [
    AuthRequestInterceptor(),
  ]);

  @override
  Future<StudentInfoResponse> getStudentProfile() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('http://10.0.2.2:8080/student/'),
        //Uri.parse('http://localhost:8080/auth/login'),
      );

      if (response.statusCode == 200) {
        return StudentInfoResponse.fromJson(response.body);
      } else {
        throw Exception('Failed to get event types');
      }
    } catch (e) {
      if (e is GeneralException) {
        rethrow;
      }
      throw Exception('Something wrong');
    }
  }

  @override
  Future<StudentInfoResponse> saveOrUnsaveEvent(String eventId) async {
    try {
      final response = await _httpClient.put(
        Uri.parse('http://10.0.2.2:8080/student/save-unsave-event/$eventId'),
        //Uri.parse('http://localhost:8080/auth/login'),
      );

      if (response.statusCode == 200) {
        return StudentInfoResponse.fromJson(response.body);
      } else {
        throw Exception('Failed to save or unsave event');
      }
    } catch (e) {
      if (e is GeneralException) {
        rethrow;
      }
      throw Exception('Something wrong');
    }
  }

  @override
  Future<List<Content>> getAllSavedEvents() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('http://10.0.2.2:8080/student/saved-events'),
        //Uri.parse('http://localhost:8080/auth/login'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Content> eventsSaved =
            jsonData.map((x) => Content.fromMap(x)).toList();
        return eventsSaved;
      } else {
        throw Exception('Failed to save or unsave event');
      }
    } catch (e) {
      if (e is GeneralException) {
        rethrow;
      }
      throw Exception('Something wrong');
    }
  }

  @override
  Future<ChangeUserNameResponse> changeUsername(
      ChangeUsernameRequest changeUsernameRequest) async {
    try {
      final response = await _httpClient.put(
        Uri.parse('http://10.0.2.2:8080/user/change-username'),
        //Uri.parse('http://localhost:8080/auth/login'),
        body: changeUsernameRequest.toJson(),
      );

      if (response.statusCode == 200) {
        return ChangeUserNameResponse.fromJson(response.body);
      } else {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse.containsKey('type') &&
            decodedResponse.containsKey('title') &&
            decodedResponse.containsKey('status') &&
            decodedResponse.containsKey('detail') &&
            decodedResponse.containsKey('instance')) {
          if (decodedResponse.containsKey('Fields errors')) {
            throw ValidationException.fromMap(decodedResponse);
          } else {
            throw GeneralException.fromMap(decodedResponse);
          }
        } else {
          throw Exception('Failed to change username');
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

  @override
  Future<StudentInfoResponse> updateProfile(
      UpdateProfileRequest updateProfileRequest) async {
    try {
      final response = await _httpClient.put(
        Uri.parse('http://10.0.2.2:8080/user/student/update'),
        //Uri.parse('http://localhost:8080/auth/login'),
        body: updateProfileRequest.toJson(),
      );

      if (response.statusCode == 200) {
        return StudentInfoResponse.fromJson(response.body);
      } else {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse.containsKey('type') &&
            decodedResponse.containsKey('title') &&
            decodedResponse.containsKey('status') &&
            decodedResponse.containsKey('detail') &&
            decodedResponse.containsKey('instance')) {
          if (decodedResponse.containsKey('Fields errors')) {
            throw ValidationException.fromMap(decodedResponse);
          } else {
            throw GeneralException.fromMap(decodedResponse);
          }
        } else {
          throw Exception('Failed to change username');
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
        // Rethrow any other exception
        rethrow;
      }
    }
  }

  @override
  Future<Uint8List> getUserPhoto() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('http://10.0.2.2:8080/download-profile-photo'),
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
          throw Exception('Failed to change username');
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

  @override
  Future<UploadResponse> uploadProfilePhoto(XFile image) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8080/upload-profile-image'),
      );

      final file = File(image.path);
      final bytes = await file.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: image.path.split('/').last,
      );

      request.files.add(multipartFile);

      request.headers[HttpHeaders.acceptHeader] =
          'application/json; charset=utf-8';
      request.headers[HttpHeaders.contentTypeHeader] = 'application/json;';
      request.headers[HttpHeaders.authorizationHeader] =
          'Bearer ${prefs.getString('token')!}';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return UploadResponse.fromJson(response.body);
      } else {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse.containsKey('type') &&
            decodedResponse.containsKey('title') &&
            decodedResponse.containsKey('status') &&
            decodedResponse.containsKey('detail') &&
            decodedResponse.containsKey('instance')) {
          if (decodedResponse.containsKey('Fields errors')) {
            throw ValidationException.fromMap(decodedResponse);
          } else {
            throw GeneralException.fromMap(decodedResponse);
          }
        } else {
          throw Exception('Failed to change username');
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
        // Rethrow any other exception
        rethrow;
      }
    }
  }
}
