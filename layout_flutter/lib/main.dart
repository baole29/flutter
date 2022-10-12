import 'package:flutter/material.dart';

import 'api/DisplayData.dart';
import 'login/LoginLayout.dart';
import 'network_image/DisplayImage.dart';

void main()=> runApp(MaterialApp(home: Home()));



class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DisplayImage();
  }
}