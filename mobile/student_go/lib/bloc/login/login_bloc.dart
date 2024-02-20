import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/models/dto/login_dto.dart';
import 'package:student_go/models/response/login_response.dart';
import 'package:student_go/repository/auth/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
    final SharedPreferences prefs = await _prefs;
    final String requestToken = prefs.getString('request_token') ?? '';

    try {
      final LoginDto loginDto =
          LoginDto(username: event.username, password: event.password);
      final response = await authRepository.login(loginDto);
      emit(DoLoginSuccess(response));
      return;
    } on Exception catch (e) {
      emit(DoLoginError(e.toString()));
    }
  }
}
