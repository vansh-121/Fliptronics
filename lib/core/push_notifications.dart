import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // print("Title : ${message.notification?.title}");
  // print("Body : ${message.notification?.body}");
  // print("Payload : ${message.data}");
}

class PushNotifications {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("Token : $fCMToken");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> getFirebaseInstallationID() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? fid = await messaging.getToken();
    print('Firebase Installation ID: $fid');
  }
}
