import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class StreamUserUseCase {
  final AuthRepository _repository;

  StreamUserUseCase(this._repository);

  Stream<UserEntity?> call() {
    return _repository.streamUser();
  }
}
