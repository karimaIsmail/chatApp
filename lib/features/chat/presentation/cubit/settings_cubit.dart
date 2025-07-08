import 'package:bloc/bloc.dart';
import 'package:chatapp/core/connection/network_info.dart';
import 'package:chatapp/core/databases/cache/cache_helper.dart';
import 'package:chatapp/core/databases/firebase/firebaseConsumer/firebase_Auth_data.dart';
import 'package:chatapp/core/errors/failure.dart';
import 'package:chatapp/features/chat/domain/entities/settings_entity.dart';
import 'package:chatapp/features/chat/presentation/cubit/settings_state.dart';
import 'package:chatapp/features/userAuth/data/datasources/localDataSource.dart';
import 'package:chatapp/features/userAuth/data/datasources/remoteDataSource.dart';
import 'package:chatapp/features/userAuth/data/repositories/userAuth_repository_impl.dart';
import 'package:chatapp/features/userAuth/domain/usecases/userAut_case.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsStatetInitial());

  final userAuthCase = UserAuthCase(
      repository: UserAuthRepositoryImpl(
          userLocalDataSource: UserLocalDataSource(cache: CacheHelper()),
          networkInfo: NetworkInfoImpl(DataConnectionChecker()),
          firebase: FirebaseAuthDataSource(firebase: FirebaseAutData())));
  chooseColor(int index) {
    emit(state.copywith(settings: state.settings.copyWith(colorsIndex: index)));
  }

  chooseLanguage(enLanguage languge) {
    emit(state.copywith(settings: state.settings.copyWith(language: languge)));
  }

  toggleColors() {
    emit(state.copywith(
        settings: state.settings
            .copyWith(toggleColors: !state.settings.toggleColors)));
  }

  toggleLanguage() {
    emit(state.copywith(
        settings: state.settings
            .copyWith(toggleLanguage: !state.settings.toggleLanguage)));
  }

  toggleSettings() {
    emit(state.copywith(
        settings: state.settings
            .copyWith(openSettings: !state.settings.toggleSettings)));
  }

  void signOut() async {
    Failure Response = await userAuthCase.signOut();
    if (Response.errMessage.isEmpty) {
      emit(SignOutSucessState(settings: state.settings));
    } else {
      {
        emit(SignOutFailureState(
          settings: state.settings.copyWith(errorMessage: Response.errMessage),
        ));
      }
    }
  }
}
