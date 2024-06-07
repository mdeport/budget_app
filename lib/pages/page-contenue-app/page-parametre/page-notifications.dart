import 'package:flutter/material.dart';

class pageNotifications extends StatefulWidget {
  const pageNotifications({Key? key}) : super(key: key);

  @override
  _pageNotificationsState createState() =>
      _pageNotificationsState();
}

class _pageNotificationsState extends State<pageNotifications> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF2196F3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            // Ajoutez d'autres options de paramètres de notifications ici
          ],
        ),
      ),
    );
  }
}
