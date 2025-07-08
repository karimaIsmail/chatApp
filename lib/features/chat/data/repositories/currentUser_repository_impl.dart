import 'dart:ffi';
import 'dart:typed_data';

import 'package:chatapp/core/constants/app_strings.dart';
import 'package:chatapp/core/errors/expentions.dart';
import 'package:chatapp/core/connection/network_info.dart';

import 'package:chatapp/core/errors/failure.dart';
import 'package:chatapp/features/chat/data/datasources/currentUser_local_data.dart';
import 'package:chatapp/features/chat/data/datasources/currentUser_remoteData.dart';
import 'package:chatapp/features/chat/domain/repositories/currentUser_repository.dart';
import 'package:chatapp/features/userAuth/data/models/userAuth_model.dart';
import 'package:chatapp/features/userAuth/domain/entities/user_entitiy.dart';
import 'package:dartz/dartz.dart';

class CurrentUserRepositoryImpl extends CurrentUserRepository {
  final CurrentUserLocalDataSource currentUserLocalDataSource;
  final CurrentUserReoteDataSource currentUserReoteDataSource;
  final NetworkInfo networkInfo;

  CurrentUserRepositoryImpl({
    required this.networkInfo,
    required this.currentUserReoteDataSource,
    required this.currentUserLocalDataSource,
  });

  @override
  //get current user from local data source
  Future<Either<Failure, UserAuthEntity>> getCurrentUser() async {
    try {
      UserAuthModel localUser = await currentUserLocalDataSource.getUser();
      return Right(localUser);
    } on CacheExeption catch (e) {
      return Left(Failure(errMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> upDateImage(
      {required String imageUrl}) async {
    if (await networkInfo.isConnected!) {
      try {
        UserAuthModel User =
            await currentUserReoteDataSource.updateImage(imageUrl: imageUrl);
        currentUserLocalDataSource.cacheUser(User);
        return Right(User);
      } on CustomException catch (e) {
        return Left(Failure(errMessage: e.message));
      }
    } else {
      return Left(Failure(errMessage: AppStrings.noEnternetConnection));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> upDateUserName(
      {required String userName}) async {
    if (await networkInfo.isConnected!) {
      try {
        UserAuthModel User =
            await currentUserReoteDataSource.updateUserName(userName: userName);
        currentUserLocalDataSource.cacheUser(User);

        return Right(User);
      } on CustomException catch (e) {
        return Left(Failure(errMessage: e.message));
      }
    } else {
      return Left(Failure(errMessage: AppStrings.noEnternetConnection));
    }
  }

  @override
  Future<Either<Failure, Uint8List?>> imageByteConvert(
      {required String imageUrl}) async {
    try {
      final image =
          await currentUserReoteDataSource.imageBytesConvert(imageUrl);
      return Right(image);
    } on CustomException catch (e) {
      return Left(Failure(errMessage: e.message));
    }
  }
}
