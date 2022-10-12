import 'package:authenticate/data/api/api.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool hide = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: usernameController
          ),
          TextFormField(
            obscureText: hide,
            controller: passwordController,
            decoration: InputDecoration(
              hintText: "Enter password",
              suffix: IconButton(icon: Icon(Icons.remove_red_eye),onPressed: (){
                setState(() {
                  hide = !hide;
                });
              },)
            ),
          ),
          ElevatedButton(onPressed: () async{
            Map<String,dynamic> data = {"username":usernameController.text,"password":passwordController.text};
            bool check = await signin(data);
            check?print("ok"):print("failed");
          }, child: Text("Login"))
        ],
      ),
    );
  }
}