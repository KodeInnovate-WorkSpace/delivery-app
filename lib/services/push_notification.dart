import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

// Future<String> getAccessToken() async {
//   final serviceAccountJson = {
//     "type": "service_account",
//     "project_id": "speedy-57c76",
//     "private_key_id": "3e718c51a7dfcdf6310822f379eeea159e7f0bb0",
//     "private_key":
//         "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDMammm1Ev8pd2d\n6VRx0UVbfnIb2WjqX3V5JbfmdvCn54U2zZ71r0jiwbohksS1ttClJRziirxV4wKQ\nmwSNNAeeo6zsYs/iHfD9HIrn1Vsu6T50t852AjAPyW3sOZVgq63ZxfbERzJ+D4yR\nKzoQnCnOn5aUTAlfgDAXZr7iz0fMQLbk0PZibYrAdR4PHRmPdV7kERWDGNbWFyzg\neha6doJcu1eAZhmkqCao3xSe6MK3ws9uHX1A3JMTQhYRHXa6RShun/OCCaQsq2w+\nRrQqyCDkOhm0Cg0HqtnaDafRBUcJ2JH9Ek2UQQxFmUnSkvV6dP3C6yu+QP0N3VcO\nNyzxwo/rAgMBAAECggEADZqZXGZthitds9gm7Aoy1PN10Z+m6U4gCcd2VSqeOnZg\nebS2ewBG1/xvkDNtzvATM6JkKTl1bjvU3F3MsD8BsM+QvwyWbCR0+MtQ/TvIPTd9\nlhPzdAwSOcK8g4eThuL2B3Oyx/47AIO1ZaXcT+WsrJkXUtg6mXX0/WGzm3GTBCc9\n13nCAwsEeF8S0lJF7ho44aEWMvQL6vp1WFQ+koZrEkVqzW8APzhWAZwH34c9lLFc\nPNEbfPYa+qOa1YXQM8s4E/n8RRXtAMn3F/eYskFCvczvKfI0qDGFO4eCHhfUqFc3\nRXprgQe6dl/IfPpp1+frCl9fQju/byvlGLh4bv2OqQKBgQD4alo5QYPmdTSO8V9k\nmqvFg7HmVXAyHk2SKzR9jEaazPmO0OQBpgdv47GL/2ZuyEPQ+m1KvlIR/KPNe4UN\nmqOWeeLseUQb90tUR/KUsdYLf8y71mi2sRD6WF0KsO+WI3+lVVzJuTIodEIcX0I5\n4U1Y8ezF0dSBmdphLyvxJAhauQKBgQDSqCcAdsDCeExf9ekgb04iYVeX43uSqulA\nY2p3AP4B/iJkacohuaBgudj0YmaHeVh+bUUtfMiMfYGkSdcdDEutS+07NdaT71qG\nQT38NInmQZxLtN+5c46MmK8ySzMVK7uVt0CJQjOiODgbPVJE9MNWJcFJ3GZHsEW9\ndUzYlNKdwwKBgFbSDNCABlJwWjsvPxDRQgGZIn8HE1xg3OmeMg1DDpYh14LDnTy6\nQ1UmtjHgxHMpiRIrxDDgTZy9uJ4jcoArsMrxtI7DXzuK9YfyUWUItm90biCkMhrP\nzchBQ9tttX66z20AZZqXIGGlKEn0PRgvlzHj88W7rVLSa9GVg/0Wg9j5AoGBAI0T\nk9sZrIoQaoWxeIkCQb+AlVrhO/bDgyZd7gT4oyPOgFXjCz1+xUtB62vvIl8EAyHY\nKAYIlX6Q5uuRkACiJWRPfvayXZwBJgzXUJ3AycFsmzGQVmwqWYMLFfmGpxU8jon7\nibrinRW8tMZ5UMlhahgdfM7sTYshH/N7xRUexdZlAoGAJlFrBH86UxHw1bTydNpa\nH3P93eNcCkNJ+eUaaZkjfHld3SM4P7vsxoyxApNuoiMQQVCAMzPSBsxAmSulzwsr\ncAnLF/L+mgWiykiPIJVIen/Yh8kzgQzqmJlPsXs2eW4GGGKPsBErUYJm1l1mLYtU\nQl6/bqxGtcbelwyd4qS3nQg=\n-----END PRIVATE KEY-----\n",
//     "client_email": "owner-382@speedy-57c76.iam.gserviceaccount.com",
//     "client_id": "113791250062305467534",
//     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//     "token_uri": "https://oauth2.googleapis.com/token",
//     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//     "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/owner-382%40speedy-57c76.iam.gserviceaccount.com",
//     "universe_domain": "googleapis.com"
//   };
//
//   List<String> scopes = ["https://www/googleapis.com/auth/firebase.messaging"];
//
//   http.Client client = await auth.clientViaServiceAccount(
//     auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//     scopes,
//   );
//
// //get access token
//   auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes, client);
//
//   client.close();
//
//   return credentials.accessToken.data;
// }
//
// void sendPushNotification(String token, String body, String title) async {
//   final String serverAccessTokenKey = await getAccessToken();
//   String endpoint = "https://fcm.googleapis.com/v1/projects/speedy-57c76/messages:send";
//
//   final Map<String, dynamic> message = {
//     'message': {
//       'token': token,
//       'notification': {
//         'title': title,
//         'body': body,
//       },
//     }
//   };
//
//   final http.Response res = await http.post(
//     Uri.parse(endpoint),
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $serverAccessTokenKey',
//     },
//     body: jsonEncode(message),
//   );
//
//   if (res.statusCode == 200) {
//     log("FCM message sent successfully ");
//   } else {
//     log("Error");
//   }
// }

