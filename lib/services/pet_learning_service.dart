import '../models/word.dart';
import '../models/learning_session.dart';
import 'vocabulary_service.dart';
import 'dart:math';

class PetLearningService {
  final VocabularyService _vocabService;
  LearningSession?  _currentSession;

  PetLearningService(this._vocabService);

  LearningSession? get currentSession => _currentSession;

  // Phrases que le pet peut dire selon son état
  final Map<String, List<String>> petPhrases = {
    'hungry_jp': [
      'お腹が空いた',  // onaka ga suita - j'ai faim
      '何か食べたい',  // nanika tabetai - je veux manger quelque chose
      'ご飯ちょうだい', // gohan choudai - donne-moi à manger
    ],
    'hungry_en': [
      "I'm hungry! ",
      "I want to eat!",
      "Feed me please!",
    ],
    'happy_jp': [
      'ありがとう! ',    // arigatou - merci
      '嬉しい!',       // ureshii - content
      '美味しい!',     // oishii - délicieux
    ],
    'happy_en': [
      "Thank you!",
      "I'm happy!",
      "Delicious!",
    ],
    'sleepy_jp': [
      '眠い',          // nemui - fatigué
      '寝たい',        // netai - je veux dormir
      'おやすみ',      // oyasumi - bonne nuit
    ],
    'sleepy_en': [
      "I'm sleepy",
      "I want to sleep",
      "Good night",
    ],
    'learning_jp': [
      '勉強しよう! ',   // benkyou shiyou - étudions!
      '教えて!',       // oshiete - apprends-moi!
      '一緒に学ぼう!', // issho ni manabou - apprenons ensemble!
    ],
    'learning_en': [
      "Let's study!",
      "Teach me!",
      "Let's learn together!",
    ],
  };

  // Obtenir une phrase aléatoire
  String getRandomPhrase(String category) {
    final phrases = petPhrases[category] ?? ['... '];
    return phrases[Random().nextInt(phrases.length)];
  }

  // Créer une session de nourrissage
  Future<LearningSession> startFeedingSession(Difficulty difficulty) async {
    final foodWords = await _vocabService.searchWord('食べ物'); // nourriture

    _currentSession = LearningSession(
      activity: LearningActivity.feeding,
      difficulty: difficulty,
      words: foodWords. take(5).toList(),
    );

    return _currentSession! ;
  }

  // Liste d'aliments pour le jeu
  List<FoodItem> getFoodItems() {
    return [
      FoodItem(nameJapanese: 'りんご', nameEnglish:  'Apple', emoji: '🍎'),
      FoodItem(nameJapanese: 'バナナ', nameEnglish: 'Banana', emoji:  '🍌'),
      FoodItem(nameJapanese:  '水', nameEnglish: 'Water', emoji: '💧'),
      FoodItem(nameJapanese: 'パン', nameEnglish: 'Bread', emoji: '🍞'),
      FoodItem(nameJapanese: '魚', nameEnglish: 'Fish', emoji: '🐟'),
      FoodItem(nameJapanese: '肉', nameEnglish:  'Meat', emoji: '🍖'),
      FoodItem(nameJapanese: 'ご飯', nameEnglish: 'Rice', emoji: '🍚'),
      FoodItem(nameJapanese: '牛乳', nameEnglish: 'Milk', emoji:  '🥛'),
      FoodItem(nameJapanese:  'お茶', nameEnglish:  'Tea', emoji: '🍵'),
      FoodItem(nameJapanese: 'ケーキ', nameEnglish: 'Cake', emoji:  '🍰'),
    ];
  }

  // Obtenir des aliments aléatoires pour un quiz
  List<FoodItem> getRandomFoodQuiz(int count) {
    final allFood = getFoodItems()..shuffle();
    return allFood.take(count).toList();
  }

  // Vérifier la réponse
  bool checkAnswer(String userAnswer, String correctAnswer) {
    return userAnswer.toLowerCase() == correctAnswer.toLowerCase();
  }

  // Calculer la récompense
  Map<String, double> calculateReward(bool isCorrect) {
    if (isCorrect) {
      return {
        'hunger':  -15.0,     // Réduit la faim
    'happiness': 20.0,   // Augmente le bonheur
    'energy': 5.0,       // Augmente l'énergie
    };
    } else {
    return {
    'hunger': -5.0,
    'happiness': -10.0,
    'energy': 0.0,
    };
    }
  }
}