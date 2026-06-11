import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/stream_user_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final StreamUserUseCase _streamUserUseCase;

  StreamSubscription? _userSubscription;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required StreamUserUseCase streamUserUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _streamUserUseCase = streamUserUseCase,
        super(const AuthState()) {
    _monitorAuthState();
  }

  void _monitorAuthState() {
    _userSubscription?.cancel();
    _userSubscription = _streamUserUseCase().listen(
      (user) {
        if (user != null) {
          emit(state.copyWith(
            user: user,
            status: AuthStatus.authenticated,
            errorMessage: null,
          ));
        } else {
          emit(state.copyWith(
            user: null,
            status: AuthStatus.unauthenticated,
            errorMessage: null,
          ));
        }
      },
      onError: (error) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final result = await _loginUseCase(email, password);
    if (!result.isSuccess) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: result.message,
      ));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final result = await _logoutUseCase();
    if (!result.isSuccess) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: result.message,
      ));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
