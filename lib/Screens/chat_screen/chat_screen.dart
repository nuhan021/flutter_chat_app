import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/cubits/chat_cubit/chat_cubit.dart';

class ChatScreen extends StatelessWidget {
  final String receiverName;
  final String receiverUserId;
  final String receiverUserImageLink;
  final int maxLines = 3;
  String alterNativeImageUrl = 'https://firebasestorage.googleapis.com/v0/b/test-241a5.appspot.com/o/alternativeImage%2Fuser.png?alt=media&token=8f1d43c8-2b6b-4a42-b460-29aa27b434a2&_gl=1*1lrdonr*_ga*NzM2NjI2Mjc0LjE2OTgxNDYyNzc.*_ga_CW55HF8NVT*MTY5ODc3ODM0NC4zMC4xLjE2OTg3Nzg2MzIuNS4wLjA.';
  TextEditingController messageController = TextEditingController();

  ChatScreen(
      {super.key,
      required this.receiverName,
      required this.receiverUserId, required this.receiverUserImageLink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.deepPurple[200],
                backgroundImage: (receiverUserImageLink != '') ? NetworkImage(receiverUserImageLink) : NetworkImage(alterNativeImageUrl),
                radius: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  receiverName.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.call_outlined)),
            IconButton(onPressed: () {}, icon: Icon(Icons.videocam_outlined)),
            SizedBox(
              width: 12,
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: StreamBuilder<List<QueryDocumentSnapshot>>(
                    stream: BlocProvider.of<ChatCubit>(context)
                        .getMessagesStream(
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            otherUserId: receiverUserId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<QueryDocumentSnapshot> fatchMessages =
                            snapshot.data ?? [];
                        var messages = List.from(fatchMessages.reversed);
                        return ListView.separated(
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            String message =
                                messages[index]['message'].toString();
                            Alignment alignment =
                                (messages[index]['senderId'].toString() !=
                                        FirebaseAuth.instance.currentUser?.uid
                                            .toString())
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight;
                            Color bubbleColor =
                                (messages[index]['senderId'].toString() !=
                                        FirebaseAuth.instance.currentUser?.uid
                                            .toString())
                                    ? Colors.purple.shade200
                                    : Colors.pinkAccent;
                            Color textBubbleColor =
                                (messages[index]['senderId'].toString() !=
                                        FirebaseAuth.instance.currentUser?.uid
                                            .toString())
                                    ? Colors.black
                                    : Colors.white;
                            return Container(
                                width: double.infinity,
                                alignment: alignment,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: bubbleColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: Text(
                                      message,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: textBubbleColor),
                                    ),
                                  ),
                                ));
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                        );
                      }
                    },
                  ),
                )),
            Expanded(
                child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.deepPurple,
                      size: 40,
                    ),
                  ),
                ),
                Expanded(
                    flex: 9,
                    child: TextField(
                      onChanged: (text) {
                        final lines = text.split('\n').length;
                        if (lines > maxLines) {
                          final textLines = text.split('\n');
                          textLines.removeLast();
                          messageController.text = textLines.join('\n');
                        }
                      },
                      maxLines: null,
                      style: TextStyle(color: Colors.grey[900]),
                      controller: messageController,
                      cursorColor: Colors.grey[900],
                      decoration: InputDecoration(
                          hintText: 'Type here',
                          hintStyle: TextStyle(color: Colors.grey[900]),
                          fillColor: Colors.deepPurple.withOpacity(0.3),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 2),
                            borderRadius: BorderRadius.circular(30),
                          )),
                    )),
                IconButton(
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      BlocProvider.of<ChatCubit>(context).sendMessage(
                          receiverId: receiverUserId,
                          message: messageController.text);
                      messageController.clear();
                    }
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.deepPurple,
                    size: 30,
                  ),
                )
              ],
            ))
          ],
        ));
  }
}
