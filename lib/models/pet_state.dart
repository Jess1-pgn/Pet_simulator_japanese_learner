import 'package:flutter/foundation.dart';

class PetState extends ChangeNotifier {
  // Pet needs (0-100)
  double _hunger = 50.0;
  double _happiness = 50.0;
  double _energy = 50.0;

  // Pet mood
  PetMood _mood = PetMood.neutral;

  // Animation state
  PetAnimation _currentAnimation = PetAnimation.idle;

  // Learning stats (NOUVEAU)
  int _wordsLearned = 0;
  int _correctAnswers = 0;
  int _totalQuizzes = 0;

  // Getters
  double get hunger => _hunger;
  double get happiness => _happiness;
  double get energy => _energy;
  PetMood get mood => _mood;
  PetAnimation get currentAnimation => _currentAnimation;
  int get wordsLearned => _wordsLearned;
  int get correctAnswers => _correctAnswers;
  int get totalQuizzes => _totalQuizzes;
  double get learningAccuracy => _totalQuizzes > 0 ?  _correctAnswers / _totalQuizzes : 0.0;

  // Feed the pet
  void feed() {
    _hunger = (_hunger - 20).clamp(0, 100);
    _happiness = (_happiness + 10).clamp(0, 100);
    _updateMood();
    _triggerAnimation(PetAnimation.eating);
    notifyListeners();
  }

  // NOUVEAU: Feed with learning reward
  void feedWithReward(Map<String, double> rewards) {
    _hunger = (_hunger + rewards['hunger']!).clamp(0, 100);
    _happiness = (_happiness + rewards['happiness']!).clamp(0, 100);
    _energy = (_energy + rewards['energy']!).clamp(0, 100);
    _updateMood();
    _triggerAnimation(PetAnimation. eating);
    notifyListeners();
  }

  // NOUVEAU: Record learning progress
  void recordQuizResult(bool isCorrect) {
    _totalQuizzes++;
    if (isCorrect) {
      _correctAnswers++;
      _wordsLearned++;
    }
    notifyListeners();
  }

  // Pet the pet
  void pet() {
    _happiness = (_happiness + 15).clamp(0, 100);
    _updateMood();
    _triggerAnimation(PetAnimation.happy);
    notifyListeners();
  }

  // Poke the pet
  void poke() {
    _happiness = (_happiness - 5).clamp(0, 100);
    _updateMood();
    _triggerAnimation(PetAnimation.annoyed);
    notifyListeners();
  }

  // Sleep
  void sleep() {
    _energy = (_energy + 30).clamp(0, 100);
    _updateMood();
    _triggerAnimation(PetAnimation.sleeping);
    notifyListeners();
  }

  // Update needs over time
  void updateNeeds() {
    _hunger = (_hunger + 1).clamp(0, 100);
    _energy = (_energy - 0.5).clamp(0, 100);
    if (_hunger > 80 || _energy < 20) {
      _happiness = (_happiness - 0.5).clamp(0, 100);
    }
    _updateMood();
    notifyListeners();
  }

  void _updateMood() {
    if (_happiness > 70 && _hunger < 30 && _energy > 50) {
      _mood = PetMood.happy;
    } else if (_happiness < 30 || _hunger > 80) {
      _mood = PetMood.sad;
    } else if (_energy < 20) {
      _mood = PetMood.sleepy;
    } else if (_hunger > 60) {
      _mood = PetMood.hungry;
    } else {
      _mood = PetMood. neutral;
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
  sad,
  neutral,
  hungry,
  sleepy,
  annoyed,
}

enum PetAnimation {
  idle,
  happy,
  eating,
  sleeping,
  annoyed,
  playing,
}