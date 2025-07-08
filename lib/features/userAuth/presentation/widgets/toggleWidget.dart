import 'package:chatapp/core/constants/app_strings.dart';
import 'package:chatapp/features/userAuth/presentation/cubit/user_auth_cubit_cubit.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/customLogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleWidget extends StatelessWidget {
  const ToggleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserAuthCubit authCubit = context.read<UserAuthCubit>();

    return Positioned(
        top: 20,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 20,
            ),
            CustomLogo(),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 250,
              height: 45,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(197, 121, 73, 194),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: Offset(3, 3),
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    left: authCubit.isExistingSelected ? 0 : 120,
                    top: 0,
                    bottom: 0,
                    right: authCubit.isExistingSelected ? 120 : 0,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.existing,
                            style: TextStyle(
                              color: authCubit.isExistingSelected
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.newAccount,
                            style: TextStyle(
                              color: !authCubit.isExistingSelected
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
