import '../../../../core/network/cloud_result.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<CloudResult<void>> call() {
    return _repository.signOut();
  }
}
