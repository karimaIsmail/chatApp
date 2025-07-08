import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  const Custombutton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 50,
        right: 50,
        bottom: -15,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(197, 121, 73, 194),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(-2, -2),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  BoxShadow(
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: Offset(5, 5),
                      color: Colors.black.withOpacity(0.3))
                ]),
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                text,
                // "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )));
  }
}
