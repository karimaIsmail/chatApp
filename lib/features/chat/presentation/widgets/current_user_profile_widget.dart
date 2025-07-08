import 'package:chatapp/core/constants/AppImageAssets.dart';
import 'package:chatapp/core/constants/routesNames.dart';
import 'package:chatapp/features/chat/presentation/cubit/currentUser_cubit.dart';
import 'package:chatapp/features/chat/presentation/cubit/currentUser_cubit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CurrentUserCubit()..getCurrentUserInfo(),
      child: BlocConsumer<CurrentUserCubit, CurrentUsertState>(
          listener: (context, state) {
        if (state is EditUserLoading) {
          Get.toNamed(AppRouts.editUPage);
        }
      }, builder: (context, state) {
        return Container(
          height: 180.h,
          padding: EdgeInsets.only(
            top: 40.h,
          ),
          color: Colors.red,
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                  height: 70.h,
                  width: 70.h,
                  child: GestureDetector(
                    onTap: () {
                      context.read<CurrentUserCubit>().updateUser();
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.h),
                        child: Hero(
                          tag: 'userimage',
                          child: state is CurrentUserDataLoaded
                              ? state.user.imagePath!.isNotEmpty
                                  ? Image.network(state.user.imagePath!)
                                  : Image.asset(AppImageAssets.defaultImage)
                              : Image.asset(AppImageAssets.defaultImage),
                        )),
                  )),
              SizedBox(
                height: 15.h,
              ),
              Column(
                children: [
                  Text(
                    // "",
                    state.user.username,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    //'',
                    // "k@gmail.com",
                    state.user.email,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
