import 'package:student_go/models/dto/login_dto.dart';
import 'package:student_go/models/dto/register_dto.dart';
import 'package:student_go/models/response/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginDto loginDto);
  Future<LoginResponse> register(RegisterDto registerDto);
  //Future<RequestTokenResponse> getRequestToken();
}
