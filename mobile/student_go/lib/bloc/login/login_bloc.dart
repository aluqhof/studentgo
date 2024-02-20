import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/dto/login_dto.dart';
import 'package:student_go/models/response/bad_credentials_exception.dart';
import 'package:student_go/models/response/login_response.dart';
import 'package:student_go/models/response/user_not_found_exception.dart';
import 'package:student_go/repository/auth/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<DoLoginEvent>(_doLogin);
  }

  /*void _getRequestToken(
      GetRequestTokenEvent event, Emitter<LoginState> emit) async {
    try {
      final SharedPreferences prefs = await _prefs;
      final response = await authRepository.getRequestToken();
      prefs.setString('request_token', response.requestToken!);
      emit(GetRequestTokenSuccess());
      return;
    } on Exception catch (e) {
      emit(GetRequestTokenError(e.toString()));
    }
  }*/

  void _doLogin(DoLoginEvent event, Emitter<LoginState> emit) async {
    emit(DoLoginLoading());

    try {
      final LoginDto loginDto =
          LoginDto(username: event.username, password: event.password);
      final response = await authRepository.login(loginDto);

      emit(DoLoginSuccess(response));
      return;
    } catch (e) {
      if (e is UserNotFoundException) {
        emit(DoLoginUserNotFoundException(e, "User Not Found Exception"));
      } else if (e is BadCredentialsException) {
        emit(DoLoginBadCredentialsException(e, "Bad Credentials Exception"));
      } else {
        emit(DoLoginError("An unexpected error occurred"));
      }
    }
  }
}
