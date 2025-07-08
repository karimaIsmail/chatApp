import 'package:chatapp/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ShowPhoto extends StatefulWidget {
  String imagePath;
  ShowPhoto({super.key, required this.imagePath}) {
    // TODO: implement ShowPhoto
    throw UnimplementedError();
  }

  @override
  State<ShowPhoto> createState() => _ShowPhotoState();
}

class _ShowPhotoState extends State<ShowPhoto> {
  late Size _mediaSize;
  Model model = Model();

  @override
  Widget build(BuildContext context) {
    _mediaSize = MediaQuery.of(context).size;
    model = Provider.of<Model>(context, listen: false);

    return Container(
      width: _mediaSize.width * 0.5,
      padding: EdgeInsets.only(left: 50, right: 20, top: 15),
      alignment: Alignment.topLeft,
      height: 100,
      child: Image.network(
        widget.imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
