import 'dart:convert';

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
      Uri.parse('http://10.0.2.2:8080/auth/login'),
      //Uri.parse('http://localhost:8080/auth/login'),
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
    final SharedPreferences prefs = await _prefs;
    final response = await _httpClient.post(
      Uri.parse('http://10.0.2.2:8080/auth/register-student'),
      //Uri.parse('http://localhost:8080/auth/register-student'),
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
    } else if (response.statusCode == 400) {
      return Future.error(ValidationException.fromJson(response.body));
    } else {
      throw Exception('Failed to do login');
    }
  }
}
