import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data.toString()}");
  print('senderName: ${message.data['senderName'].toString()}');
}

class FirebaseApi {
  final _firebaseNotification = FirebaseMessaging.instance;

  Future<void> firebaseNotifications () async {
    await _firebaseNotification.requestPermission();
    final deviceAndappIdentifireToken = await _firebaseNotification.getToken();
    print("Token:- ${deviceAndappIdentifireToken}");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}