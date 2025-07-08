import 'package:chatapp/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class ForgetPasswordWidget extends StatelessWidget {
  final void Function() onTap;
  const ForgetPasswordWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        AppStrings.forgetPassword,
        textAlign: TextAlign.center,
        style: TextStyle(
            // fontFamily: 'WorkSansSemiBold',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.red),
      ),
    );
  }
}
