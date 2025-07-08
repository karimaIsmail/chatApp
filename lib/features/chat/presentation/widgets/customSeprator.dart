import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSeparator extends StatelessWidget {
  final Color color;
  const CustomSeparator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0.h),
        child: Divider(
          color: color,
          thickness: 1,
        ),
      ),
    );
  }
}
