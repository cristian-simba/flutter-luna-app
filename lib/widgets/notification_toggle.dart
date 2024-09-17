import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/notification_provider.dart';
import 'package:luna/providers/icon_color_provider.dart';
import 'package:luna/constants/colors.dart';

class NotificationToggle extends StatelessWidget {
  const NotificationToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final inactiveBackground = theme.brightness == Brightness.dark ? Colors.grey[900] : CardColors.lightCard;
    final inactiveThumbColor = theme.brightness == Brightness.dark ? Colors.grey[700]: Colors.grey[300];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Notificaciones"),
        Switch(
          value: notificationProvider.notificationsEnabled,
          activeColor: iconColor,
          trackOutlineWidth: WidgetStatePropertyAll(0),     
          inactiveThumbColor: inactiveThumbColor,
          inactiveTrackColor: inactiveBackground,
          onChanged: notificationProvider.toggleNotifications,
        )
      ],
    );
  }
}
