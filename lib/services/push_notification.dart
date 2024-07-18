import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class LocalNotificationService {
 static Future<void> sendOrderNotification(BuildContext context, String orderId, String phone, double amount, String address, String paymentMethod) async {
    String username = dotenv.env['EMAIL']!;
    String password = dotenv.env['APP_PASSWORD']!;

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Order Received')
      ..recipients.add(dotenv.env['ADMIN_EMAIL']!)
      ..subject = orderId
      ..html = '''
     <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Email Template for Order Confirmation Email</title>
  </head>
  <body>
    <table
      class="backgroundTable main-temp"
      style="background-color: #d5d5d5"
    >
      <tbody>
        <tr>
          <td>
            <table
              class="devicewidth"
              style="background-color: #ffffff"
            >
              <tbody>
                <!-- Start address Section -->
                <tr>
                  <td style="padding-top: 0">
                    <table
                      class="devicewidthinner"
                      style="border-bottom: 1px solid #bbbbbb"
                    >
                      <tbody>
                        <tr>
                          <td
                            style="
                              width: 55%;
                              font-size: 14px;
                              line-height: 18px;
                              color: #666666;
                            "
                          >
                            Payment Mode: $paymentMethod
                          </td>
                        </tr>
                        <tr>
                          <td
                            style="
                              width: 55%;
                              font-size: 14px;
                              line-height: 18px;
                              color: #666666;
                            "
                          >
                            Phone No: $phone
                          </td>
                        </tr>
                        <tr>
                          <td
                            style="
                              width: 55%;
                              font-size: 14px;
                              line-height: 18px;
                              color: #666666;
                            "
                          >
                           Amount: ${amount}
                          </td>
                        </tr>
                        <tr>
                          <td
                            style="
                              width: 55%;
                              font-size: 14px;
                              line-height: 18px;
                              color: #666666;
                              padding-bottom: 10px;
                            "
                          >
                           Address: ${address}
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </td>
                </tr>
                <!-- End address Section -->
              </tbody>
            </table>
          </td>
        </tr>
      </tbody>
    </table>
  </body>
    ''';

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: $sendReport');
    } catch (e) {
      debugPrint('Message not sent: $e');
    }
  }

}
