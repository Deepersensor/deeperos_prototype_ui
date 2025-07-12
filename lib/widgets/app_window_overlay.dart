import 'package:flutter/material.dart';

enum AppWindowAnimationType { squeeze, zoom, fadeZoom }

class AppWindowOverlay extends StatefulWidget {
  final String appName;
  final IconData icon;
  final Color color;
  final Widget child;
  final VoidCallback onClose;
  final AppWindowAnimationType animationType;

  const AppWindowOverlay({
    required this.appName,
    required this.icon,
    required this.color,
    required this.child,
    required this.onClose,
    this.animationType = AppWindowAnimationType.squeeze,
  });

  @override
  State<AppWindowOverlay> createState() => _AppWindowOverlayState();
}

class _AppWindowOverlayState extends State<AppWindowOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;
  Offset _offset = Offset(80, 120);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 420),
      vsync: this,
    );
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Matrix4 _getTransform(Size size) {
    switch (widget.animationType) {
      case AppWindowAnimationType.squeeze:
        return Matrix4.identity()
          ..translate(_offset.dx, _offset.dy)
          ..scale(0.5 + 0.5 * _anim.value, 0.5 + 0.5 * _anim.value);
      case AppWindowAnimationType.zoom:
        return Matrix4.identity()
          ..translate(_offset.dx, _offset.dy)
          ..scale(_anim.value, _anim.value);
      case AppWindowAnimationType.fadeZoom:
        return Matrix4.identity()
          ..translate(_offset.dx, _offset.dy)
          ..scale(0.7 + 0.3 * _anim.value, 0.7 + 0.3 * _anim.value);
      default:
        return Matrix4.identity()..translate(_offset.dx, _offset.dy);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _offset += details.delta;
              });
            },
            child: Transform(
              transform: _getTransform(size),
              child: Opacity(
                opacity: _anim.value,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: size.width * 0.45,
                    height: size.height * 0.45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4B2E19), // dark brown, dirt brick
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(0.18),
                          blurRadius: 32,
                          spreadRadius: 8,
                          offset: Offset(0, 12),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 16,
                          spreadRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: widget.color.withOpacity(0.7),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 18,
                          left: 18,
                          child: Row(
                            children: [
                              Icon(widget.icon, color: widget.color, size: 28),
                              SizedBox(width: 10),
                              Text(
                                widget.appName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: widget.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 18,
                          right: 18,
                          child: GestureDetector(
                            onTap: widget.onClose,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.brown[700],
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          top: 56,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: widget.child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
