import 'package:flutter/material.dart';
import '../models/pet_profile.dart';
import '../services/pet_profile_service.dart';
import '../utils/app_theme.dart';

class PetCreationScreen extends StatefulWidget {
  const PetCreationScreen({Key?  key}) : super(key: key);

  @override
  State<PetCreationScreen> createState() => _PetCreationScreenState();
}

class _PetCreationScreenState extends State<PetCreationScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final PetProfileService _profileService = PetProfileService();
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration:  const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -20, end: 20).animate(
      CurvedAnimation(parent: _floatController, curve:  Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createPet() async {
    final name = _nameController.text. trim();

    if (name.isEmpty) {
      ScaffoldMessenger. of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name for your pet!  🐱'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name must be at least 2 characters! ✨'),
          backgroundColor: Colors. orange,
        ),
      );
      return;
    }

    final profile = PetProfile(
      name: name,
      createdAt: DateTime.now(),
    );

    await _profileService.saveProfile(profile);

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE5EC),
              Color(0xFFFFF0F5),
              Color(0xFFE6F3FF),
            ],
          ),
        ),
        child: SafeArea(
          child:  Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Titre
                const Text(
                  '🌸 Welcome!  🌸',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF69B4),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Create your language pet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF666666),
                  ),
                ),

                const SizedBox(height:  40),

                // Pet animé
                AnimatedBuilder(
                  animation:  _floatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFFFF176).withOpacity(0.3),
                              const Color(0xFFFFF176).withOpacity(0.1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFF176).withOpacity(0.4),
                              blurRadius:  40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '😸',
                            style: TextStyle(fontSize: 120),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Input pour le nom
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "What's your pet's name?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4F5D75),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller:  _nameController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF69B4),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Luna, Mochi, Yuki.. .',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: const Color(0xFFFF69B4).withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF69B4),
                              width: 2,
                            ),
                          ),
                        ),
                        maxLength: 15,
                        onSubmitted: (_) => _createPet(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Bouton créer
                SizedBox(
                  width:  double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _createPet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF69B4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                      shadowColor: const Color(0xFFFF69B4).withOpacity(0.5),
                    ),
                    child: const Text(
                      '✨ Create Pet ✨',
                      style:  TextStyle(
                        fontSize:  20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Your pet will help you learn Japanese!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}