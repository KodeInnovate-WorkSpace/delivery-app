import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings = InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    try {
      print("In Notification method");
      // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
      Random random = Random();
      int id = random.nextInt(1000);
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "mychannel",
        "my chanel",
        importance: Importance.max,
        priority: Priority.high,
      ));
      print("my id is ${id.toString()}");
      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.title,
        notificationDetails,
      );
    } on Exception catch (e) {
      print('Error>>>$e');
    }
  }

  // "id_token" -> "eyJhbGciOiJSUzI1NiIsImtpZCI6IjBlMzQ1ZmQ3ZTRhOTcyNzFkZmZhOTkxZjVhODkzY2QxNmI4ZTA4MjciLCJ0eXAiOiJKV1Qi..."
  var serviceAccountJson = {
    "type": "service_account",
    "project_id": "speedy-57c76",
    "private_key_id": "e2d2c43e640ee292ed5e75369599256c5bd1330d",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCpx34hNnK9C94A\nIJVYrDpDKNJ+zgafEFCZPyBJlF5Vl+G9Tan5OMTIOwcnlDrNnLfX22clGJ8mdN/w\nIuPAmZT13GxZCiLvfftSIoL04zVi/wamV5/u0MMGDAunnNSGDodKEfqUCKtBqTnd\ntg1njoQ4GCc1/Ab9hErZvM+keNw/swFEsXzFmWnlm2HEZeUNh9s/uGEsh9KBO6fS\nhoyoEcr4GphzUNbE3xPrtRqVRacvtN9teDJvJOvSRnCV2uMF5EEOYNm7A8I13Fah\nWUh3PPIWbD2ukNvLeb57PwAhc0Mx3ws7OGpTDbuV54EThno8d42TJ9LhLq9r+qbV\nWDgB2pnXAgMBAAECggEAMcfco8BjRCsGnOLw518Ydjix/5xJNLqD52sq/GgUgORX\nvDnZbMnIaS1lm6VK2J7rCM+8HpRplc0PHEoenYpqsuw+mJzwQWifGCYmX8d/D9fX\nC08GBfAQPuWpRSwm5Ge+I2nCH0WrcUU9QlTu+T5AZnIujRWotwzjJZTHDWKiscpA\nguImaDzlwJE4ysPxa1IKDmXME9rSRTh4KYsA6fCFL5jgkM8/lXmO4Qq/x3cCv3fq\n66ZqIozzBvVX0TD12t4q91In6QFcHVTrDhyeaJjr/vgq7eUy7QUNuLgwIlaJG0LK\nKXYYvcRNIa+G5+LzlEZh+6hlZdS3IPLaKW37PkfWAQKBgQDRJSgaXJtLe2OA9H73\nQlA1qBgRAKuRsjR6bcAEHdiWRngFhTOdyWyhZoNQekb/tImctPLLexyT8KGz9Lk9\nKcGaCoLyipLqIQB5cUCe85Ru875t5oGzxa5amCzqZ8F1yizBWh5i3pyeia470MSy\naRqoKxe/TOM2YnJsuvA1G5OfkQKBgQDP0KIzKhFUYIiKHHfs83UtXdzsSS8W0QQ6\nXo1EsMkY+2mowZEsjmcXkyJua0OUoxmkuZGwKM0C/k7Z9TYEV+zcBItsDLhla9AH\nWjLtOnK8XoUuIPGEShx1m8xD1wVriuv7Rljhdi++HRuHBvEpWswUfJnC0R9j2/87\npQ/qb7i+5wKBgQC05jyvwJYaTdmdOt1vJQ6XupNGcZv043z8wF0rsl0abk12CObC\nfezWFgNS4tDyb8fvoZu4YP4xABv9uZlXy/xHLvxgqXe1x2HPqSPJ2Mn0xiNaj9x0\nEHJkred7wM7XAU6A12AdCIvTnSb1WfgokTybZNqffvOwoKp0XaVTakzf4QKBgA/n\nADJ4GqFhTbF74jVwn9vb3eb65q6RSgiJabgC6zCNNJWkUk6diwgDy1O1w5MhM/ol\n9R8M0DtVaIVHPV3xuH9RnbWj94xTRrT5UwJSQatmdDyGatTbsvfQ9z2Nu61yEQLG\nbFC8cYTTx2J6xoOKnilHK6D7zbIfiJVw2RnweKurAoGAG8zEHJb56tsM5UaftMyU\nTw12eST1/xdjROYFlRsqJAaotBybynysNvIyp8Ih5GX17LWFlrDKyPpfI2lI4vtM\np0epMBA2DXtGK28HLEQEO7UXBVZIboPSn/wJbpDU/N7LNquLurzvdzcBdHX77DQx\nzOGFc624nhWvAawI/i69atk=\n-----END PRIVATE KEY-----\n",
    "client_email": "delivoapp-847@speedy-57c76.iam.gserviceaccount.com",
    "client_id": "110689282638149192819",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/delivoapp-847%40speedy-57c76.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };
  List<String> scopes = [
    "https://www.googleapis.com/auth/userinfo.email"
        "https://www.googleapis.com/auth/firebase.database"
        "https://www.googleapis.com/auth/firebase.messaging"
  ];
  Future<auth.AccessCredentials> getAccessToken() async {
    var accountCredentials = ServiceAccountCredentials.fromJson(serviceAccountJson);

    return await auth.obtainAccessCredentialsViaServiceAccount(
      accountCredentials,
      scopes,
      http.Client(),
    );
  }

  Future<bool> sendNotificationToSelectedAdmin({required String title, required String body, required String token}) async {
    var accessCredentials = await getAccessToken();

    var payload = {
      'message': {
        'token': token,
        'notification': {
          'title': "you received new order",
          'body': "you received new order",
        },
        'android': {
          'priority': 'high',
        },
        'apns': {
          'headers': {'a[ns-'}
        },
        'payload': {
          'aps': {
            'sound': 'default',
          }
        }
      }
    };

    var response = await http.post(
      Uri.parse("https://fcm.googleapis.com/v1/projects/speedy-57c76/messages:send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorizatoin': "Bearer ${accessCredentials.accessToken.data}",
      },
      body: jsonEncode(payload),
    );

    debugPrint(response.body.toString());

    if (response.statusCode == 200) {
      print('Notification sent successfully');
      return true;
    } else {
      print('Failed: ${response.statusCode}');
      return false;
    }
  }

