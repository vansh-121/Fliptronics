import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.cardColor,
        appBar: AppBar(
          title: Text("Current Users"),
          centerTitle: true,
        ),
        body: Column(children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("user_info")
                  .snapshots(),
              builder: (context, profile) {
                if (profile.connectionState == ConnectionState.active) {
                  if (profile.hasData) {
                    return ListView.builder(
                      itemCount: profile.data?.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text("${index + 1}"),
                          ),
                          title: Text("${profile.data!.docs[index]["Name"]}", style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),),
                          subtitle:
                              Text("${profile.data!.docs[index]["Email"]}"),
                        );
                      },
                    );
                  } else if (profile.hasError) {
                    return Center(
                      child: Text("Error: ${profile.error}"),
                    );
                  } else {
                    return Center(
                      child: Text("No Data found!"),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ]));
  }
}
