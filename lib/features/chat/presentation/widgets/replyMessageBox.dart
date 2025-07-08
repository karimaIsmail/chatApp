import 'package:chatapp/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReplyMessageBox extends StatefulWidget {
  final String replyOn;
  final String senderName;

  const ReplyMessageBox(
      {super.key, required this.replyOn, required this.senderName});

  @override
  State<ReplyMessageBox> createState() => _ReplyMessageBoxState();
}

class _ReplyMessageBoxState extends State<ReplyMessageBox> {
  late Size _mediaSize;
  Model model = Model();

  @override
  Widget build(BuildContext context) {
    model = Provider.of<Model>(context, listen: false);
    _mediaSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          width: _mediaSize.width * 0.8,
          padding: EdgeInsets.only(left: 18, right: 20, top: 15),
          alignment: Alignment.topLeft,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.symmetric(
                vertical: BorderSide(color: model.MainColor, width: 2)),
            color: Colors.grey[100],
          ),
          child: Text(widget.replyOn),
        ),
        Positioned(
            top: 1,
            right: 6,
            child: Text(
              widget.senderName,
              style: TextStyle(color: model.MainColor, fontSize: 12),
            ))
      ],
    );
  }
}
