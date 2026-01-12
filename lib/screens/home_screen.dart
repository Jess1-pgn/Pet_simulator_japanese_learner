import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math' as math;
import '../models/pet_state.dart';
import '../models/pet_profile.dart';
import '../services/audio_service.dart';
import '../services/pet_profile_service.dart';
import '../services/greeting_service.dart';
import '../widgets/capsule_button.dart';
import '../widgets/circular_happiness_bar.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  final PetProfileService _profileService = PetProfileService();
  final GreetingService _greetingService = GreetingService();

  Timer? _needsTimer;
  PetProfile? _petProfile;
  bool _hasGreeted = false;

  // Animation controllers
  late AnimationController _wobbleController;
  late Animation<double> _wobbleAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late List<AnimationController> _particleControllers;
  late List<Animation<Offset>> _particleAnimations;

  @override
  void initState() {
    super.initState();
    _loadPetProfile();

    // Update needs every 30 seconds
    _needsTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      context.read<PetState>().updateNeeds();
    });

    // Wobble animation (chat qui balance)
    _wobbleController = AnimationController(
      duration:  const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _wobbleAnimation = Tween<double>(begin: -0.087, end: 0.087).animate(
      CurvedAnimation(parent: _wobbleController, curve:  Curves.easeInOut),
    );

    // Pulse animation (streak badge)
    _pulseController = AnimationController(
      duration:  const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Particle animations (4 particules flottantes)
    _particleControllers = List.generate(4, (index) {
      return AnimationController(
        duration:  const Duration(seconds: 4),
        vsync: this,
      )..repeat(reverse: true);
    });

    _particleAnimations = _particleControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 0),
        end: const Offset(0, -0.05),
      ).animate(CurvedAnimation(parent: controller, curve: Curves. easeInOut));
    }).toList();

    // Stagger particle animations
    for (int i = 0; i < _particleControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 500), () {
        if (mounted) _particleControllers[i].forward();
      });
    }
  }

  Future<void> _loadPetProfile() async {
    final profile = await _profileService.loadProfile();
    setState(() {
      _petProfile = profile;
    });

    // Dire bonjour en japonais et anglais
    if (! _hasGreeted && mounted) {
      _hasGreeted = true;
      await Future.delayed(const Duration(milliseconds: 500));
      _greetingService.sayBilingualGreeting();
    }
  }

  @override
  void dispose() {
    _needsTimer?. cancel();
    _wobbleController.dispose();
    _pulseController.dispose();
    for (var controller in _particleControllers) {
      controller.dispose();
    }
    _audioService.dispose();
    _greetingService.dispose();
    super.dispose();
  }

  String _getPetEmoji(PetMood mood) {
    switch (mood) {
      case PetMood.happy:
        return '😸';
      case PetMood.neutral:
        return '😺';
      case PetMood. sad:
        return '😿';
      case PetMood.depressed:
        return '😭';
      default:
        return '😺';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.phoneGradient,
        ),
        child: SafeArea(
          child: Consumer<PetState>(
            builder: (context, petState, child) {
              return Stack(
                  children: [
              // Main content
              Column(
              children: [
              // Status bar
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(
              TimeOfDay.now().format(context),
              style: const TextStyle(
              fontSize: 12,
              color: Colors. white,
              fontWeight: FontWeight.w600,
              ),
              ),
              const Text(
              '📶 🔋',
              style: TextStyle(fontSize: 12),
              ),
              ],
              ),
              ),

              // Main area
              Expanded(
              child:  Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
              children: [
              // Header
              Column(
              children: [
              Text(
              '🌸 ${_petProfile?.name ?? "Luna"} 🌸',
              style: AppTheme.titleStyle,
              ),
              const SizedBox(height:  10),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              _buildStatBadge('💗 ${petState.happiness. toInt()}%'),
              const SizedBox(width: 20),
              _buildStatBadge('🏆 ${petState.totalPoints}'),
              ],
              ),
              ],
              ),

              const SizedBox(height: 30),

              // Center stage avec chat et barre circulaire
              SizedBox(
              width:  280,
              height: 280,
              child: Stack(
              alignment: Alignment.center,
              children: [
              // Barre de bonheur circulaire
              CircularHappinessBar(
              value: petState.happiness,
              size: 250,
              ),

              // Chat au centre
              AnimatedBuilder(
              animation: _wobbleAnimation,
              builder: (context, child) {
              return Transform.rotate(
              angle: _wobbleAnimation.value,
              child: GestureDetector(
              onTap: () {
              petState.pet();
              _audioService.playSoundEffect('happy');
              },
              child: Container(
              width: 180,
              height: 180,
              decoration:  BoxDecoration(
              color: Colors.white. withOpacity(0.4),
              shape: BoxShape.circle,
              border: Border.all(
              color: Colors.white. withOpacity(0.6),
              width:  4,
              ),
              boxShadow: [
              BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 50,
              offset: const Offset(0, 15),
              ),
              ],
              ),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
              _getPetEmoji(petState.mood),
              style:  TextStyle(
              fontSize: 80,
              shadows: [
              Shadow(
              color:  Colors.black.withOpacity(0.25),
              offset: const Offset(0, 8),
              blurRadius: 20,
              ),
              ],
              ),
              ),
              const SizedBox(height: 5),
              Text(
              _petProfile?.name ?? 'Luna',
              style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight. w900,
              shadows: [
              Shadow(
              color: Colors.black26,
              offset:  Offset(0, 2),
              blurRadius:  8,
              ),
              ],
              ),
              ),
              ],
              ),
              ),
              ),
              );
              },
              ),
              ],
              ),
              ),

              const Spacer(),

              // Action buttons (4 capsules)
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              CapsuleButton(
              icon: '🍖',
              label: 'Nourrir',
              onPressed: () {
              petState. feed();
              _audioService.playSoundEffect('eat');
              },
              ),
              const SizedBox(width: 10),
              CapsuleButton(
              icon:  '💕',
              label: 'Caresser',
              onPressed:  () {
              petState.pet();
              _audioService.playSoundEffect('happy');
              },
              ),
              const SizedBox(width: 10),
              CapsuleButton(
              icon:  '📖',
              label: 'Apprendre',
              onPressed:  () {
              // Navigate to learn tab
              DefaultTabController.of(context).animateTo(1);
              },
              ),
              const SizedBox(width: 10),
              CapsuleButton(
              icon: '🎯',
              label: 'Jouer',
              onPressed: () {
              petState.play();
              _audioService.playSoundEffect('play');
              // TODO: Navigate to game
              },
              ),
              ],
              ),

              const SizedBox(height: 20),
              ],
              ),
              ),
              ),
              ],
              ),

              // Floating particles
              ..._buildParticles(),

              // Streak badge
              Positioned(
              top: 10,
              right: 10,
              child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.35),
              borderRadius: BorderRadius.circular(20),
              border: Border. all(
              color: Colors.white.withOpacity(0.6),
              width: 2,
              ),
              ),
              child: Text(
              '🔥 ${_petProfile?. daysAlive ?? 0} jours',
              style:  const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors. white,
              shadows: [
              Shadow(
              color: Colors.black26,
              offset:  Offset(0, 2),
              blurRadius: 6,
              ),
              ],
              ),
              ),
              ),
              ),
              ),
              ],
              );
              },
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(String text) {
    return Container(
      padding: const EdgeInsets. symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Widget> _buildParticles() {
    final particles = ['✨', '⭐', '💫', '🌟'];
    final positions = [
      const Offset(0.1, 0.15),   // Top left
      const Offset(0.85, 0.3),   // Top right
      const Offset(0.2, 0.65),   // Bottom left
      const Offset(0.9, 0.5),    // Right middle
    ];

    return List.generate(4, (index) {
      return SlideTransition(
        position:  _particleAnimations[index],
        child:  Positioned(
          left: MediaQuery.of(context).size.width * positions[index].dx,
          top: MediaQuery. of(context).size.height * positions[index].dy,
          child: AnimatedBuilder(
            animation: _particleControllers[index],
            builder: (context, child) {
              return Transform.rotate(
                angle: _particleControllers[index].value * math.pi,
                child: Opacity(
                  opacity: 0.5 + (0.5 * _particleControllers[index].value),
                  child: Text(
                    particles[index],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}