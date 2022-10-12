import 'package:flutter/material.dart';
import 'package:my_layout/theme/TextCustom.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset('assets/images/cream.jpg', fit: BoxFit.contain,width: 100,height: 200,),
          const TextCustom(text: "Welcome Back", color: Colors.blue, size: 24,fontWeight: FontWeight.bold,),
          TextCustom(text: 'Sign to continue'),
          TextFieldItem(hintText: "Enter your email", icon: Icon(Icons.email), label:"Email"),
          TextFieldItem(hintText: "Enter your password", icon: Icon(Icons.lock), label:"Password"),

          // Button login 
          SizedBox(
            height: 40,
          ),
          Container(
            width: 300,
            height: 40,
            child: ElevatedButton(child: Text("Login"),onPressed: (){},)
          )

        ],
      ),
    );
  }
}


class TextFieldItem extends StatelessWidget {
  final String label;
  final String hintText;
  final Icon icon;
  const TextFieldItem({Key? key, required this.hintText, required this.icon, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        label: Text(label),
        prefixIcon: icon
      ),
    );
  }
}