// static Future<String> getAccessToken() async {
//   // final serviceAccountJson = "C:/Users/Farid/Desktop/speedy-57c76-firebase-adminsdk-i37c3-8bb561d912.json";
//   List<String> scopes = [
//     "https://www.googleapis.com/auth/userinfo.email"
//         "https://www.googleapis.com/auth/firebase.database"
//         "https://www.googleapis.com/auth/firebase.messaging"
//   ];
//
//   http.Client client = await auth.clientViaServiceAccount(
//     auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//     scopes,
//   );
//
//   //get the access token
//   auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes, client);
//
//   client.close();
//   return credentials.accessToken.data;
// }

  // static sendNotificationToSelectedAdmin(String deviceToken, BuildContext context, String orderId) async {
  //   final String serverKey = await getAccessToken();
  //   String endpointFirebaseCloudMessaging = 'https://fcm.googleapis.com/v1/projects/speedy-57c76/messages:send';
  //
  //   final Map<String, dynamic> message = {
  //     'message': {
  //       'token': deviceToken,
  //       'notification': {
  //         'title': "you received new order",
  //         'body': "you received new order",
  //       },
  //       'data': {
  //         'orderId': orderId,
  //       }
  //     }
  //   };
  //
  //   final http.Response response = await http.post(
  //     Uri.parse(endpointFirebaseCloudMessaging),
  //     headers: <String, String>{'content-Type': 'application/json', 'Authorization': 'Bearer $serverKey'},
  //     body: jsonEncode(message),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('Notification sent successfully');
  //   } else {
  //     print('Failed: ${response.statusCode}');
  //   }
  // }
}
