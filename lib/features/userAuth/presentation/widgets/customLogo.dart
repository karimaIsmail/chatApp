// ignore: file_names
import 'package:chatapp/core/constants/AppImageAssets.dart';
import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 250,
        alignment: Alignment.center,
        decoration: BoxDecoration(),
        child: Image.asset(
          AppImageAssets.logo,
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
