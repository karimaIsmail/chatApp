import 'package:flutter/material.dart';

class CustomTextformField extends StatefulWidget {
  final String text;
  final bool obscureText;
  final Icon prefexIcon;
  final IconButton? suffixIcon;
  final TextInputType keyBordType;
  final TextEditingController controller;
  final String? Function(String?) validator;
  const CustomTextformField(
      {super.key,
      required this.text,
      required this.controller,
      required this.validator,
      required this.prefexIcon,
      this.suffixIcon,
      required this.keyBordType,
      required this.obscureText});

  @override
  State<CustomTextformField> createState() => _CustomTextformFieldState();
}

class _CustomTextformFieldState extends State<CustomTextformField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText,
      // autovalidateMode: AutovalidateMode.always,
      keyboardType: widget.keyBordType,
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
       
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.prefexIcon,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        hintText: widget.text,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}
