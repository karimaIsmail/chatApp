import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubTitleWidget extends StatelessWidget {
  final String title;
  final Color color;
  final Icon icon;
  final void Function() onPressed;
  const SubTitleWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0.h),
      child: Row(
        children: [
          IconButton(color: color, onPressed: onPressed, icon: icon),
          Text(
            title,
            style: TextStyle(
                color: color, fontSize: 15.h, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
