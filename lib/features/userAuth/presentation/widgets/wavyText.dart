import 'package:chatapp/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WavyText extends StatefulWidget {
  final String text;

  const WavyText({super.key, required this.text});

  @override
  _WavyTextState createState() => _WavyTextState();
}

class _WavyTextState extends State<WavyText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animations = List.generate(widget.text.length, (index) {
      return Tween<double>(begin: 0, end: -20).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index / widget.text.length,
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
  }

  Model model = Model();

  @override
  Widget build(BuildContext context) {
    model = Provider.of<Model>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.text.characters.toList().asMap().entries.map((entry) {
        int index = entry.key;
        String char = entry.value;
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[index].value),
              child: Text(
                char,
                style: TextStyle(
                    fontSize: 30,
                    color: model.MainColor,
                    fontWeight: FontWeight.w600),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
