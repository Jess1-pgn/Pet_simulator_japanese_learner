import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool isLarge;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this. isLarge = false,
  }) : super(key: key);

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale:  _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: widget.isLarge ? 80 : 65,
              height: widget.isLarge ? 80 : 65,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color,
                    widget.color.withOpacity(0.7),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.4),
                    blurRadius:  15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: widget.isLarge ? 40 : 32,
              ),
            ),
            const SizedBox(height:  8),
            Text(
              widget.label,
              style: AppTheme.captionStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3142),
              ),
            ),
          ],
        ),
      ),
    );
  }
}