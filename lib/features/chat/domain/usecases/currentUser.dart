import 'dart:typed_data';

import 'package:chatapp/core/errors/failure.dart';
import 'package:chatapp/features/chat/domain/repositories/currentUser_repository.dart';

import 'package:chatapp/features/userAuth/domain/entities/user_entitiy.dart';
import 'package:dartz/dartz.dart';

class GetCurrentUser {
  final CurrentUserRepository repository;

  GetCurrentUser({required this.repository});

  Future<Either<Failure, UserAuthEntity>> getCurrentUser() {
    return repository.getCurrentUser();
  }

  Future<Either<Failure, UserAuthEntity>> updateUserName(
      {required String userName}) {
    return repository.upDateUserName(userName: userName);
  }

  Future<Either<Failure, UserAuthEntity>> updateImage(
      {required String imageUrl}) {
    return repository.upDateImage(imageUrl: imageUrl);
  }

  Future<Either<Failure, Uint8List?>> imageByteConverter(
      {required String imageUrl}) {
    return repository.imageByteConvert(imageUrl: imageUrl);
  }
}
