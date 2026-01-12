import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class CapsuleButton extends StatefulWidget {
  final String icon;
  final String label;
  final VoidCallback onPressed;

  const CapsuleButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<CapsuleButton> createState() => _CapsuleButtonState();
}

class _CapsuleButtonState extends State<CapsuleButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:  (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds:  150),
        transform: Matrix4.identity()
          ..translate(0.0, _isPressed ? 5.0 : 0.0)  // ← CORRIGÉ ICI
          ..scale(_isPressed ? 1.08 : 1.0),
        decoration: BoxDecoration(
          color:  Colors.white.withOpacity(_isPressed ? 0.4 : 0.3),
          borderRadius: BorderRadius.circular(30),
          border: Border. all(
            color: Colors. white.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isPressed ? 0.25 :  0.15),
              blurRadius: _isPressed ? 35 : 25,
              offset:  Offset(0, _isPressed ? 12 : 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.icon,
              style: const TextStyle(
                fontSize: 28,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset:  Offset(0, 3),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.label,
              style: AppTheme.buttonLabelStyle,
            ),
          ],
        ),
      ),
    );
  }
}