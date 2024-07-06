import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

void manageNotification() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  // final fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: "BKagOny0KF_2pCJQ3m....moL0ewzQ8rZu");
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //IOS
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification}');
    }
  });
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  log("FCM: $fcmToken");

}
