import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/cubits/chat_cubit/chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:full_chat_app/model/message_model.dart';
import 'package:http/http.dart';

class ChatCubit extends Cubit<ChatState> {
  //todo __ get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatCubit() : super(ChatInitialState());

  //todo __ SEND MESSAGE
  Future<void> sendMessage(
      {required String receiverId, required String message}) async {
    //todo __ get current user information
    final String currentUserId = _firebaseAuth.currentUser!.uid.toString();
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //todo __ create new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);

    //todo __ create chat room unique id using sender and receiver userId
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    //todo __ add receiver id to the current users chatList array
    DocumentSnapshot<Map<String, dynamic>> currentUsersnapshot =
        await _firestore.collection('users').doc(currentUserId).get();
    Map<String, dynamic> currentUserData =
        currentUsersnapshot.data() as Map<String, dynamic>;
    List currentUserchatList = currentUserData['chatList'];
    if (currentUsersnapshot.exists) {
      if (!currentUserchatList.contains(receiverId)) {
        // currentUserchatList.add(receiverId.toString());
        currentUserchatList.insert(0, receiverId);
        await _firestore
            .collection('users')
            .doc(currentUserId)
            .update({'chatList': currentUserchatList});
      } else {
        int indexOfReceiverId = currentUserchatList.indexOf(receiverId);

        if (indexOfReceiverId != 0) {
          currentUserchatList.removeAt(indexOfReceiverId);
          currentUserchatList.insert(0, receiverId);
          await _firestore
              .collection('users')
              .doc(currentUserId)
              .update({'chatList': currentUserchatList});
        }
      }
    }

    // todo __ add current user id to the receiver user chatList array
    DocumentSnapshot<Map<String, dynamic>> receiverUserSnapshot =
        await _firestore.collection('users').doc(receiverId).get();
    Map<String, dynamic> receiveruserData =
        receiverUserSnapshot.data() as Map<String, dynamic>;
    List receiverUserChatList = receiveruserData['chatList'];
    if (receiverUserSnapshot.exists) {
      if (!receiverUserChatList.contains(currentUserId)) {
        receiverUserChatList.insert(0, currentUserId);
        await _firestore
            .collection('users')
            .doc(receiverId)
            .update({'chatList': receiverUserChatList});
      } else {
        int indexOfCurrentUserId = receiverUserChatList.indexOf(currentUserId);
        if (indexOfCurrentUserId != 0) {
          receiverUserChatList.removeAt(indexOfCurrentUserId);
          receiverUserChatList.insert(0, currentUserId);
          await _firestore
              .collection('users')
              .doc(receiverId)
              .update({'chatList': receiverUserChatList});
        }
      }
    }

    //todo __ add new message to the database
    DocumentReference reference = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

      sendMessageNotification();
    if (reference != null) {
    }
  }

  //todo __ GET MESSAGES
  Stream<List<QueryDocumentSnapshot>> getMessagesStream({
    required String userId,
    required String otherUserId,
  }) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  //todo __ send push notification
  Future<void> sendMessageNotification() async {
    final response = await post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: {
        'Authorization': "Bearer AAAAEneoROM:APA91bFKUweZvAidSKEv4D7KikEBFKhf8GwwQx5DIGsGzzVg2s1J_YvGLsoTFKRT_0BX-bvpWegGvU6kL6nxEeXluqcEOf2C4fOMC_IZqlp1IEb3zNUQ26m5OtzT8zZbmoP0MRPM2EAP",
      },
      body: jsonEncode({
        "to": "cVWSU9OUTMC9GKTcayLC4i:APA91bES55jHrfnCJPijoD8g9KIRPJSqpj2o1HgF6ESaY1p2i-0oHapsDeA5N7WdSv73apxG6tzL98tdI-t1p8U3ZbrR0JhiHHu8hpdlISHPiW8vi68uCYp52EHuJjh7ynsBz3NxwIrq",
        "notification": {
          "title": "Hello Flutter",
          "body": "Hey Nuhan chowdhury"
        },
        "data": {
          "userId": "some_user_id",
          "senderName": "Nuhan Chowdhury"
        }
      })
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send notification: ${response.statusCode}');
    }
  }
}