Future<String> getAccessToken() async {
  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "speedy-57c76",
    "private_key_id": "3e718c51a7dfcdf6310822f379eeea159e7f0bb0",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDMammm1Ev8pd2d\n6VRx0UVbfnIb2WjqX3V5JbfmdvCn54U2zZ71r0jiwbohksS1ttClJRziirxV4wKQ\nmwSNNAeeo6zsYs/iHfD9HIrn1Vsu6T50t852AjAPyW3sOZVgq63ZxfbERzJ+D4yR\nKzoQnCnOn5aUTAlfgDAXZr7iz0fMQLbk0PZibYrAdR4PHRmPdV7kERWDGNbWFyzg\neha6doJcu1eAZhmkqCao3xSe6MK3ws9uHX1A3JMTQhYRHXa6RShun/OCCaQsq2w+\nRrQqyCDkOhm0Cg0HqtnaDafRBUcJ2JH9Ek2UQQxFmUnSkvV6dP3C6yu+QP0N3VcO\nNyzxwo/rAgMBAAECggEADZqZXGZthitds9gm7Aoy1PN10Z+m6U4gCcd2VSqeOnZg\nebS2ewBG1/xvkDNtzvATM6JkKTl1bjvU3F3MsD8BsM+QvwyWbCR0+MtQ/TvIPTd9\nlhPzdAwSOcK8g4eThuL2B3Oyx/47AIO1ZaXcT+WsrJkXUtg6mXX0/WGzm3GTBCc9\n13nCAwsEeF8S0lJF7ho44aEWMvQL6vp1WFQ+koZrEkVqzW8APzhWAZwH34c9lLFc\nPNEbfPYa+qOa1YXQM8s4E/n8RRXtAMn3F/eYskFCvczvKfI0qDGFO4eCHhfUqFc3\nRXprgQe6dl/IfPpp1+frCl9fQju/byvlGLh4bv2OqQKBgQD4alo5QYPmdTSO8V9k\nmqvFg7HmVXAyHk2SKzR9jEaazPmO0OQBpgdv47GL/2ZuyEPQ+m1KvlIR/KPNe4UN\nmqOWeeLseUQb90tUR/KUsdYLf8y71mi2sRD6WF0KsO+WI3+lVVzJuTIodEIcX0I5\n4U1Y8ezF0dSBmdphLyvxJAhauQKBgQDSqCcAdsDCeExf9ekgb04iYVeX43uSqulA\nY2p3AP4B/iJkacohuaBgudj0YmaHeVh+bUUtfMiMfYGkSdcdDEutS+07NdaT71qG\nQT38NInmQZxLtN+5c46MmK8ySzMVK7uVt0CJQjOiODgbPVJE9MNWJcFJ3GZHsEW9\ndUzYlNKdwwKBgFbSDNCABlJwWjsvPxDRQgGZIn8HE1xg3OmeMg1DDpYh14LDnTy6\nQ1UmtjHgxHMpiRIrxDDgTZy9uJ4jcoArsMrxtI7DXzuK9YfyUWUItm90biCkMhrP\nzchBQ9tttX66z20AZZqXIGGlKEn0PRgvlzHj88W7rVLSa9GVg/0Wg9j5AoGBAI0T\nk9sZrIoQaoWxeIkCQb+AlVrhO/bDgyZd7gT4oyPOgFXjCz1+xUtB62vvIl8EAyHY\nKAYIlX6Q5uuRkACiJWRPfvayXZwBJgzXUJ3AycFsmzGQVmwqWYMLFfmGpxU8jon7\nibrinRW8tMZ5UMlhahgdfM7sTYshH/N7xRUexdZlAoGAJlFrBH86UxHw1bTydNpa\nH3P93eNcCkNJ+eUaaZkjfHld3SM4P7vsxoyxApNuoiMQQVCAMzPSBsxAmSulzwsr\ncAnLF/L+mgWiykiPIJVIen/Yh8kzgQzqmJlPsXs2eW4GGGKPsBErUYJm1l1mLYtU\nQl6/bqxGtcbelwyd4qS3nQg=\n-----END PRIVATE KEY-----\n",
    "client_email": "owner-382@speedy-57c76.iam.gserviceaccount.com",
    "client_id": "113791250062305467534",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/owner-382%40speedy-57c76.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  List<String> scopes = ["https://www.googleapis.com/auth/firebase.messaging"];

  try {
    final client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // get access token
    final auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();

    return credentials.accessToken.data;
  } catch (e) {
    log('Error obtaining access token: $e');
    rethrow;
  }
}

