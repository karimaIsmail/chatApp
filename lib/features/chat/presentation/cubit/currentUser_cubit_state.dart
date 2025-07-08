import 'package:chatapp/features/userAuth/domain/entities/user_entitiy.dart';
import 'package:equatable/equatable.dart';

class CurrentUsertState extends Equatable {
  final UserAuthEntity user;

  const CurrentUsertState({required this.user});

  @override
  List<Object?> get props => [user];
}

class CurrentUserDataLoading extends CurrentUsertState {
  const CurrentUserDataLoading({required super.user});
}

class CurrentUserDataLoaded extends CurrentUsertState {
  const CurrentUserDataLoaded({required super.user});
}

class CurrentUserDataFaluir extends CurrentUsertState {
  final String errorMessage;
  const CurrentUserDataFaluir(
      {required this.errorMessage, required super.user});
  @override
  List<Object> get props => [
        errorMessage,
      ];
}

class EditUserLoading extends CurrentUsertState {
  const EditUserLoading({required super.user});
}

class EditUserFailed extends CurrentUsertState {
  final String errorMessage;
  const EditUserFailed({required this.errorMessage, required super.user});
  @override
  List<Object> get props => [
        errorMessage,
      ];
}

class EditUserSucess extends CurrentUsertState {
  const EditUserSucess({required super.user});
}
