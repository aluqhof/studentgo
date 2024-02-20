import 'package:http/http.dart';
import 'package:student_go/models/dto/login_dto.dart';
import 'package:student_go/models/dto/register_dto.dart';
import 'package:student_go/models/response/login_response.dart';
import 'package:student_go/repository/auth/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final Client _httpClient = Client();

  @override
  Future<LoginResponse> login(LoginDto loginDto) async {
    final response = await _httpClient.post(
      Uri.parse('http://10.0.2.2:8080/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: loginDto.toJson(),
    );
    if (response.statusCode == 201) {
      return LoginResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to do login');
    }
  }

  @override
  Future<LoginResponse> register(RegisterDto registerDto) async {
    final response = await _httpClient.post(
      Uri.parse('http://10.0.2.2:8080/auth/register-student'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: registerDto.toJson(),
    );
    if (response.statusCode == 201) {
      return LoginResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to do login');
    }
  }

  /*@override
  Future<RequestTokenResponse> getRequestToken() async {
    final response = await _httpClient.get(
      Uri.parse('https://api.themoviedb.org/3/authentication/token/new'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0MzNkMmM0ODY1NzJhZmIyNDJjNmZlN2MxZGRjNjc3MSIsInN1YiI6IjVjYzZjYTBhMGUwYTI2NGVlZmVkYmQwZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Lr-_SOXieFdDd-0CNEqipNgfEviSHDP0uX1sm_H8bUI'
      },
    );
    if (response.statusCode == 200) {
      return RequestTokenResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to do get request token');
    }
  }*/
}
