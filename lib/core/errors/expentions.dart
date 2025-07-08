//! CustomFirebaseException
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class CustomException implements Exception {
  final String message;
  CustomException({required this.message});
}

class CacheExeption extends CustomException {
  CacheExeption({required super.message});
}

void handleFirebaseException(Exception e) {
  if (e is FirebaseAuthException) {
    throw CustomException(message: e.code);
  } else if (e is PlatformException) {
    throw CustomException(message: e.code);
  } else {
    throw CustomException(message: e.toString());
  }
}

void handleException(Exception e) {
  if (e is PlatformException) {
    throw CustomException(message: e.code);
  } else {
    throw CustomException(message: e.toString());
  }
}
