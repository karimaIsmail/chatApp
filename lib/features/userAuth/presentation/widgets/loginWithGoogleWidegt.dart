import 'package:chatapp/core/constants/AppImageAssets.dart';
import 'package:chatapp/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class LoginWithGoogleWidget extends StatelessWidget {
  const LoginWithGoogleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
              text: TextSpan(
            text: AppStrings.loginWith,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color.fromARGB(197, 80, 28, 157),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          )),
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
            maxRadius: 16,
            backgroundImage: AssetImage(AppImageAssets.loginWithGoogle),
          )
        ],
      ),
    );
  }
}
