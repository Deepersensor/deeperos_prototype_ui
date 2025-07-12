import 'package:flutter/material.dart';

class HardwareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hardware Overview')),
      body: Center(child: Text('View hardware status and controls')),
    );
  }
}
