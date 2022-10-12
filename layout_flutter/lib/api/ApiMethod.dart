import 'dart:convert';

import './models/User.dart';
import 'package:http/http.dart' as http;

const url = 'https://jsonplaceholder.typicode.com/albums';
const url2 = "https://reqres.in/api/users?per_page=15";
// get a user
Future<User> fetchUser() async{
  final response = await http.get(Uri.parse("$url/1"));

  if(response.statusCode == 200){
    return User.fromJson(jsonDecode(response.body));
  }else{
    throw Exception('Failed to load user');
  }
}

// get a list user
Future<List<User>> fetchListUser() async{
  final listUser = List<User>.empty(growable: true);
  final response = await http.get(Uri.parse(url));
  final data = jsonDecode(response.body.toString());
  if(response.statusCode == 200){
    for (Map<String, dynamic> user in data){
      listUser.add(User.fromJson(user));
    }
    return listUser;
  }else{
    throw Exception('Failed to load user');
  }
}


Future<List<dynamic>> fetchData() async{
  final response = await http.get(Uri.parse(url2));
  return json.decode(response.body)['data'];
}

