import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.brown[700],
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(
              'Enable AI Agent',
              style: TextStyle(color: Colors.green[900]),
            ),
            value: true,
            activeColor: Colors.green,
            onChanged: (val) {},
          ),
          SwitchListTile(
            title: Text(
              'Sensor Monitoring',
              style: TextStyle(color: Colors.yellow[900]),
            ),
            value: false,
            activeColor: Colors.yellow[700],
            onChanged: (val) {},
          ),
          ListTile(
            title: Text(
              'System Theme',
              style: TextStyle(color: Colors.brown[900]),
            ),
            trailing: DropdownButton<String>(
              value: 'Brown',
              items: [
                'Brown',
                'Yellow',
                'Green',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {},
            ),
          ),
        ],
      ),
    );
  }
}
