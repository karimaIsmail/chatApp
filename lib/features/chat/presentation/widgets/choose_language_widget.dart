import 'package:chatapp/core/localization/localController.dart';
import 'package:chatapp/features/chat/domain/entities/settings_entity.dart';
import 'package:chatapp/features/chat/presentation/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChooseLanguageWidget extends StatelessWidget {
  final Color color;
  final bool showLanguageList;
  final enLanguage language;
  ChooseLanguageWidget(
      {super.key,
      required this.color,
      required this.language,
      required this.showLanguageList});
  final MylocalController mylocalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      height: showLanguageList ? 130.h : 0,
      //   color: const Color.fromARGB(255, 250, 64, 126),

      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          RadioListTile<enLanguage>(
            activeColor: color,
            onChanged: (val) {
              context.read<SettingsCubit>().chooseLanguage(val!);

              mylocalController.changeLanguage("ar");
            },
            groupValue: language,
            title: Text(
              '21'.tr,
              style: TextStyle(
                  color: color, fontSize: 15.w, fontWeight: FontWeight.w600),
            ),
            value: enLanguage.arabic,
          ),
          RadioListTile<enLanguage>(
            activeColor: color,
            onChanged: (val) {
              context.read<SettingsCubit>().chooseLanguage(val!);

              mylocalController.changeLanguage("en");
            },
            groupValue: language,
            title: Text(
              '22'.tr,
              style: TextStyle(
                  color: color, fontSize: 15.w, fontWeight: FontWeight.w600),
            ),
            value: enLanguage.english,
          ),
        ],
      ),
    );
  }
}
