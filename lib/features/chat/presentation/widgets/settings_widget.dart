import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chatapp/core/constants/AppColors.dart';
import 'package:chatapp/core/constants/app_strings.dart';
import 'package:chatapp/core/constants/routesNames.dart';
import 'package:chatapp/features/chat/domain/entities/settings_entity.dart';
import 'package:chatapp/features/chat/presentation/cubit/settings_cubit.dart';
import 'package:chatapp/features/chat/presentation/cubit/settings_state.dart';
import 'package:chatapp/features/chat/presentation/widgets/choose_color_widget.dart';
import 'package:chatapp/features/chat/presentation/widgets/choose_language_widget.dart';
import 'package:chatapp/features/chat/presentation/widgets/customSeprator.dart';
import 'package:chatapp/features/chat/presentation/widgets/sign_out_widget.dart';
import 'package:chatapp/features/chat/presentation/widgets/subTitleWidget.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/customDialouge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SignOutSucessState) {
          Get.offNamedUntil(AppRouts.signupLoginPage, (route) => false);
        }
        if (state is SignOutFailureState) {
          CustomDialogue(AppStrings.error, state.settings.errorMessage,
                  DialogType.error,
                  context: context)
              .show();
        }
      },
      builder: (context, state) {
        SettingsEntity settings = state.settings;
        return Column(
          children: [
            SubTitleWidget(
              title: "settings".tr,
              icon: Icon(
                Icons.settings,
              ),
              color: AppColors.colors[settings.colorsIndex],
              onPressed: context.read<SettingsCubit>().toggleSettings,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              height: settings.toggleSettings ? 400.h : 0,
              child: ListView(
                children: [
                  SubTitleWidget(
                    title: "5".tr,
                    icon: Icon(
                      Icons.color_lens,
                    ),
                    color: AppColors.colors[settings.colorsIndex],
                    onPressed: context.read<SettingsCubit>().toggleColors,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.h),
                    child: ChooseColorWidget(
                      toggleColorLst: state.settings.toggleColors,
                    ),
                  ),
                  CustomSeparator(
                    color: AppColors.colors[settings.colorsIndex],
                  ),
                  SubTitleWidget(
                    title: "12".tr,
                    icon: Icon(
                      Icons.language,
                    ),
                    color: AppColors.colors[settings.colorsIndex],
                    onPressed: context.read<SettingsCubit>().toggleLanguage,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  ChooseLanguageWidget(
                    color: AppColors.colors[settings.colorsIndex],
                    showLanguageList: settings.toggleLanguage,
                    language: settings.language,
                  ),
                  CustomSeparator(
                    color: AppColors.colors[state.settings.colorsIndex],
                  ),
                ],
              ),
            ),
            SignOutWidget(
              color: AppColors.colors[state.settings.colorsIndex],
              onTap: context.read<SettingsCubit>().signOut,
            ),
          ],
        );
      },
    );
  }
}
