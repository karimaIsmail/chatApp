import 'package:chatapp/core/connection/network_info.dart';
import 'package:chatapp/core/constants/app_strings.dart';
import 'package:chatapp/core/errors/expentions.dart';
import 'package:chatapp/core/errors/failure.dart';
import 'package:chatapp/features/userAuth/data/datasources/localDataSource.dart';
import 'package:chatapp/features/userAuth/data/datasources/remoteDataSource.dart';
import 'package:chatapp/features/userAuth/data/models/userAuth_model.dart';
import 'package:chatapp/features/userAuth/domain/entities/user_entitiy.dart';
import 'package:chatapp/features/userAuth/domain/repositories/userAuth_repository.dart';
import 'package:dartz/dartz.dart';

class UserAuthRepositoryImpl extends UserAuthRepository {
  final NetworkInfo networkInfo;
  final FirebaseAuthDataSource firebase;
  final UserLocalDataSource userLocalDataSource;
  UserAuthRepositoryImpl(
      {required this.userLocalDataSource,
      required this.networkInfo,
      required this.firebase});
  @override
  Future<Either<Failure, UserAuthEntity>> login(
      {required String email,
      required String password,
      required username}) async {
    if (await networkInfo.isConnected!) {
      try {
        UserAuthModel remoteUser = await firebase.login(
          email: email,
          password: password,
          username: username,
        );
        userLocalDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      } on CustomException catch (e) {
        return Left(Failure(errMessage: e.message));
      }
    } else {
      return Left(Failure(errMessage: AppStrings.noEnternetConnection));
    }
  }

  @override
  Future<Either<Failure, bool>> loginWithGoogle() async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await firebase.signInWithGoogle();
        return Right(response);
      } on CustomException catch (e) {
        return Left(Failure(errMessage: e.message));
      }
    } else {
      return Left(Failure(errMessage: AppStrings.noEnternetConnection));
    }
  }

  @override
  bool verifyEmail() {
    return firebase.verifyEmail();
  }

  @override
  Future<Failure> resetPassword({required String email}) async {
    if (await networkInfo.isConnected!) {
      try {
        await firebase.resetPassword(email: email);

        return Failure(errMessage: '');
      } on CustomException catch (e) {
        return Failure(errMessage: e.message);
      }
    } else {
      return Failure(errMessage: AppStrings.noEnternetConnection);
    }
  }

  @override
  Future<Either<Failure, bool>> signUp(
      {required String email, required String password}) async {
    if (await networkInfo.isConnected!) {
      try {
        final response =
            await firebase.signUp(email: email, password: password);
        return Right(response);
      } on CustomException catch (e) {
        return Left(Failure(errMessage: e.message));
      }
    } else {
      return Left(Failure(errMessage: AppStrings.noEnternetConnection));
    }
  }

  @override
  Future<Failure> signOut() async {
    if (await networkInfo.isConnected!) {
      try {
        await firebase.signOut();

        return Failure(errMessage: '');
      } on CustomException catch (e) {
        return Failure(errMessage: e.message);
      }
    } else {
      return Failure(errMessage: AppStrings.noEnternetConnection);
    }
  }
}
