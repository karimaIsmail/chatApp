import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class CustomDialogue {
  final BuildContext context;
  final String title;
  final String desc;
  final DialogType dialogType;

  CustomDialogue(this.title, this.desc, this.dialogType, {required this.context});

  void show() {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.topSlide,
      title: title,
      desc: desc,
      btnOkOnPress: () {},

      btnCancelColor: Color.fromARGB(184, 210, 180, 8),
      btnOkColor: Color.fromARGB(197, 121, 73, 194),
    ).show();
  }
}
