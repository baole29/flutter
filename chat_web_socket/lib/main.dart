// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// import 'test.dart';

// void main() => runApp( const Chat());

// class Chat extends StatelessWidget {
//   const Chat({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const title = 'WebSocket Demo';
//     return const MaterialApp(
//       title: title,
//       home: MyHomePage(
//         title: title,
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     super.key,
//     required this.title,
//   });

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   // final idMe = 1;
//   // final idDes = 2;
//   final idMe = 2;
//   final idDes = 1;
//   final TextEditingController _controller = TextEditingController();
//   final _channel = WebSocketChannel.connect(
//     Uri.parse('ws://10.32.61.13:8080/chat',
//     ),
//   );
//   Future? dataFuture;

//   List list = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             const SizedBox(height: 24),
//             StreamBuilder(
//               stream: _channel.stream,
//               builder: (context, snapshot) {
//                 if(snapshot.hasData){
//                   var data = jsonDecode(snapshot.data.toString());
//                   list.add(data);
//                   return SizedBox(
//                     height: 200,
//                     child: ListView(
//                       reverse: true,
//                       children: [
//                         for(var i in list)
//                           Row(
//                             mainAxisAlignment: i['id']==1?MainAxisAlignment.end:MainAxisAlignment.start,
//                             children: [
//                               Text(i['content']),
//                             ],
//                           )
//                       ],
//                     ),
//                   );
//                 }
//                 return const Text("");
//               },
//             ),

//              Form(
//               child: TextFormField(
//                 controller: _controller,
//                 decoration: const InputDecoration(labelText: 'Send a message'),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _sendMessage,
//         tooltip: 'Send message',
//         child: const Icon(Icons.send),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }

//   void _sendMessage() {
//     Map data = {"idDes": 1,"idMe":2 ,"content":_controller.text};
//     if (_controller.text.isNotEmpty) {
//       _channel.sink.add(jsonEncode(data));
//     }

//   }

//   @override
//   void dispose() {
//     _channel.sink.close();
//     _controller.dispose();
//     super.dispose();
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stompClient.activate();
  }

  final _controller = TextEditingController();
  List listChat = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        StreamBuilder(
            stream: stream,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                listChat.add(snapshot.data);
              }
              return SizedBox(
                height: 400,
                width: 200,
                child: ListView(
                
                  children: [
                    for (var chat in listChat)
                      Row(
                        mainAxisAlignment: chat['id'] == senderId
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          chat['id'] == senderId
                              ? Container(child: Text(chat['name'].toString()),color: Colors.blue,)
                              : Container(child: Text(chat['name'].toString()),color: Colors.white70,)
                        ],
                      )
                  ],
                ),
              );
            })),
        SizedBox(
          child: Row(
            children: [
              Form(
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: 'Send a message'),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    _sendMessage(_controller.text);
                  },
                  child: Icon(Icons.send_outlined)),
            ],
          ),
        ),
      ]),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Chat(),
  ));
}

final int senderId = 2;
final int receiverId = 1;
StreamController<dynamic> controller = StreamController<dynamic>();
Stream stream = controller.stream;

final stompClient = StompClient(
  config: StompConfig(
    url: 'ws://10.32.61.13:8080/chat',
    onConnect: onConnect,
    beforeConnect: () async {
      print('waiting to connect...');
      await Future.delayed(Duration(milliseconds: 200));
      print('connecting...');
    },
    //onWebSocketError: (dynamic error) => print(error.toString()),
    // stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
    // webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
  ),
);
void _sendMessage(String message) {
  Map data = {'name': message, 'id': senderId, 'reId': receiverId};
  stompClient.send(
    destination: '/app/message/${senderId}/${receiverId}',
    body: json.encode(data),
  );
}

void onConnect(StompFrame frame) {
  // print(stompClient.connected);
  stompClient.subscribe(
    destination: '/queue/reply/${senderId}',
    callback: (frame) {
      controller.add(jsonDecode(frame.body.toString()));
      print(frame.body);
    },
  );
  stompClient.subscribe(
    destination: '/queue/reply/${receiverId}',
    callback: (frame) {
      controller.add(jsonDecode(frame.body.toString()));
      print(frame.body);
    },
  );

  // Timer.periodic(Duration(seconds: 5), (_) {
  //   stompClient.send(
  //     destination: '/app/message',
  //     body: json.encode({'name': 123}),
  //   );
  // });
}
