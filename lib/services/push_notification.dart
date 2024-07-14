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
    "private_key_id": "466d3662b73a06b064497a6a6f1012d6022cc67e",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDaW06ZSk0lPDnS\n0nP+d3XqPvF69S/hPqN0DVPrk50oje2BS24h+EVgY9q8wFpfuObCqylkaEpB4mYx\nqdbrRdp13ZSRlsx3oLctMPLhdiHHwGBfUBYY2zvodGbAMD+PsdfEdL9w/HrnAMp0\nzUrRwqYi7gT8Sox7EApBvzTimtD0spg8nTQVdQCn2LGCQ1nfAQSXkfj7w77UEAo0\nd4S3oIE45+tzqSRtP5RlptIFlNXJ+0xDOJG75dn0BNKN86J6HadfxHiJzii8Elu0\ncKfPKZc+DZ1KZGyBCga34W5fVlIQSTNLeeLMERUwz1gjyznPqf8HDUnEDY4//2Ah\n55E8/DdzAgMBAAECggEAOi9dfOR7NSJcyCxTQ2oiziYyo9ClDxDpblnE1H/zv2Q+\ndxcaBExLdFl3ZpedHWfAefwxHfPaYb8J+07mGbB1+7VtSvRTjMcTOKQT/HdFnhxJ\nsew9zybQSmuGG81fipNZyxxPDTUCLP8dc81mlAmZyrIBOxdEYuCN0yI33fBiIOne\nNCTwsMBUuIhJbZvF5IoCfzwj0/LuSVZS/EPLXfVI/3/ETa6M+/SC8h2u7aXLqw9Q\ncK84lRin/Q1Ozx4GOahfGbnT+d8l8ZgCByXjd928GEWN2EXJZjeLc7Hno69W4L50\nzKofcR+yCW32JPTPAYiFhidkaYE6vY3VZDxdhPIZxQKBgQDyGRsREfxGlDMKlFC2\nxEE+6ebJ6stCoiqyE6hEBmQcl3LrLR3VtDJoJhD3AKCrEl2beQnI4a7EPk3Z07u2\nRVt7+X1We+SqXADPuYSY0rx1ou8RcJtaEFe/B4DqFUzpe6z193BGb3IpEhatHUj8\nNDFU1fij9AcXwm6DM4c8nhEl5wKBgQDm5TKRwNaPerGE6/sDyqkJCnlGn0rheJSl\n88eoRwkWMzlEmGNpA5JAAc1xP66vaflcju95oxYBVJ9z+axKDwCe/EdT9V7wJ/B7\nNxO/GOfyOFvEvPLvn+vyVwRXrDs6CVfxJJZHROhY/71BWy5Aarbxf6IG4TBkSXk3\n9qPprYCYlQKBgQC3RwZUn/cKP3t8kNeh5WU3ib+sMNH7+eS0t2j1RplXg9f97kPd\n2vMmIVtKgvEfUWIIJ1Oe/iteaYRqWX6L+GnPqwqWBGkSB2Cd4WZeg3sk21p9K3CQ\neDrVZYrUq5d0UqqX8uDOkeQs74K3P6pXM/P8s5fuFvmfpRQgw0uoOknlFQKBgBOD\nvZFqDfhUc1p7o1x/rWexNezNG8QQr+eSwgYr8s2oiKeOhaBjh+HXBSkUK8xxlXzI\nK99I9Fwqbcuch34+5FuLkO+8pkh/56hSUF3vWfMz5jWrjpDIIGX8CsbqLJtMHN2p\nrPXbEhQrkTBL543UNyAUHHqeX7uqJg+fzdy7KEo9AoGBAOFRm+giU5pVRdPGk6S2\n2qhldyE05cseaD/HknQS6YmbEZdcUU0nh0xYFiBcAT7IR3KMy/2qmlmd8Vozj78i\nKR39H7PNHlzUL0kKRwrKVzHbxQvMjEYAZ8KNB2nwxBMH5LTQ+Pj9GHurzG9ws2fO\nCio7IaijOeeAnX2ZcgvHY+Ho\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-i37c3@speedy-57c76.iam.gserviceaccount.com",
    "client_id": "107810720187451665938",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-i37c3%40speedy-57c76.iam.gserviceaccount.com",
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
