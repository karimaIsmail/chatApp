import 'package:chatapp/core/errors/failure.dart';
import 'package:chatapp/features/userAuth/domain/entities/user_entitiy.dart';
import 'package:chatapp/features/userAuth/domain/repositories/userAuth_repository.dart';
import 'package:dartz/dartz.dart';

class UserAuthCase {
  final UserAuthRepository repository;

  UserAuthCase({required this.repository});

  Future<Either<Failure, UserAuthEntity>> login(
      {required String email, required String password, required username}) {
    return repository.login(
        email: email, password: password, username: username);
  }

  bool verifyEmail() {
    return repository.verifyEmail();
  }

  Future<Either<Failure, bool>> loginWithGoogle() {
    return repository.loginWithGoogle();
  }

  Future<Either<Failure, bool>> signUp(
      {required String email, required String password}) {
    return repository.signUp(email: email, password: password);
  }

  Future<Failure> resetPassword({required String email}) {
    return repository.resetPassword(email: email);
  }

  Future<Failure> signOut() {
    return repository.signOut();
  }
}
