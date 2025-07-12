import 'package:flutter/material.dart';

class DesktopWidget extends StatelessWidget {
  final List<_DesktopIconData> icons = [
    _DesktopIconData('Documents', _DesktopIconType.folder),
    _DesktopIconData('Downloads', _DesktopIconType.folder),
    _DesktopIconData('Musics', Icons.music_note),
    _DesktopIconData('Agents', Icons.memory),
    _DesktopIconData('Pictures', Icons.image),
    _DesktopIconData('Settings', Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/desktop/image.png', fit: BoxFit.cover),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // First row: 3 icons, slightly staggered
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.translate(
                      offset: Offset(0, 0),
                      child: _DesktopIcon(icons[0]),
                    ),
                    SizedBox(width: 24),
                    Transform.translate(
                      offset: Offset(0, 8),
                      child: _DesktopIcon(icons[1]),
                    ),
                    SizedBox(width: 24),
                    Transform.translate(
                      offset: Offset(0, -6),
                      child: _DesktopIcon(icons[2]),
                    ),
                  ],
                ),
                // Second row: 2 icons, not aligned with first row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 36),
                    Transform.translate(
                      offset: Offset(0, 12),
                      child: _DesktopIcon(icons[3]),
                    ),
                    SizedBox(width: 48),
                    Transform.translate(
                      offset: Offset(0, -4),
                      child: _DesktopIcon(icons[4]),
                    ),
                  ],
                ),
                // Third row: 1 icon, offset to the left
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 72),
                    Transform.translate(
                      offset: Offset(0, 18),
                      child: _DesktopIcon(icons[5]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum _DesktopIconType { folder, other }

class _DesktopIconData {
  final String label;
  final dynamic icon; // IconData or _DesktopIconType
  _DesktopIconData(this.label, this.icon);
}

class _DesktopIcon extends StatelessWidget {
  final _DesktopIconData data;
  const _DesktopIcon(this.data);

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    if (data.icon == _DesktopIconType.folder) {
      iconWidget = _GreenFolderIcon();
    } else {
      iconWidget = Icon(data.icon, color: Colors.yellow[700], size: 36);
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: data.icon == _DesktopIconType.folder
                ? Colors.green[100]!.withOpacity(0.15)
                : Colors.yellow[100]!.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:
                    (data.icon == _DesktopIconType.folder
                            ? Colors.green
                            : Colors.yellow)
                        .withOpacity(0.2),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(12),
          child: iconWidget,
        ),
        SizedBox(height: 6),
        Text(
          data.label,
          style: TextStyle(
            color: data.icon == _DesktopIconType.folder
                ? Colors.green[700]
                : Colors.yellow[700],
            fontWeight: FontWeight.w500,
            fontSize: 13,
            shadows: [
              Shadow(
                color: Colors.brown.withOpacity(0.2),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GreenFolderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(painter: _GreenFolderPainter()),
    );
  }
}

class _GreenFolderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final folderGradient = LinearGradient(
      colors: [Colors.green[400]!, Colors.green[700]!],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final paint = Paint()
      ..shader = folderGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    // Folder body
    final bodyRect = Rect.fromLTWH(4, 12, size.width - 8, size.height - 16);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(6)),
      paint,
    );

    // Folder tab
    final tabRect = Rect.fromLTWH(8, 6, size.width / 2, 8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(tabRect, Radius.circular(3)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
