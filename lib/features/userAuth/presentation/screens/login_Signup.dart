// ignore_for_file: unused_local_variable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chatapp/core/constants/app_strings.dart';
import 'package:chatapp/core/constants/routesNames.dart';
import 'package:chatapp/features/userAuth/presentation/cubit/user_auth_cubit_cubit.dart';
import 'package:chatapp/features/userAuth/presentation/cubit/user_auth_cubit_state.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/customDialouge.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/loadingWidget.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/loginWidget.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/signUpWidget.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/toggleWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoginSignUp extends StatelessWidget {
  final Color iconColor = const Color.fromARGB(255, 72, 9, 90);

  const LoginSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return BlocConsumer<UserAuthCubit, UserAuthCubitState>(
        listener: (context, state) {
      checkstate(state, context);
      //
    }, builder: (context, state) {
      final UserAuthCubit authCubit = context.read<UserAuthCubit>();

      return Scaffold(
          backgroundColor: Colors.white,
          body: state is UserAuthCubLodingState || state is LoginLodingState
              ? LoadingWidget()
              : Container(
                  decoration: customDecoration(),
                  child: Form(
                      key: authCubit.formState,
                      child: Stack(
                        children: [
                          ToggleWidget(),
                          Positioned(
                            bottom: 0,
                            child: SizedBox(
                              width: mediaSize.width,
                              height: mediaSize.height * 0.60,
                              child: SizedBox(
                                height: double.infinity,
                                width: 500,
                                child: PageView(
                                  onPageChanged: (val) {
                                    authCubit.loginSignupSelection(val);
                                  },
                                  controller: authCubit.pageController,
                                  children: <Widget>[
                                    Loginwidget(),
                                    SignUpWidget()
                                  ],
                                ),
                              ),
                            ),
                            //  )
                          )
                        ],
                      )),
                ));
    });
  }
}

void checkstate(UserAuthCubitState state, BuildContext context) {
  switch (state.runtimeType) {
    case ResetPasswordFaileurState:
      CustomDialogue(
              AppStrings.error,
              (state as ResetPasswordFaileurState).errorMessage,
              DialogType.error,
              context: context)
          .show();
      break;
    case SignUpSucessState:
      CustomDialogue(
              AppStrings.information, AppStrings.verifyEmail, DialogType.info,
              context: context)
          .show();
      break;

    case SignUpFaileurState:
      CustomDialogue(AppStrings.error,
              (state as SignUpFaileurState).errorMessage, DialogType.error,
              context: context)
          .show();
      break;
    case LoginFaileurState:
      CustomDialogue(AppStrings.error,
              (state as LoginFaileurState).errorMessage, DialogType.error,
              context: context)
          .show();
      break;

    case LoginWithGoogleFaileurState:
      CustomDialogue(
              AppStrings.error,
              (state as LoginWithGoogleFaileurState).errorMessage,
              DialogType.error,
              context: context)
          .show();
      break;

    case ResetPasswordSucessState:
      CustomDialogue(
              AppStrings.information, AppStrings.resetPassword, DialogType.info,
              context: context)
          .show();
      break;
    case LoginSucessState:
    
      Get.offNamedUntil(AppRouts.friendsListPage, (route) => false);


      break;
  }
}

BoxDecoration customDecoration() {
  return BoxDecoration(
      gradient: LinearGradient(
    colors: [
      Colors.white24,
      Color.fromARGB(197, 160, 136, 196),
      Colors.white70,
      Color.fromARGB(197, 160, 136, 196),
      Colors.white70,
      Color.fromARGB(197, 160, 136, 196),
      Colors.white70,
      Color.fromARGB(197, 160, 136, 196),
      Colors.white24,
      Color.fromARGB(197, 160, 136, 196),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ));
}
