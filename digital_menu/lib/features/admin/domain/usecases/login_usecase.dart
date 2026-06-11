import '../../../../core/network/cloud_result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<CloudResult<UserEntity>> call(String email, String password) {
    return _repository.signIn(email, password);
  }
}
