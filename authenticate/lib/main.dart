import 'dart:io';

import 'package:authenticate/data/api/api.dart';
import 'package:authenticate/data/api/config.dart';
import 'package:authenticate/signin.dart';
import 'package:flutter/material.dart';

import 'signup.dart';

void main(){
  HttpOverrides.global = MyHttpOverrides();
  runApp(MaterialApp(home: Home()));
  }

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SignIn();
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}