import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

Future<List<dynamic>> getProvince() async{
  final respone = await http.get(Uri.parse(apiUrlProvince),headers:{
    "Content-Type":"application/json",
  });
  if(respone.statusCode == 200){
    return json.decode(utf8.decode(respone.bodyBytes));
  }else{
    throw Exception("Failed");
  }
}

Future<List<dynamic>> getDistrict(String url) async{
  final respone = await http.get(Uri.parse(url));
   if(respone.statusCode == 200){
    return json.decode(utf8.decode(respone.bodyBytes))['districts'];
  }else{
    throw Exception("Failed");
  }
}
Future<List<dynamic>> getWard(String url) async{
  final respone = await http.get(Uri.parse(url));
   if(respone.statusCode == 200){
    return json.decode(utf8.decode(respone.bodyBytes))['wards'];
  }else{
    throw Exception("Failed");
  }
}

Future<bool> signup(data) async{ 
  final response = await http.post(Uri.parse(signupUrl),body: jsonEncode(data),headers: {
    "Content-Type":"application/json;charset=utf-8"
  });
  print(data);
  print(response.statusCode);
  if(response.statusCode==201){
    return true;
  }else{
    return false;
  }
}

Future<bool> signin(data) async{
  final response = await http.post(Uri.parse(signinUrl),body: jsonEncode(data),headers: {
    "Content-Type":"application/json"
  });
  print(response.statusCode);
  if(response.statusCode==200){
    return true;
  }else{
    return false;
  }
}