import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:chatapp/core/connection/network_info.dart';
import 'package:chatapp/core/databases/cache/cache_helper.dart';
import 'package:chatapp/core/databases/firebase/firebaseConsumer/firebase_firestore_data.dart';
import 'package:chatapp/features/chat/data/datasources/currentUser_local_data.dart';
import 'package:chatapp/features/chat/data/datasources/currentUser_remoteData.dart';
import 'package:chatapp/features/chat/data/repositories/currentUser_repository_impl.dart';
import 'package:chatapp/features/chat/domain/usecases/currentUser.dart';
import 'package:chatapp/features/chat/presentation/cubit/currentUser_cubit_state.dart';
import 'package:chatapp/features/userAuth/domain/entities/user_entitiy.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';

class CurrentUserCubit extends Cubit<CurrentUsertState> {
  CurrentUserCubit()
      : super(CurrentUserDataLoading(
            user: UserAuthEntity(email: '', username: '')));
  Uint8List? imageBytes;
  // ignore: non_constant_identifier_names
  final _getCurrentUser = GetCurrentUser(
      repository: CurrentUserRepositoryImpl(
          currentUserLocalDataSource:
              CurrentUserLocalDataSource(cache: CacheHelper()),
          currentUserReoteDataSource:
              CurrentUserReoteDataSource(userData: FirebaseFirestoreData()),
          networkInfo: NetworkInfoImpl(DataConnectionChecker())));
  //get current user from local data source

  void getCurrentUserInfo() async {
    var failureOrUser = await _getCurrentUser.getCurrentUser();
    failureOrUser.fold(
        (failure) => emit(CurrentUserDataFaluir(
              errorMessage: failure.errMessage,
              user: state.user,
            )), (user) async {
      emit(CurrentUserDataLoaded(user: user));
    });
    // });
  }

  void updateUserName({required String userName}) async {
    var failureOrUser =
        await _getCurrentUser.updateUserName(userName: userName);
    failureOrUser.fold(
        (failure) => emit(EditUserFailed(
              errorMessage: failure.errMessage,
              user: state.user,
            )), (user) {
      emit(CurrentUserDataLoaded(user: user));
    });
  }

  void updateUser() {
    emit(EditUserLoading(user: state.user));
  }
}
