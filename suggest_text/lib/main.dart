import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const AutocompleteExampleApp());

class AutocompleteExampleApp extends StatelessWidget {
  const AutocompleteExampleApp({super.key});

  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Autocomplete Basic'),
        ),
        body: const Center(
          child: AutocompleteBasicExample(),
        ),
      ),
    );
  }
}

class AutocompleteBasicExample extends StatefulWidget {
  const AutocompleteBasicExample({super.key});

  @override
  State<AutocompleteBasicExample> createState() => _AutocompleteBasicExampleState();
}

class _AutocompleteBasicExampleState extends State<AutocompleteBasicExample> {
  String url = "https://nominatim.openstreetmap.org/search?q=";
  Future<List<String>> getList(textEditingValue) async {
    List<String> result = [];
    final response = await http.get(Uri.parse(url+textEditingValue+"&format=json&polygon_geojson=1&addressdetails&limit=5"));
    for (var i in json.decode(response.body)){
      result.add(i['display_name']);
    }
    return result;
  }

  List<String> _kOptions = [];

  @override
  void initState() {
    super.initState();
  }

  void getl(textEditingValue) async {
    _kOptions = await getList(textEditingValue);
  }

  
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        setState(() {
          getl(textEditingValue.text);
        });
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.map((e) => e);
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
      },
    );
  }
}


