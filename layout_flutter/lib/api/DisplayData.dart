import 'package:flutter/material.dart';
import 'package:my_layout/api/models/User.dart';

import 'ApiMethod.dart';

class DisplayData extends StatefulWidget {
  const DisplayData({Key? key}) : super(key: key);

  @override
  State<DisplayData> createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  late Future<User> futureUser;
  late Future<List<User>>? futureListUser;
  late Future<List<dynamic>> futureDynamic;

  @override
  void initState() {
    super.initState();
    //futureUser = fetchUser();
    futureDynamic = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  fetchListUser();
                },
                child: Text("Submmit")),
            // Display a User

            // FutureBuilder<User>(
            //   future: futureUser,
            //   builder: ((context, snapshot) {
            //     if(snapshot.hasData){
            //       return Text(snapshot.data!.title);
            //     }else if(snapshot.hasError){
            //       return Text('${snapshot.error}');
            //     }
            //     return CircularProgressIndicator();
            //   }),
            // ),

            // Display a list User

            // FutureBuilder<List<User>>(
            //   future: futureListUser,
            //   builder: ( (context, snapshot) {
            //     if(snapshot.hasData){
            //       return SizedBox(
            //         width: 300,
            //         height: 100,
            //         child: ListView.builder(
            //           itemCount: snapshot.data!.length,
            //           itemBuilder: (context, index){
            //             return Text(snapshot.data![index].title);
            //           },
            //         ),
            //       );
            //     }else if(snapshot.hasError){
            //       return Text('${snapshot.error}');
            //     }

            //     return CircularProgressIndicator();
            //   })

            //   ),

            // Display a list User have image
            FutureBuilder<List<dynamic>>(
                future: futureDynamic,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: 300,
                      height: 600,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListItem(
                            email: snapshot.data![index]['email'],
                            firstName: snapshot.data![index]['first_name'],
                            imageUrl: snapshot.data![index]['avatar'],
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return CircularProgressIndicator();
                })),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String? email;
  final String? firstName;
  final String? imageUrl;
  const ListItem({Key? key, this.email, this.firstName, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(imageUrl!),
        Column(
          children: [Text(email!), Text(firstName!)],
        )
      ],
    );
  }
}
