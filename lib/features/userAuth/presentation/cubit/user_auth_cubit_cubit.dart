import 'package:chatapp/core/connection/network_info.dart';
import 'package:chatapp/core/constants/app_strings.dart';
import 'package:chatapp/core/databases/cache/cache_helper.dart';
import 'package:chatapp/core/databases/firebase/firebaseConsumer/firebase_Auth_data.dart';
import 'package:chatapp/core/errors/failure.dart';
import 'package:chatapp/features/userAuth/data/datasources/localDataSource.dart';
import 'package:chatapp/features/userAuth/data/datasources/remoteDataSource.dart';
import 'package:chatapp/features/userAuth/data/repositories/userAuth_repository_impl.dart';
import 'package:chatapp/features/userAuth/domain/usecases/userAut_case.dart';
import 'package:chatapp/features/userAuth/presentation/cubit/user_auth_cubit_state.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAuthCubit extends Cubit<UserAuthCubitState> {
  UserAuthCubit() : super(UserAuthCubitInitial());

  UserCredential? credential;
  final auth = FirebaseAuth.instance;
  bool isExistingSelected = true;
  bool visiblePassword = false;
  int? selectedPageNumber = 0;

  bool isLoading = false;
  String errorMessage = "";
  PageController pageController = PageController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController signUpEmail = TextEditingController();
  TextEditingController signUpPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController userName = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  void loginSignupSelection(int pageNumber) {
    isExistingSelected = (pageNumber == 0) ? true : false;
    resetControllers();

    emit(LoginSignUpSwitchingState(pageNumber: pageNumber));
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  void resetControllers() {
    email.clear();
    signUpEmail.clear();
    password.clear();
    signUpPassword.clear();
    confirmPassword.clear();
    userName.clear();
  }

  void disposeControllers() {
    email.dispose();
    signUpEmail.dispose();
    password.dispose();
    signUpPassword.dispose();
    confirmPassword.dispose();
    userName.dispose();
  }

  void visiblePassowrd() {
    visiblePassword = !visiblePassword;
    emit(UserAuthVisiblePasswordState(visiblePassword: visiblePassword));
  }

  final userAuthCase = UserAuthCase(
      repository: UserAuthRepositoryImpl(
          userLocalDataSource: UserLocalDataSource(cache: CacheHelper()),
          networkInfo: NetworkInfoImpl(DataConnectionChecker()),
          firebase: FirebaseAuthDataSource(firebase: FirebaseAutData())));

   void login() async {
    emit(LoginLodingState());
    final failureOrUser = await userAuthCase.login(
        email: email.text, password: password.text, username: userName.text);
    failureOrUser.fold(
        (failure) => emit(LoginFaileurState(errorMessage: failure.errMessage)),
        (user) {
      if (checkVerifyEmail()) {
        resetControllers();
        emit(LoginSucessState(user: user));
      } else {
        emit(LoginFaileurState(errorMessage: AppStrings.verifyEmail));
      }
    });
  }

  void loginWithGoogle() async {
    emit(LoginWithGoogleLodingState());
    final failureOrUser = await userAuthCase.loginWithGoogle();
    failureOrUser.fold(
        (failure) =>
            emit(LoginWithGoogleFaileurState(errorMessage: failure.errMessage)),
        (response) => (LoginWithGoogleSucessState(response: response)));
  }

  void signUp() async {
    emit(SignUpLodingState());
    final failureOrUser = await userAuthCase.signUp(
        email: signUpEmail.text, password: signUpPassword.text);
    failureOrUser.fold(
        (failure) => emit(SignUpFaileurState(errorMessage: failure.errMessage)),
        (response) => (SignUpSucessState(AppStrings.verifyEmail)));
  }

  void resetPassword() async {
    Failure response = await userAuthCase.resetPassword(email: email.text);
    if (response.errMessage.isEmpty) {
      emit(ResetPasswordSucessState());
    } else {
      emit(ResetPasswordFaileurState(errorMessage: response.errMessage));
    }
  }

  bool checkVerifyEmail() {
    return userAuthCase.verifyEmail();
  }

  String? loginPasswordValidator(String? val) {
    if (val!.isEmpty && pageController.page == 0) {
      return AppStrings.enterPassword;
    }
    if ((val.length < 8 || val.length > 8) && pageController.page == 0) {
      return AppStrings.validatePassword;
    }
    return null;
  }

  String? userNameValidator(String? val) {
    if (val!.isEmpty && pageController.page == 0) {
      return AppStrings.enterUserName;
    }
    return null;
  }

  String? loginEmailValidator(String? val) {
    if (val!.isEmpty && pageController.page == 0) {
      return AppStrings.enterEmail;
    }
    if (!isValidEmail(email.text.trim()) && pageController.page == 0) {
      return AppStrings.validateEmail;
    }
    return null;
  }

  String? signUpEmailValidator(String? val) {
    if (val!.isEmpty && (pageController.page != 0)) {
      return AppStrings.enterConfirmPassword;
    }

    if (!isValidEmail(signUpEmail.text.trim()) && (pageController.page != 0)) {
      return AppStrings.validateEmail;
    }
    return null;
  }

  String? signUpPasswordValidator(String? val) {
    if (val!.isEmpty && pageController.page != 0) {
      return AppStrings.enterPassword;
    }
    if ((val.length < 8 || val.length > 8) && (pageController.page != 0)) {
      return AppStrings.validatePassword;
    }
    return null;
  }

  String? confirmPasswordValidator(String? val) {
    if (val!.isEmpty && pageController.page != 0) {
      return AppStrings.enterConfirmPassword;
    }
    if ((signUpPassword.text != val) && pageController.page != 0) {
      return AppStrings.validateConfirmPassword;
    }
    return null;
  }
}
