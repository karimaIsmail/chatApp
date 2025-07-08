import 'package:chatapp/core/constants/AppColors.dart';
import 'package:chatapp/features/chat/presentation/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChooseColorWidget extends StatelessWidget {
  final bool toggleColorLst;
  const ChooseColorWidget({super.key, required this.toggleColorLst});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        height: toggleColorLst ? 50.h : 0,
        child: SizedBox(
          height: 100.h,
          
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppColors.colors.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    context.read<SettingsCubit>().chooseColor(i);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.h),
                    width: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: AppColors.colors[i],
                    ),
                  ),
                );
              }),
        ));
  }
}
