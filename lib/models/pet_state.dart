import 'package:flutter/foundation.dart';

class PetState extends ChangeNotifier {
  // Pet happiness (0-100) - combinaison de tout
  double _happiness = 80.0;

  // Pet mood
  PetMood _mood = PetMood.happy;

  // Animation state
  PetAnimation _currentAnimation = PetAnimation.idle;

  // Learning stats
  int _wordsLearned = 0;
  int _correctAnswers = 0;
  int _totalQuizzes = 0;
  int _totalPoints = 0;

  // Getters
  double get happiness => _happiness;
  PetMood get mood => _mood;
  PetAnimation get currentAnimation => _currentAnimation;
  int get wordsLearned => _wordsLearned;
  int get correctAnswers => _correctAnswers;
  int get totalQuizzes => _totalQuizzes;
  int get totalPoints => _totalPoints;
  double get learningAccuracy => _totalQuizzes > 0 ? _correctAnswers / _totalQuizzes : 0.0;

  // Feed the pet
  void feed() {
    _happiness = (_happiness + 15).clamp(0, 100);
    _totalPoints += 5;
    _updateMood();
    _triggerAnimation(PetAnimation.eating);
    notifyListeners();
  }

  // Feed with learning reward
  void feedWithReward(Map<String, double> rewards) {
    _happiness = (_happiness + rewards['happiness']! ).clamp(0, 100);
    _updateMood();
    _triggerAnimation(PetAnimation.eating);
    notifyListeners();
  }

  // Record learning progress
  void recordQuizResult(bool isCorrect) {
    _totalQuizzes++;
    if (isCorrect) {
      _correctAnswers++;
      _wordsLearned++;
      _happiness = (_happiness + 5).clamp(0, 100);
      _totalPoints += 10;
    } else {
      _happiness = (_happiness - 2).clamp(0, 100);
    }
    _updateMood();
    notifyListeners();
  }

  // Pet the pet
  void pet() {
    _happiness = (_happiness + 10).clamp(0, 100);
    _totalPoints += 3;
    _updateMood();
    _triggerAnimation(PetAnimation.happy);
    notifyListeners();
  }

  // Sleep
  void sleep() {
    _happiness = (_happiness + 20).clamp(0, 100);
    _totalPoints += 5;
    _updateMood();
    _triggerAnimation(PetAnimation.sleeping);  // ← Maintenant ça existe
    notifyListeners();
  }

  // Play with pet
  void play() {
    _happiness = (_happiness + 12).clamp(0, 100);
    _totalPoints += 5;
    _updateMood();
    _triggerAnimation(PetAnimation.playing);
    notifyListeners();
  }

  // Update needs over time (decrease happiness slowly)
  void updateNeeds() {
    _happiness = (_happiness - 0.5).clamp(0, 100);
    _updateMood();
    notifyListeners();
  }

  void _updateMood() {
    if (_happiness > 70) {
      _mood = PetMood.happy;
    } else if (_happiness > 50) {
      _mood = PetMood.neutral;
    } else if (_happiness > 30) {
      _mood = PetMood.sad;
    } else {
      _mood = PetMood.depressed;
    }
  }

  void _triggerAnimation(PetAnimation animation) {
    _currentAnimation = animation;
    notifyListeners();

    // Reset to idle after animation
    Future.delayed(const Duration(seconds: 2), () {
      _currentAnimation = PetAnimation.idle;
      notifyListeners();
    });
  }
}

enum PetMood {
  happy,
  neutral,
  sad,
  depressed,
  hungry,
  sleepy,
  annoyed,
}


// ⭐ AJOUTE sleeping et annoyed ici
enum PetAnimation {
  idle,
  happy,
  eating,
  sleeping,    // ← AJOUTE CECI
  annoyed,     // ← AJOUTE CECI
  playing,
}