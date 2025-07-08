import 'package:chatapp/features/userAuth/domain/entities/user_entitiy.dart';
// import 'package:equatable/equatable.dart';

abstract class UserAuthCubitState {
  // @override
  // List<Object?> get props => [];
}

class UserAuthCubitInitial extends UserAuthCubitState {}

class UserAuthCubLodingState extends UserAuthCubitState {}

class UserAuthVisiblePasswordState extends UserAuthCubitState {
  final bool visiblePassword;

  UserAuthVisiblePasswordState({required this.visiblePassword});
  // @override
  // List<Object?> get props => [visiblePassword];
}

class LoginSignUpSwitchingState extends UserAuthCubitState {
  final int pageNumber;

  LoginSignUpSwitchingState({required this.pageNumber});
  // @override
  // List<Object?> get props => [pageNumber];
}

class LoginLodingState extends UserAuthCubitState {}

class LoginSucessState extends UserAuthCubitState {
  final UserAuthEntity user;

  LoginSucessState({required this.user});
  // @override
  // List<Object?> get props => [user];
}

class LoginFaileurState extends UserAuthCubitState {
  final String errorMessage;

  LoginFaileurState({required this.errorMessage});
  // @override
  // List<Object?> get props => [errorMessage];
}

class LoginWithGoogleLodingState extends UserAuthCubitState {}

class LoginWithGoogleSucessState extends UserAuthCubitState {
  final bool response;

  LoginWithGoogleSucessState({required this.response});
  // @override
  // List<Object?> get props => [response];
}

class LoginWithGoogleFaileurState extends UserAuthCubitState {
  final String errorMessage;

  LoginWithGoogleFaileurState({required this.errorMessage});
  // @override
  // List<Object?> get props => [errorMessage];
}

class SignUpLodingState extends UserAuthCubitState {}

class SignUpSucessState extends UserAuthCubitState {
  final String message;

  SignUpSucessState(this.message);
  // @override
  // List<Object?> get props => [message];
}

class SignUpFaileurState extends UserAuthCubitState {
  final String errorMessage;

  SignUpFaileurState({required this.errorMessage});
  // @override
  // List<Object?> get props => [errorMessage];
}

class ResetPasswordFaileurState extends UserAuthCubitState {
  final String errorMessage;

  ResetPasswordFaileurState({required this.errorMessage});
  // @override
  // List<Object?> get props => [errorMessage];
}

class ResetPasswordSucessState extends UserAuthCubitState {
  ResetPasswordSucessState();
}
