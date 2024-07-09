// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   void initialize(BuildContext context) {
//     _firebaseMessaging.requestPermission();
//
//     const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//
//     _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       // onSelectNotification: (String? payload) async {
//       //   if (payload != null) {
//       //     Navigator.of(context).pushNamed(payload);
//       //   }
//       // },
//     );
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showNotification(message.notification?.title, message.notification?.body);
//     });
//   }
//
//   Future<void> _showNotification(String? title, String? body) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: 'order_screen',
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold();
//   }
// }
