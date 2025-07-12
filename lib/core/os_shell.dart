import 'package:deeperos_prototype_ui/widgets/dock_home_screen.dart';
import 'package:deeperos_prototype_ui/widgets/app_window_overlay.dart';
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

class _OSShellState extends State<OSShell> with TickerProviderStateMixin {
  String _time = '';
  String _date = '';
  bool _notchExpanded = false;
  bool _notchFullyExpanded = false;
  String _notification = '';
  late AnimationController _notchController;
  late Animation<double> _notchAnimation;
  bool _showDockHome = false;
  late AnimationController _dockHomeController;
  late Animation<double> _dockHomeAnimation;

  final List<String> _demoNotifications = [
    "File system: Backup completed.",
    "App: Music player started.",
    "Agent: New message received.",
    "System: Update available.",
    "Sensors: Temperature normal.",
  ];

  Map<String, bool> _openWindows = {
    'Tasks': false,
    'Notify': false,
    'Settings': false,
    'Home': false,
    'AI': false,
    'Sensors': false,
    'Files': false,
  };

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(Duration(seconds: 1), (timer) => _updateTime());
    _notchController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );
    _notchAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _notchController, curve: Curves.easeInOut),
    );
    _dockHomeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700), // slower entrance animation
    );
    _dockHomeAnimation = CurvedAnimation(
      parent: _dockHomeController,
      curve: Curves.easeInOutCubic,
    );
    _startDemoNotifications();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _time =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
      _date = "${now.day}/${now.month}/${now.year}";
    });
  }

  void _openPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _toggleNotch() {
    setState(() {
      if (_notchFullyExpanded) {
        _notchFullyExpanded = false;
        _notchExpanded = false;
        _notchController.reverse();
      } else if (_notchExpanded) {
        _notchFullyExpanded = true;
        // Animate to full expansion (vertical dropdown)
        _notchController.animateTo(
          1.0,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      } else {
        _notchExpanded = true;
        // Animate to notification state (horizontal expansion)
        _notchController.animateTo(
          0.5,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _startDemoNotifications() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: 7));
      setState(() {
        _notification = (_demoNotifications..shuffle()).first;
        _notchExpanded = true;
        _notchFullyExpanded = false;
      });
      _notchController.forward();
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        _notification = '';
        _notchExpanded = false;
        _notchFullyExpanded = false;
      });
      _notchController.reverse();
    }
  }

  void _openDockHome() {
    setState(() {
      _showDockHome = true;
    });
    _dockHomeController.forward();
  }

  void _closeDockHome() {
    _dockHomeController.reverse().then((_) {
      setState(() {
        _showDockHome = false;
      });
    });
  }

  void _openWindow(String app) {
    setState(() {
      _openWindows[app] = true;
    });
  }

  void _closeWindow(String app) {
    setState(() {
      _openWindows[app] = false;
    });
  }

  @override
  void dispose() {
    _notchController.dispose();
    _dockHomeController.dispose();
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
          // Topbar
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 2.0,
                  left: 2.0,
                  right: 2.0,
                  bottom: 6.0,
                ),
                child: Container(
                  height: 28,
                  color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left: Agent icon and DeeperOS text
                      Container(
                        margin: EdgeInsets.only(left: 6, right: 6),
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
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
                      // Center: Dynamic Island (Notch) - overlay expansion
                      GestureDetector(
                        onTap: _toggleNotch,
                        child: AnimatedBuilder(
                          animation: _notchController,
                          builder: (context, child) {
                            double minHeight = 24;
                            double maxHeight = 220;
                            double minWidth = 120;
                            double maxWidth =
                                MediaQuery.of(context).size.width / 6;

                            double notchHeight = minHeight;
                            double notchWidth = minWidth;

                            // Only expand vertically for full expansion (user click)
                            if (_notchFullyExpanded) {
                              notchHeight =
                                  minHeight +
                                  (_notchController.value *
                                      (maxHeight - minHeight));
                              notchWidth = maxWidth;
                            } else if (_notchExpanded) {
                              notchHeight = minHeight;
                              notchWidth =
                                  minWidth +
                                  (_notchController.value *
                                      (maxWidth - minWidth));
                            }

                            return Material(
                              color: Colors.transparent,
                              child: Container(
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 12.0,
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Always show time and dots in the notch
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _time,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: Colors.yellow,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Centered notification or full expansion content
                                      if (_notchFullyExpanded)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (_notification.isNotEmpty) ...[
                                              Text(
                                                "Details",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                _notification,
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 15,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 16),
                                            ] else ...[
                                              Text(
                                                _time,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 32,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration: BoxDecoration(
                                                      color: Colors.yellow,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            SizedBox(height: 18),
                                            ..._demoNotifications.map(
                                              (n) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                    ),
                                                child: Text(
                                                  n,
                                                  style: TextStyle(
                                                    color: Colors.white38,
                                                    fontSize: 12,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      else if (_notchExpanded &&
                                          _notification.isNotEmpty)
                                        Center(
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      // Right: Battery, Wifi, Speaker icons with individual backgrounds
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.green[50]?.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.battery_full,
                              color: Colors.green[900],
                              size: 16,
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.brown[50]?.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.wifi,
                              color: Colors.yellow[800],
                              size: 16,
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.yellow[50]?.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.volume_up,
                              color: Colors.brown[900],
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 6),
              // Main content
              Expanded(
                child: Stack(
                  children: [
                    // Animate desktop icons up when dock home is shown
                    AnimatedBuilder(
                      animation: _dockHomeAnimation,
                      builder: (context, child) {
                        double translateY =
                            -MediaQuery.of(context).size.height *
                            0.5 *
                            _dockHomeAnimation.value;
                        double opacity = 1.0 - _dockHomeAnimation.value;
                        return Transform.translate(
                          offset: Offset(0, translateY),
                          child: Opacity(
                            opacity: opacity,
                            child: DesktopWidget(),
                          ),
                        );
                      },
                    ),
                    // Animate dock home screen in from bottom
                    if (_showDockHome)
                      AnimatedBuilder(
                        animation: _dockHomeAnimation,
                        builder: (context, child) {
                          double translateY =
                              MediaQuery.of(context).size.height *
                              (1 - _dockHomeAnimation.value);
                          return Transform.translate(
                            offset: Offset(0, translateY),
                            child: DockHomeScreen(onClose: _closeDockHome),
                          );
                        },
                      ),
                    // Window overlays for dock apps
                    if (_openWindows['Tasks'] == true)
                      AppWindowOverlay(
                        appName: 'Tasks',
                        icon: Icons.list,
                        color: Colors.yellow[700]!,
                        onClose: () => _closeWindow('Tasks'),
                        child: TaskManager(),
                        animationType: AppWindowAnimationType.squeeze,
                      ),
                    if (_openWindows['Notify'] == true)
                      AppWindowOverlay(
                        appName: 'Notify',
                        icon: Icons.notifications,
                        color: Colors.green[700]!,
                        onClose: () => _closeWindow('Notify'),
                        child: Notifications(),
                        animationType: AppWindowAnimationType.fadeZoom,
                      ),
                    if (_openWindows['Settings'] == true)
                      AppWindowOverlay(
                        appName: 'Settings',
                        icon: Icons.settings,
                        color: Colors.brown[900]!,
                        onClose: () => _closeWindow('Settings'),
                        child: Settings(),
                        animationType: AppWindowAnimationType.squeeze,
                      ),
                    if (_openWindows['Files'] == true)
                      AppWindowOverlay(
                        appName: 'Files',
                        icon: Icons.folder,
                        color: Colors.yellow[800]!,
                        onClose: () => _closeWindow('Files'),
                        child: Center(
                          child: Text(
                            'Files App',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        animationType: AppWindowAnimationType.zoom,
                      ),
                    if (_openWindows['AI'] == true)
                      AppWindowOverlay(
                        appName: 'AI',
                        icon: Icons.memory,
                        color: Colors.green[800]!,
                        onClose: () => _closeWindow('AI'),
                        child: Center(
                          child: Text('AI App', style: TextStyle(fontSize: 20)),
                        ),
                        animationType: AppWindowAnimationType.fadeZoom,
                      ),
                    if (_openWindows['Sensors'] == true)
                      AppWindowOverlay(
                        appName: 'Sensors',
                        icon: Icons.sensors,
                        color: Colors.yellow[600]!,
                        onClose: () => _closeWindow('Sensors'),
                        child: Center(
                          child: Text(
                            'Sensors App',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        animationType: AppWindowAnimationType.squeeze,
                      ),
                  ],
                ),
              ),
              // Dock (icons only, no background)
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _DockIcon(
                      icon: Icons.list,
                      label: 'Tasks',
                      color: Colors.yellow[700],
                      onTap: () => _openWindow('Tasks'),
                    ),
                    _DockIcon(
                      icon: Icons.notifications,
                      label: 'Notify',
                      color: Colors.green[700],
                      onTap: () => _openWindow('Notify'),
                    ),
                    _DockIcon(
                      icon: Icons.settings,
                      label: 'Settings',
                      color: Colors.brown[900],
                      onTap: () => _openWindow('Settings'),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_showDockHome) {
                          _closeDockHome();
                        } else {
                          _openDockHome();
                        }
                      },
                      onVerticalDragEnd: (details) {
                        if (details.primaryVelocity != null &&
                            details.primaryVelocity! < 0) {
                          _openDockHome();
                        }
                      },
                      child: _DockIcon(
                        icon: Icons.home,
                        label: 'Home',
                        color: Colors.yellow[800],
                        onTap: () {
                          if (_showDockHome) {
                            _closeDockHome();
                          } else {
                            _openDockHome();
                          }
                        },
                      ),
                    ),
                    _DockIcon(
                      icon: Icons.memory,
                      label: 'AI',
                      color: Colors.green[800],
                      onTap: () => _openWindow('AI'),
                    ),
                    _DockIcon(
                      icon: Icons.sensors,
                      label: 'Sensors',
                      color: Colors.yellow[600],
                      onTap: () => _openWindow('Sensors'),
                    ),
                    _DockIcon(
                      icon: Icons.folder,
                      label: 'Files',
                      color: Colors.yellow[800],
                      onTap: () => _openWindow('Files'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
          // Overlay dropdown for notch
          AnimatedBuilder(
            animation: _notchController,
            builder: (context, child) {
              double minHeight = 0;
              double notifHeight = 48;
              double maxHeight = 220;
              double minWidth = 120;
              double maxWidth = MediaQuery.of(context).size.width / 6;

              double notchHeight = minHeight;
              double notchWidth = minWidth;

              if (_notchFullyExpanded) {
                notchHeight = maxHeight;
                notchWidth = maxWidth;
              } else if (_notchExpanded) {
                notchHeight = notifHeight;
                notchWidth = maxWidth;
              }

              // Only animate vertical expansion for full expansion
              if (_notchFullyExpanded) {
                notchHeight =
                    minHeight +
                    (_notchController.value * (maxHeight - minHeight));
                notchWidth = maxWidth;
              } else if (_notchExpanded) {
                notchHeight = notifHeight;
                notchWidth =
                    minWidth + (_notchController.value * (maxWidth - minWidth));
              }

              if ((!_notchExpanded && !_notchFullyExpanded) || notchHeight < 8)
                return SizedBox.shrink();

              return Positioned(
                top: 34, // just below the topbar (28 + 6)
                left: MediaQuery.of(context).size.width / 2 - (notchWidth / 2),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: notchWidth,
                    height: notchHeight,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 12.0,
                      ),
                      child: _notchFullyExpanded
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (_notification.isNotEmpty) ...[
                                  Text(
                                    "Details",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    _notification,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16),
                                ] else ...[
                                  Text(
                                    _time,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                SizedBox(height: 18),
                                ..._demoNotifications.map(
                                  (n) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2.0,
                                    ),
                                    child: Text(
                                      n,
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : (_notchExpanded && _notification.isNotEmpty)
                          ? Center(
                              child: Text(
                                _notification,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  ),
                ),
              );
            },
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