// void sendPushNotification(String token, String body, String title) async {
//   try {
//     final String serverAccessTokenKey = await getAccessToken();
//     String endpoint = "https://fcm.googleapis.com/v1/projects/speedy-57c76/messages:send";
//
//     final Map<String, dynamic> message = {
//       'message': {
//         'token': token,
//         'notification': {
//           'title': title,
//           'body': body,
//         },
//         // 'data':{
//         //   'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//         //   'status': 'done',
//         //   'body': body,
//         //   'title': title,
//         // }
//       }
//     };
//
//     final http.Response res = await http.post(
//       Uri.parse(endpoint),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $serverAccessTokenKey',
//       },
//       body: jsonEncode(message),
//     );
//
//     if (res.statusCode == 200) {
//       log("FCM message sent successfully ");
//     } else {
//       log("Error sending FCM message: ${res.body}");
//     }
//   } catch (e) {
//     log('Error sending push notification: $e');
//   }
// }
void sendPushNotification(String token, String body, String title) async {
  final String serverAccessTokenKey = await getAccessToken();
  String endpoint = "https://fcm.googleapis.com/v1/projects/speedy-57c76/messages:send";

  // await admin.messaging().sendMulticast({
  //   'token': token,
  //   'notification': {
  //     'title': title,
  //     'body': body,
  //   },
  // });

  final Map<String, dynamic> message = {
    'message': {
      'token': "dQH-bSbiT3OKZ9spLUJZh6:APA91bHyNZOmTyJgdiOpfiIZuRG_tMrkZEGV1CZmHHDJSPt6CkHlR4XYT6_JwlvCAU0Ln3Y4g2ueoL25D1RvQ6rP5OvlYqDu_GHgi7r7qQIadOQ-I74l_w7n5FqCz2wlQbCp-0IwWxko",
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'status': 'done',
        'body': body,
        'title': title,
      },
      "notification": {
        "title": title,
        "body": body,
      }
    }
  };

  final http.Response res = await http.post(
    Uri.parse(endpoint),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverAccessTokenKey',
    },
    body: jsonEncode(message),
  );

  if (res.statusCode == 200) {
    log("FCM message sent successfully ");
  } else {
    log("Error sending FCM message: ${res.statusCode}, ${res.body}");
  }
}
