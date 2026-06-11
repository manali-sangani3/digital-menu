import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    UserEntity? user,
    @Default(AuthStatus.initial) AuthStatus status,
    String? errorMessage,
  }) = _AuthState;
}
