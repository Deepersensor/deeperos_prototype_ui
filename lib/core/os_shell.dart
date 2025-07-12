import 'package:flutter/material.dart';
import 'task_manager.dart';
import 'notifications.dart';
import 'settings.dart';
import 'dart:async';
import '../widgets/desktop_widget.dart';

class OSShell extends StatefulWidget {
  @override
  State<OSShell> createState() => _OSShellState();
}

class _OSShellState extends State<OSShell> with SingleTickerProviderStateMixin {
  String _time = '';
  String _date = '';
  bool _notchExpanded = false;
  String _notification = '';
  late AnimationController _notchController;
  late Animation<double> _notchAnimation;

  final List<String> _demoNotifications = [
    "File system: Backup completed.",
    "App: Music player started.",
    "Agent: New message received.",
    "System: Update available.",
    "Sensors: Temperature normal.",
  ];

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(Duration(seconds: 1), (timer) => _updateTime());
    _notchController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );
    _notchAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _notchController,
      curve: Curves.easeInOut,
    ));
    _startDemoNotifications();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _time = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
      _date = "${now.day}/${now.month}/${now.year}";
    });
  }

  void _openPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _toggleNotch() {
    setState(() {
      _notchExpanded = !_notchExpanded;
      if (_notchExpanded) {
        _notchController.forward();
      } else {
        _notchController.reverse();
      }
    });
  }

  void _startDemoNotifications() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: 7));
      setState(() {
        _notification = (_demoNotifications..shuffle()).first;
        _notchExpanded = true;
      });
      _notchController.forward();
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        _notification = '';
        _notchExpanded = false;
      });
      _notchController.reverse();
    }
  }

  @override
  void dispose() {
    _notchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Stack(
        children: [
          // Desktop background image covers entire UI
          Positioned.fill(
            child: Image.asset('assets/desktop/image.png', fit: BoxFit.cover),
          ),
          Column(
            children: [
              // Transparent top bar with individually colored widgets
              Padding(
                padding: const EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0, bottom: 6.0),
                child: Container(
                  height: 28,
                  color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left: Agent icon and DeeperOS text
                      Container(
                        margin: EdgeInsets.only(left: 6, right: 6),
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.memory, color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'DeeperOS',
                              style: TextStyle(
                                color: Colors.brown[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Spacer before notch
                      Expanded(child: SizedBox()),
                      // Center: Dynamic Island (Notch)
                      GestureDetector(
                        onTap: _toggleNotch,
                        child: AnimatedBuilder(
                          animation: _notchController,
                          builder: (context, child) {
                            double notchHeight = 24 + (_notchAnimation.value * 48);
                            double notchWidth = 120 + (_notchAnimation.value * 80);
                            return Container(
                              width: notchWidth,
                              height: notchHeight,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Green and yellow dot in center
                                  Positioned(
                                    top: notchHeight / 2 - 4,
                                    left: notchWidth / 2 - 4,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Time and date on sides
                                  Positioned(
                                    left: 12,
                                    top: notchHeight / 2 - 8,
                                    child: Text(
                                      _time,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 12,
                                    top: notchHeight / 2 - 8,
                                    child: Text(
                                      _date,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  // Notification text when expanded
                                  if (_notchExpanded && _notification.isNotEmpty)
                                    Positioned(
                                      bottom: 8,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Text(
                                          _notification,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Spacer after notch
                      Expanded(child: SizedBox()),
                      // Right: Battery, Wifi, Speaker icons with backgrounds
                      Container(
                        margin: EdgeInsets.only(right: 6, left: 6),
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.brown[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.battery_full, color: Colors.green[900], size: 16),
                            SizedBox(width: 6),
                            Icon(Icons.wifi, color: Colors.yellow[700], size: 16),
                            SizedBox(width: 6),
                            Icon(Icons.volume_up, color: Colors.brown[900], size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Add tiny padding between topbar and everything else
              SizedBox(height: 6),
              // Main content
              Expanded(child: DesktopWidget()),
              // Dock
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
