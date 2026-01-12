import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingParticles extends StatefulWidget {
  const FloatingParticles({Key?  key}) : super(key: key);

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  final List<String> particles = ['✨', '⭐', '💫', '🌟'];
  final List<Offset> positions = [
    const Offset(0.1, 0.2),   // Top left
    const Offset(0.85, 0.4),  // Top right
    const Offset(0.2, 0.7),   // Bottom left
    const Offset(0.9, 0.6),   // Right middle
  ];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(4, (index) {
      return AnimationController(
        duration:  const Duration(seconds: 4),
        vsync: this,
      )..repeat(reverse: true);
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: -20).animate(
        CurvedAnimation(parent: controller, curve: Curves. easeInOut),
      );
    }).toList();

    // Stagger the animations
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 500), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(4, (index) {
        return AnimatedBuilder(
          animation:  _animations[index],
          builder: (context, child) {
            return Positioned(
              left: MediaQuery.of(context).size.width * positions[index].dx,
              top: MediaQuery.of(context).size.height * positions[index].dy + _animations[index].value,
              child:  Opacity(
                opacity: 0.5 + (0.5 * _controllers[index].value),
                child: Transform.rotate(
                  angle: _controllers[index].value * math.pi,
                  child: Text(
                    particles[index],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}