import 'package:flutter/material.dart';
import 'core/os_shell.dart';

void main() {
  runApp(DeeperOSApp());
}

class DeeperOSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeeperOS Prototype UI',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OSShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}
