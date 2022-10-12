import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Future<void> uploadImage(FormData formdata) async {
  //   var dio = Dio();
  //   final respone = await dio.post('',data: formdata);
  //   if(respone.statusCode==201){
  //     print("Success");
  //   }else{
  //     throw Exception('Failed to upload');
  //   }
  // }

  void uploadSingleFile(File imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri =
        Uri.parse('https://api.cloudinary.com/v1_1/dk4fm09ol/image/upload');
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    request.fields.addAll({'upload_preset': 't2qowjbr'});
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  void uploadMultipleFile(List<File> listFile) async {
    for (var lFile in listFile) {
      var stream = http.ByteStream(DelegatingStream.typed(lFile.openRead()));
      var length = await lFile.length();
      var uri =
          Uri.parse('https://api.cloudinary.com/v1_1/dk4fm09ol/image/upload');
      var request = http.MultipartRequest("POST", uri);
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: basename(lFile.path));
      //contentType: new MediaType('image', 'png'));

      request.files.add(multipartFile);
      request.fields.addAll({'upload_preset': 't2qowjbr'});
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
    listImages ==[];
  }

  bool check = false;
  List<File> listImages = <File>[];

  void getListImage() async {
    final results = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']);
    if (results != null) {
      setState(() {
        listImages.addAll(results.files.map((e) => File(e.path!)));
      });
    }
  }

  File? image;
  void getImage() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']);
    if (result != null) {
      setState(() {
        image = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Demo")),
      body:

          Center(
              child: listImages.isEmpty ?
             ElevatedButton(
                    onPressed: () {
                      getListImage();
                    },
                    child: Text('Get images'))
               : ListView(
                children:
                  [for(var i in listImages)
                    Image.file(File(i.path))]
          )
          )

      //     Center(
      //   child: listImages.isNotEmpty
      //       ? Column(
      //           children: [
      //             for(var i in listImages)
      //                Image.file(i),
      //             ElevatedButton(
      //                 onPressed: () {
      //                   uploadMultipleFile(listImages);
                        
      //                 },
      //                 child: Text('Upload'))
      //           ],
      //         )
      //       : ElevatedButton(
      //           onPressed: () {
      //             getListImage();
                  
      //           },
      //           child: Text("GetImage"),
      //         ),
      // ),
    );
  }
}
