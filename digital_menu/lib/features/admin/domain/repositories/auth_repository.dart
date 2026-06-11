import '../../../../core/network/cloud_result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<CloudResult<UserEntity>> signIn(String email, String password);
  Future<CloudResult<void>> signOut();
  Stream<UserEntity?> streamUser();
}
