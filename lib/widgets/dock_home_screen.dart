import 'package:flutter/material.dart';

class DockHomeScreen extends StatefulWidget {
  final VoidCallback onClose;
  const DockHomeScreen({required this.onClose});

  @override
  State<DockHomeScreen> createState() => _DockHomeScreenState();
}

class _DockHomeScreenState extends State<DockHomeScreen> {
  int _currentDesktop = 0;
  final List<List<String>> _desktops = [
    ['Documents', 'Downloads', 'Musics'],
    ['Agents', 'Pictures', 'Settings'],
    ['Work', 'Games', 'Notes'],
  ];
  final List<String> _applications = [
    'Browser',
    'Editor',
    'Terminal',
    'Music',
    'Photos',
    'Mail',
    'Calendar',
    'Files',
  ];
  int _appPage = 0;

  void _onHorizontalSwipe(DragEndDetails details) {
    if (details.primaryVelocity != null) {
      if (details.primaryVelocity! < 0 &&
          _currentDesktop < _desktops.length - 1) {
        setState(() => _currentDesktop++);
      } else if (details.primaryVelocity! > 0 && _currentDesktop > 0) {
        setState(() => _currentDesktop--);
      }
    }
  }

  void _onVerticalSwipe(DragEndDetails details) {
    if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onVerticalDragEnd: _onVerticalSwipe,
        onHorizontalDragEnd: _onHorizontalSwipe,
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Column(
            children: [
              SizedBox(height: 32),
              // Top central search bar
              Center(
                child: Container(
                  width: 320,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.brown[50],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.brown[700]),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Desktop previews
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _desktops.length,
                  itemBuilder: (context, idx) {
                    return Container(
                      width: 120,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: idx == _currentDesktop
                            ? Colors.yellow[700]
                            : Colors.brown[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.18),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: idx == _currentDesktop
                              ? Colors.brown[900]!
                              : Colors.brown[400]!,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _desktops.add(['New Desktop']);
                                });
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.green[700],
                                size: 20,
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _desktops[idx]
                                  .map(
                                    (e) => Text(
                                      e,
                                      style: TextStyle(
                                        color: Colors.brown[900],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              // Applications list (paged)
              Expanded(
                child: PageView.builder(
                  itemCount: (_applications.length / 6).ceil(),
                  controller: PageController(initialPage: _appPage),
                  onPageChanged: (i) => setState(() => _appPage = i),
                  itemBuilder: (context, pageIdx) {
                    final apps = _applications
                        .skip(pageIdx * 6)
                        .take(6)
                        .toList();
                    return GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 8,
                      ),
                      children: apps
                          .map(
                            (app) => Card(
                              color: Colors.green[100],
                              child: Center(
                                child: Text(
                                  app,
                                  style: TextStyle(
                                    color: Colors.brown[900],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
