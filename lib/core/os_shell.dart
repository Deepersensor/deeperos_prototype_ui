import 'package:flutter/material.dart';
import 'task_manager.dart';
import 'notifications.dart';
import 'settings.dart';
import 'dart:async';

class OSShell extends StatefulWidget {
  @override
  State<OSShell> createState() => _OSShellState();
}

class _OSShellState extends State<OSShell> {
  String _dateTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(Duration(seconds: 1), (timer) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _dateTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}  ${now.day}/${now.month}/${now.year}";
    });
  }

  void _openPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Column(
        children: [
          // Taskbar (reduce height)
          Container(
            height: 28, // reduced from 38
            color: Colors.brown[700],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'DeeperOS',
                    style: TextStyle(
                      color: Colors.yellow[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    _dateTime,
                    style: TextStyle(
                      color: Colors.green[200],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to the OS Shell',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.brown[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.brown[900],
                      backgroundColor: Colors.yellow[700],
                    ),
                    icon: Icon(Icons.list),
                    label: Text('Open Task Manager'),
                    onPressed: () => _openPage(TaskManager()),
                  ),
                ],
              ),
            ),
          ),
          // Dock (rounded, detached, gradient, shadow, more icons)
          SizedBox(height: 16),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.brown[900]!, Colors.yellow[700]!],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.4),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _DockIcon(
                    icon: Icons.list,
                    label: 'Tasks',
                    color: Colors.yellow[100],
                    onTap: () => _openPage(TaskManager()),
                  ),
                  _DockIcon(
                    icon: Icons.notifications,
                    label: 'Notify',
                    color: Colors.green[200],
                    onTap: () => _openPage(Notifications()),
                  ),
                  _DockIcon(
                    icon: Icons.settings,
                    label: 'Settings',
                    color: Colors.brown[100],
                    onTap: () => _openPage(Settings()),
                  ),
                  _DockIcon(
                    icon: Icons.home,
                    label: 'Home',
                    color: Colors.yellow[300],
                    onTap: () {}, // Placeholder
                  ),
                  _DockIcon(
                    icon: Icons.memory,
                    label: 'AI',
                    color: Colors.green[300],
                    onTap: () {}, // Placeholder
                  ),
                  _DockIcon(
                    icon: Icons.sensors,
                    label: 'Sensors',
                    color: Colors.yellow[400],
                    onTap: () {}, // Placeholder
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DockIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _DockIcon({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color?.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(8),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: Colors.brown.withOpacity(0.3),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
