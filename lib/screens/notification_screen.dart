//updated code of notification
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
  bool isPushNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool pushEnabled = prefs.getBool('push_notification') ?? false;

    // Check the actual notification permission status
    var status = await Permission.notification.status;
    if (status.isGranted) {
      pushEnabled = true;
      _savePreference('push_notification', true);
    } else {
      pushEnabled = false;
      _savePreference('push_notification', false);
    }

    setState(() {
      isWhatsAppEnabled = prefs.getBool('whatsapp') ?? false;
      isPushNotificationEnabled = pushEnabled;
    });
  }

  _savePreference(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<bool> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isRestricted || status.isLimited) {
      var result = await Permission.notification.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text(
          'Notification permission is required. Please enable it in the app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showGoToSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable Notifications'),
        content: const Text(
          'To disable notifications, please go to the app settings and turn off notifications manually.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _togglePushNotifications(bool value) async {
    if (value) {
      bool granted = await _requestNotificationPermission();
      if (granted) {
        setState(() {
          isPushNotificationEnabled = true;
          _savePreference('push_notification', true);
          // Enable push notifications
        });
      } else {
        _showPermissionDeniedDialog();
      }
    } else {
      _showGoToSettingsDialog();
    }
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
                    onChanged: _togglePushNotifications,
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