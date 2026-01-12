import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/pet_state.dart';
import 'services/pet_profile_service.dart';
import 'screens/pet_creation_screen.dart';
import 'screens/home_screen.dart';
import 'screens/learning_test_screen.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome. setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness. light, // Changé en light pour fond coloré
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PetState(),
      child: MaterialApp(
        title: 'Language Pet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // Utilise le thème depuis AppTheme
        home: const SplashScreen(), // Écran de démarrage
        routes: {
          '/home': (context) => const MainNavigator(),
          '/create-pet': (context) => const PetCreationScreen(),
        },
      ),
    );
  }
}

// Écran de splash qui vérifie si le pet existe
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PetProfileService _profileService = PetProfileService();

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    // Petit délai pour effet splash
    await Future.delayed(const Duration(seconds: 1));

    print('🔍 Checking if pet profile exists...');
    final hasProfile = await _profileService.hasProfile();

    if (!mounted) return;

    if (hasProfile) {
      print('✅ Pet profile found, going to home');
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      print('⚠️ No pet profile, going to creation screen');
      Navigator.of(context).pushReplacementNamed('/create-pet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.phoneGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: const Text(
                      '🐱',
                      style: TextStyle(fontSize: 100),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Language Pet',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors. white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius:  12,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Navigation principale avec bottom nav bar
class MainNavigator extends StatefulWidget {
  const MainNavigator({Key? key}) : super(key: key);

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const LearningTestScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment. bottomCenter,
            colors: [
              Colors.white.withOpacity(0.9),
              Colors.white,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items:  const [
            BottomNavigationBarItem(
              icon:  Icon(Icons.pets, size: 28),
              label: 'Pet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school, size: 28),
              label: 'Learn',
            ),
          ],
        ),
      ),
    );
  }
}