import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/models/dto/login_dto.dart';
import 'package:student_go/models/dto/register_dto.dart';
import 'package:student_go/models/response/bad_credentials_exception.dart';
import 'package:student_go/models/response/login_response.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/validation_exception/validation_exception.dart';
import 'package:student_go/repository/auth/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final Client _httpClient = Client();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<LoginResponse> login(LoginDto loginDto) async {
    final SharedPreferences prefs = await _prefs;
    final response = await _httpClient.post(
      Uri.parse('http://192.168.9.12:8080/auth/login'),
      //Uri.parse('http://192.168.9.12:8080/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: loginDto.toJson(),
    );
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final String authToken = responseData['token'];
      await prefs.setString('token', authToken);
      return LoginResponse.fromJson(response.body);
    } else if (response.statusCode == 403) {
      return Future.error(GeneralException.fromJson(response.body));
    } else if (response.statusCode == 401) {
      return Future.error(BadCredentialsException.fromJson(response.body));
    } else {
      throw Exception('Failed to do login');
    }
  }

  @override
  Future<LoginResponse> register(RegisterDto registerDto) async {
    try {
      final SharedPreferences prefs = await _prefs;
      final response = await _httpClient.post(
        Uri.parse('http://192.168.9.12:8080/auth/register-student'),
        //Uri.parse('http://192.168.9.12:8080/auth/register-student'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: registerDto.toJson(),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final String authToken = responseData['token'];
        await prefs.setString('token', authToken);
        return LoginResponse.fromJson(response.body);
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
}
