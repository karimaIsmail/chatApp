import 'package:chatapp/core/errors/failure.dart';
import 'package:chatapp/features/userAuth/domain/entities/user_entitiy.dart';
import 'package:dartz/dartz.dart';

abstract class UserAuthRepository {
  Future<Either<Failure, UserAuthEntity>> login(
      {required String email, required String password, required username});

  Future<Either<Failure, bool>> loginWithGoogle();
  Future<Failure> signOut();

  bool verifyEmail();

  Future<Either<Failure, bool>> signUp(
      {required String email, required String password});

  Future<Failure> resetPassword({required String email});
}
