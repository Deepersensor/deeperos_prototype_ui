import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  final List<String> notifications = [
    'System update available',
    'AI Agent completed training',
    'Sensor calibration required',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('Notifications'),
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (_, __) => Divider(color: Colors.brown),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              Icons.notification_important,
              color: Colors.yellow[700],
            ),
            title: Text(
              notifications[index],
              style: TextStyle(color: Colors.brown[900]),
            ),
          );
        },
      ),
    );
  }
}
