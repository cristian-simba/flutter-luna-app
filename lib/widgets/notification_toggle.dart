import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luna/services/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';
import 'package:luna/constants/colors.dart';

class NotificationToggle extends StatefulWidget {
  const NotificationToggle({Key? key}) : super(key: key);

  @override
  _NotificationToggleState createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
    if (value) {
      NotificationService.scheduleNotification();
    } else {
      await AwesomeNotifications().cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;
    final inactiveBackground = theme.brightness == Brightness.dark ? Colors.grey[900] : CardColors.lightCard;
    final inactiveThumbColor = theme.brightness == Brightness.dark ? Colors.grey[700]: Colors.grey[300];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Notificaciones"),
        Switch(
          value: _notificationsEnabled,
          activeColor: iconColor,
          trackOutlineWidth: WidgetStatePropertyAll(0),     
          inactiveThumbColor: inactiveThumbColor,
          inactiveTrackColor: inactiveBackground,
          onChanged: _toggleNotifications,
        )
      ],
    );
  }
}