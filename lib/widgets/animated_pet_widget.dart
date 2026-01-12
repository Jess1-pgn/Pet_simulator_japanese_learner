import 'package:flutter/material.dart';
import '../models/pet_state.dart';
import '../utils/app_theme.dart';

class AnimatedPetWidget extends StatefulWidget {
  final PetState petState;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const AnimatedPetWidget({
    Key? key,
    required this.petState,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  State<AnimatedPetWidget> createState() => _AnimatedPetWidgetState();
}

class _AnimatedPetWidgetState extends State<AnimatedPetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds:  500),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve:  Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _bounceController.forward().then((_) => _bounceController.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onLongPress: widget. onLongPress,
      child: ScaleTransition(
        scale:  _bounceAnimation,
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                _getPetColor(widget.petState.mood).withOpacity(0.3),
                _getPetColor(widget.petState.mood).withOpacity(0.1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _getPetColor(widget.petState.mood).withOpacity(0.4),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pet emoji
                Text(
                  _getPetEmoji(widget.petState.mood),
                  style: const TextStyle(fontSize: 120),
                ),

                // Animation d'action
                if (widget.petState.currentAnimation != PetAnimation.idle)
                  _buildActionAnimation(widget.petState.currentAnimation),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionAnimation(PetAnimation animation) {
    String emoji = '';
    switch (animation) {
      case PetAnimation.eating:
        emoji = '🍴';
        break;
      case PetAnimation.sleeping:     // ← OK maintenant
        emoji = '💤';
        break;
      case PetAnimation.happy:
        emoji = '✨';
        break;
      case PetAnimation.annoyed:      // ← OK maintenant
        emoji = '💢';
        break;
      case PetAnimation.playing:
        emoji = '🎮';
        break;
      default:
        emoji = '';
    }

    return Positioned(
      top: 20,
      right: 20,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, -20 * value),
            child: Opacity(
              opacity: 1.0 - value,
              child: Text(
                emoji,
                style: TextStyle(fontSize: 40 * (1 + value)),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getPetColor(PetMood mood) {
    switch (mood) {
      case PetMood.happy:
        return AppTheme.petMoodColors['happy']!;
      case PetMood.sad:
        return AppTheme.petMoodColors['sad']!;
      case PetMood.hungry:
        return AppTheme.petMoodColors['hungry']!;
      case PetMood.sleepy:
        return AppTheme. petMoodColors['sleepy']!;
      case PetMood.annoyed:
        return AppTheme.petMoodColors['annoyed']!;
      default:
        return AppTheme. petMoodColors['neutral']! ;
    }
  }

  String _getPetEmoji(PetMood mood) {
    switch (mood) {
      case PetMood. happy:
        return '😻';
      case PetMood.sad:
        return '😿';
      case PetMood.hungry:
        return '😾';
      case PetMood.sleepy:
        return '😼';
      case PetMood.annoyed:
        return '🙀';
      default:
        return '😐';
    }
  }
}