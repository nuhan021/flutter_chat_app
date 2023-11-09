import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Users extends StatelessWidget {
  final List<dynamic> chatList;
  final String alternativeImage;
  const Users({super.key, required this.chatList, required this.alternativeImage});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: chatList.length,
      separatorBuilder: (context, index) => SizedBox(height: 10,),
      itemBuilder: (context, index) {
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(chatList[index].toString()).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData) {
              return Text("No data available"); // Handle the case where the document doesn't exist.
            }
            Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/chat', arguments: {
                  "receiverName": "${userData['firstName'].toString()} ${userData['lastName'].toString()}",
                  "receiverUserId" : userData['uId'],
                  "receiverUserImageLink" : userData['profileUrl']
                });
              },
              contentPadding: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              tileColor: Colors.deepPurple[200],
              leading: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Makes the Container circular
                  border: Border.all(
                    color: Colors.deepPurple, // Set the border color
                    width: 2.0,          // Set the border width
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple[300],
                  backgroundImage: (userData['profileUrl'] != '') ? NetworkImage(userData['profileUrl'].toString()): NetworkImage(alternativeImage),
                  radius: 25,
                ),
              ),
              title: Text("${userData['firstName'].toString()} ${userData['lastName'].toString()}", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text(userData['email'].toString()),
            );
          },
        );
      },
    );
  }
}


