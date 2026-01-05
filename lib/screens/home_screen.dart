import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/pet_state.dart';
import '../services/audio_service.dart';
import '../services/vocabulary_service.dart';
import '../widgets/needs_meter.dart';
import '../widgets/animated_pet_widget.dart';
import '../widgets/action_button.dart';
import '../widgets/learning_stats_card.dart';
import '../widgets/learning_interaction_widget.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key?  key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioService _audioService = AudioService();
  final VocabularyService _vocabService = VocabularyService();
  Timer? _needsTimer;
  bool _showLearningMode = false;

  @override
  void initState() {
    super.initState();
    _vocabService.initialize();

    _needsTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      context.read<PetState>().updateNeeds();
    });
  }

  @override
  void dispose() {
    _needsTimer?.cancel();
    _audioService.dispose();
    _vocabService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient:  AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child:  Consumer<PetState>(
            builder: (context, petState, child) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        80, // BottomNavigationBar height
                  ),
                  child: Column(
                    children:  [
                      // App Bar custom
                      Padding(
                        padding: const EdgeInsets. all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '🐱 My Language Pet',
                              style: AppTheme.headingStyle,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: AppTheme.smallRadius,
                                boxShadow: AppTheme.cardShadow,
                              ),
                              child:  Row(
                                children: [
                                  const Text('⚡', style: TextStyle(fontSize: 16)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Lvl ${(petState.wordsLearned / 10).floor() + 1}',
                                    style: AppTheme.bodyStyle. copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Learning stats
                      LearningStatsCard(
                        wordsLearned: petState. wordsLearned,
                        correctAnswers: petState. correctAnswers,
                        accuracy: petState.learningAccuracy,
                      ),

                      const SizedBox(height: 12),

                      // Needs meters
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: NeedsMeter(
                                label: 'Hunger',
                                value: 100 - petState.hunger,
                                color: AppTheme.hungerColor,
                                icon: Icons.restaurant,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: NeedsMeter(
                                label: 'Happy',
                                value: petState.happiness,
                                color: AppTheme.happinessColor,
                                icon:  Icons.favorite,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: NeedsMeter(
                                label: 'Energy',
                                value: petState.energy,
                                color: AppTheme.energyColor,
                                icon: Icons.bolt,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Pet display - Hauteur fixe au lieu de Expanded
                      SizedBox(
                        height:  280,
                        child: Center(
                          child: AnimatedPetWidget(
                            petState: petState,
                            onTap: () {
                              petState.pet();
                              _audioService.playSoundEffect('happy');
                            },
                            onLongPress: () {
                              petState.poke();
                              _audioService. playSoundEffect('annoyed');
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Learning interaction ou boutons
                      if (_showLearningMode)
                        Padding(
                          padding: const EdgeInsets. all(16.0),
                          child: LearningInteractionWidget(
                            vocabService: _vocabService,
                            onReward: (rewards) {
                              petState.feedWithReward(rewards);
                              petState.recordQuizResult(rewards['happiness']!  > 0);
                            },
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                            children: [
                              ActionButton(
                                icon: Icons.school,
                                label: 'Learn',
                                color: AppTheme. primaryColor,
                                isLarge: true,
                                onPressed: () {
                                  setState(() => _showLearningMode = true);
                                },
                              ),
                              ActionButton(
                                icon: Icons.restaurant_menu,
                                label: 'Feed',
                                color: AppTheme.hungerColor,
                                onPressed: () {
                                  petState.feed();
                                  _audioService.playSoundEffect('eat');
                                },
                              ),
                              ActionButton(
                                icon: Icons.bedtime,
                                label: 'Sleep',
                                color:  const Color(0xFF9C27B0),
                                onPressed:  () {
                                  petState.sleep();
                                  _audioService.playSoundEffect('sleep');
                                },
                              ),
                            ],
                          ),
                        ),

                      // Toggle button
                      if (_showLearningMode)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: TextButton. icon(
                            onPressed:  () => setState(() => _showLearningMode = false),
                            icon: const Icon(Icons. arrow_back),
                            label: const Text('Back'),
                            style: TextButton.styleFrom(
                              foregroundColor:  AppTheme.primaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}