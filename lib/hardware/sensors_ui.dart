import 'package:flutter/material.dart';

class SensorsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sensors')),
      body: Center(child: Text('Sensor status and controls')),
    );
  }
}
