import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

Future<String> getAccessToken() async {
  final serviceAccountJson = {"type": "service_account", "project_id": "speedy-57c76", "private_key_id": "<Key-ID>", "private_key": "<KEY>", "client_email": "owner-382@speedy-57c76.iam.gserviceaccount.com", "client_id": "113791250062305467534", "auth_uri": "https://accounts.google.com/o/oauth2/auth", "token_uri": "https://oauth2.googleapis.com/token", "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs", "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/owner-382%40speedy-57c76.iam.gserviceaccount.com", "universe_domain": "googleapis.com"};

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

void sendPushNotification(String token, String body, String title) async {
  final String serverAccessTokenKey = await getAccessToken();
  String endpoint = "https://fcm.googleapis.com/v1/projects/speedy-57c76/messages:send";

  final Map<String, dynamic> message = {
    'message': {
      'token': token,
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
