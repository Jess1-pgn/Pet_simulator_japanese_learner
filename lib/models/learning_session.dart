import 'word.dart';
enum LearningActivity {
  feeding,     // Nourrir avec le bon mot
  dressUp,     // Habiller avec vocabulaire
  playing,     // Jouer avec quiz
  sleeping,    // Histoire du soir
}

enum Difficulty {
  beginner,      // Hiragana + Romaji
  intermediate,  // Kanji simple
  advanced,      // Kanji complexe
}

class LearningSession {
  final LearningActivity activity;
  final Difficulty difficulty;
  final List<Word> words;
  int correctAnswers = 0;
  int totalQuestions = 0;

  LearningSession({
    required this.activity,
    required this.difficulty,
    required this.words,
  });

  double get accuracy => totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;

  bool get isComplete => totalQuestions >= words.length;

  void recordAnswer(bool isCorrect) {
    totalQuestions++;
    if (isCorrect) correctAnswers++;
  }
}

class FoodItem {
  final String nameJapanese;
  final String nameEnglish;
  final String emoji;
  final int hungerRestore;

  FoodItem({
    required this.nameJapanese,
    required this.nameEnglish,
    required this.emoji,
    this.hungerRestore = 20,
  });
}