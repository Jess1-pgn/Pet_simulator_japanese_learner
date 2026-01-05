import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/pet_state.dart';
import 'screens/home_screen.dart';
import 'screens/learning_test_screen.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding. ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors. transparent,
      statusBarIconBrightness: Brightness. dark,
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
        theme: ThemeData(
          primaryColor: AppTheme.primaryColor,
          scaffoldBackgroundColor:  AppTheme.backgroundColor,
          useMaterial3: true,
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppTheme. primaryColor,
            brightness: Brightness.light,
          ),
        ),
        home: const MainNavigator(),
      ),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({Key?  key}) : super(key: key);

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
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors. grey,
          selectedFontSize: 12,
          unselectedFontSize:  12,
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