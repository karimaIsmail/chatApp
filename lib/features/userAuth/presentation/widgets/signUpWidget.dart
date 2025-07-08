import 'package:chatapp/core/constants/app_strings.dart';
import 'package:chatapp/features/userAuth/presentation/cubit/user_auth_cubit_cubit.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/customButton.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/customformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<UserAuthCubit>();

    return Container(
        height: 320,
        margin: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        //  color: Colors.white,
        child: Stack(children: [
          Column(children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      CustomTextformField(
                        obscureText: false,
                        text: AppStrings.emailTiltle,
                        controller: authCubit.signUpEmail,
                        validator: (val) {
                          return authCubit.signUpEmailValidator(val);
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
                        controller: authCubit.signUpPassword,
                        validator:(val)=>authCubit.signUpPasswordValidator(val),
                      
                        prefexIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                            onPressed: authCubit.visiblePassowrd,
                            icon: Icon(authCubit.visiblePassword
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        keyBordType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //
                      CustomTextformField(
                        obscureText:
                            context.read<UserAuthCubit>().visiblePassword,
                        text: AppStrings.confirmPasswordTiltle,
                        controller: authCubit.confirmPassword,
                        prefexIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                            onPressed: authCubit.visiblePassowrd,
                            icon: Icon(authCubit.visiblePassword
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        validator: (val) {
                          return authCubit.confirmPasswordValidator(val);
                        },
                        keyBordType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
                Custombutton(
                  onPressed: () async {
                    if (authCubit.formState.currentState!.validate()) {
                      authCubit.signUp();
                    }
                  },
                  text: AppStrings.signUp,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ]),
        ]));
  }
}
