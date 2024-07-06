import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool isWhatsAppEnabled = false;
  bool isPushNotificationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isWhatsAppEnabled = prefs.getBool('whatsapp') ?? false;
      isPushNotificationEnabled = prefs.getBool('push_notification') ?? true;
    });
  }

  _savePreference(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<bool> _requestNotificationPermission() async {
    var status = await Permission.notification.request();
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Color(0xff1c1c1c), fontFamily: 'Gilroy-Bold')),
        backgroundColor: const Color(0xfff7f7f7),
        elevation: 0,
      ),
      backgroundColor: const Color(0xfff7f7f7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // WhatsApp Messages
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: const Offset(0, 2), // Shadow offset (x, y)
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text('WhatsApp Messages', style: TextStyle(color: Color(0xff666666), fontFamily: 'Gilroy-SemiBold')),
                    subtitle: const Text('Get updates from us on WhatsApp', style: TextStyle(color: Color(0xff666666))),
                    value: isWhatsAppEnabled,
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey.shade300,
                    onChanged: (value) {
                      setState(() {
                        isWhatsAppEnabled = value;
                        _savePreference('whatsapp', value);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Push Notification
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: const Offset(0, 2), // Shadow offset (x, y)
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text('Push notifications', style: TextStyle(color: Color(0xff666666), fontFamily: 'Gilroy-SemiBold')),
                    subtitle: const Text('Turn on to get live order updates & offers', style: TextStyle(color: Color(0xff666666))),
                    value: isPushNotificationEnabled,
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey.shade300,
                    onChanged: (value) async {
                      if (value) {
                        bool granted = await _requestNotificationPermission();
                        if (granted) {
                          setState(() {
                            isPushNotificationEnabled = value;
                            _savePreference('push_notification', value);
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Notification permission is required.'),
                          ));
                        }
                      } else {
                        setState(() {
                          isPushNotificationEnabled = value;
                          _savePreference('push_notification', value);
                        });
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
