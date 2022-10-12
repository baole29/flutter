import 'package:flutter/material.dart';

class TextCustom extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? size;
  const TextCustom({Key? key, required this.text, this.color, this.fontWeight, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: size
      ),

    );
  }
}