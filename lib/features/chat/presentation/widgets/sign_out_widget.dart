import 'package:chatapp/core/constants/routesNames.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignOutWidget extends StatelessWidget {
  final void Function() onTap;
  final Color color;
  const SignOutWidget({super.key, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              Icons.exit_to_app,
              color: color,
            ),
            //),
            Text(
              '6'.tr,
              style: TextStyle(
                  color: color, fontSize: 15.w, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
