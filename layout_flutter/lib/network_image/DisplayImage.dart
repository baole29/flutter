import 'package:flutter/material.dart';

class DisplayImage extends StatefulWidget {
  const DisplayImage({Key? key}) : super(key: key);

  @override
  State<DisplayImage> createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 300,
        height: 200,
        child: Image.network('https://res.cloudinary.com/dk4fm09ol/image/upload/v1661392315/cld-sample-5.jpg'),
      )
    );
  }
}