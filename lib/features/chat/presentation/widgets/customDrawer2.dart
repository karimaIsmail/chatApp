import 'package:chatapp/features/chat/presentation/widgets/current_user_profile_widget.dart';
import 'package:chatapp/features/chat/presentation/widgets/settings_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      // Color.fromARGB(197, 49, 30, 78),
      width: 220.h,
      child: Column(
          children: [UserProfileWidget(), Expanded(child: SettingsWidget())]),
    );
  }
}
