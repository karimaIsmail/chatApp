import 'package:chatapp/core/constants/app_strings.dart';
import 'package:chatapp/features/userAuth/presentation/cubit/user_auth_cubit_cubit.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/customButton.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/customformfield.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/forgetPasswordWidget.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/loginWithGoogleWidegt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Loginwidget extends StatelessWidget {
  const Loginwidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<UserAuthCubit>();
    return Container(
        height: 200,
        margin: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        //  color: Colors.white,
        child: Stack(children: [
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        CustomTextformField(
                          obscureText: false,
                          text: AppStrings.emailTiltle,
                          controller: authCubit.email,
                          validator: (val) {
                            return authCubit.loginEmailValidator(val);
                          },
                          prefexIcon: Icon(Icons.email),
                          keyBordType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextformField(
                          obscureText: authCubit.visiblePassword,
                          text: AppStrings.passwordTiltle,
                          controller: authCubit.password,
                          validator: (val) {
                            return authCubit.loginPasswordValidator(val);
                          },
                          prefexIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: authCubit.visiblePassowrd,
                              icon: Icon(authCubit.visiblePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                          keyBordType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        CustomTextformField(
                          obscureText: false,
                          text: AppStrings.userNameTiltle,
                          controller: authCubit.userName,
                          validator:
                           (val) {
                            return authCubit.userNameValidator(val);
                          },
                          prefexIcon: Icon(Icons.person),
                          keyBordType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: ForgetPasswordWidget(
                              onTap: () {
                                if (authCubit.formState.currentState!
                                    .validate()) {
                                  authCubit.resetPassword();
                                }
                              },
                            )),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                  Custombutton(
                    onPressed: () {
                      if (authCubit.formState.currentState!.validate()) {
                        authCubit.login();
                      }
                    },
                    text: AppStrings.logIn,
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                  onTap: authCubit.loginWithGoogle,
                  child: LoginWithGoogleWidget()),
            ],
          ),
        ]));
  }
}
