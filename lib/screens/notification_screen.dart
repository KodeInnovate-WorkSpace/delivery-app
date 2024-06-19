import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool isWhatsAppEnabled = false;
  bool isPushNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isWhatsAppEnabled = prefs.getBool('whatsapp') ?? false;
      isPushNotificationEnabled = prefs.getBool('push_notification') ?? false;
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
        title: const Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: const Color(0xffeaf1fc),
              elevation: 4,
              child: SwitchListTile(
                title: const Text('WhatsApp Messages'),
                subtitle: const Text('Get updates from us on WhatsApp'),
                value: isWhatsAppEnabled,
                activeColor: Colors.green,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade400,
                onChanged: (value) {
                  setState(() {
                    isWhatsAppEnabled = value;
                    _savePreference('whatsapp', value);
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xffeaf1fc),
              elevation: 4,
              child: SwitchListTile(
                title: const Text('Push notifications'),
                subtitle: const Text('Turn on to get live order updates & offers'),
                value: isPushNotificationEnabled,
                activeColor: Colors.green,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade400,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}