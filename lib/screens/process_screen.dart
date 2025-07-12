import 'package:flutter/material.dart';

class ProcessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Process Manager')),
      body: Center(child: Text('Manage processes and tasks')),
    );
  }
}
