import 'dart:typed_data';

import 'package:chatapp/core/errors/failure.dart';

import 'package:chatapp/features/userAuth/domain/entities/user_entitiy.dart';
import 'package:dartz/dartz.dart';

abstract class CurrentUserRepository {
  Future<Either<Failure, UserAuthEntity>> getCurrentUser();
  Future<Either<Failure, UserAuthEntity>> upDateUserName(
      {required String userName});
  Future<Either<Failure, UserAuthEntity>> upDateImage(
      {required String imageUrl});
  Future<Either<Failure, Uint8List?>> imageByteConvert(
      {required String imageUrl});
}
