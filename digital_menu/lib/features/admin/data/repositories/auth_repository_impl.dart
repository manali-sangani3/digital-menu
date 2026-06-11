import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/network/cloud_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<CloudResult<UserEntity>> signIn(String email, String password) async {
    try {
      final user = await _remoteDataSource.signIn(email, password);
      if (user != null) {
        return CloudResult(
          statusCode: 200,
          data: UserEntity(
            uid: user.uid,
            email: user.email ?? '',
          ),
          message: 'Sign in successful.',
        );
      } else {
        return const CloudResult(
          statusCode: 401,
          message: 'User is null after successful authentication.',
        );
      }
    } on FirebaseAuthException catch (e) {
      return CloudResult(
        statusCode: 401,
        message: e.message ?? 'Authentication failed.',
      );
    } catch (e) {
      final errorString = e.toString();
      // Detect unauthorized-domain errors surfaced via the Pigeon platform channel.
      // This occurs when the hosting URL is not listed in Firebase Console →
      // Authentication → Settings → Authorized Domains.
      if (errorString.contains('unauthorized-domain') ||
          errorString.contains('FirebaseAuthHostApi')) {
        return const CloudResult(
          statusCode: 403,
          message: 'Sign-in is not permitted from this domain. '
              'Add this URL to Firebase Console → '
              'Authentication → Settings → Authorized Domains.',
        );
      }
      return CloudResult(
        statusCode: 500,
        message: 'An unexpected error occurred: $e',
      );
    }

  }

  @override
  Future<CloudResult<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const CloudResult(
        statusCode: 200,
        message: 'Sign out successful.',
      );
    } on FirebaseAuthException catch (e) {
      return CloudResult(
        statusCode: 500,
        message: e.message ?? 'Sign out failed.',
      );
    } catch (e) {
      return CloudResult(
        statusCode: 500,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Stream<UserEntity?> streamUser() {
    return _remoteDataSource.streamCurrentUser().map((user) {
      if (user == null) return null;
      return UserEntity(
        uid: user.uid,
        email: user.email ?? '',
      );
    });
  }
}
