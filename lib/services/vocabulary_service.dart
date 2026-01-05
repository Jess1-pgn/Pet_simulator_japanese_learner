import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/word.dart';
import 'dictionary_service.dart';
import 'tts_service.dart';
import 'stt_service.dart';

class VocabularyService {
  final DictionaryService _dictionaryService = DictionaryService();
  final TTSService _ttsService = TTSService();
  final STTService _sttService = STTService();

  List<Word> _savedWords = [];
  Word? _dailyWord;

  List<Word> get savedWords => _savedWords;
  Word? get dailyWord => _dailyWord;

  TTSService get tts => _ttsService;
  STTService get stt => _sttService;

  // Initialiser
  Future<void> initialize() async {
    print('🚀 VocabularyService:  Starting initialization.. .');

    try {
      await _loadSavedWords();
      print('✅ VocabularyService: Saved words loaded');

      await _loadDailyWord();
      print('✅ VocabularyService:   Daily word loaded');

      await _sttService.initialize();
      print('✅ VocabularyService: STT initialized');

      print('🎉 VocabularyService:  Initialization complete!');
    } catch (e) {
      print('❌ VocabularyService:  Initialization error: $e');
      rethrow;
    }
  }

  // Chercher un mot
  Future<List<Word>> searchWord(String query) async {
    print('🔍 VocabularyService: Searching for "$query"');
    return await _dictionaryService.searchWord(query);
  }

  // Obtenir le mot du jour
  Future<Word? > getDailyWord() async {
    print('📅 VocabularyService: Getting daily word...');

    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toString().split(' ')[0];
      final lastUpdate = prefs.getString('daily_word_date');

      print('📅 Today: $today');
      print('📅 Last update: $lastUpdate');

      // Si c'est un nouveau jour, obtenir un nouveau mot
      if (lastUpdate != today) {
        print('🆕 Getting new daily word...');
        _dailyWord = await _dictionaryService.getRandomWord();

        if (_dailyWord != null) {
          print('✅ Got new daily word: ${_dailyWord! .japanese}');
          await prefs.setString('daily_word', json.encode(_dailyWord!. toJson()));
          await prefs.setString('daily_word_date', today);
          print('💾 Saved daily word to storage');
        } else {
          print('❌ Failed to get new daily word');
        }
      } else {
        print('📖 Loading saved daily word...');
        // Charger le mot sauvegardé
        final savedWord = prefs.getString('daily_word');
        if (savedWord != null) {
          try {
            _dailyWord = Word.fromJson(json.decode(savedWord));
            print('✅ Loaded saved daily word: ${_dailyWord!.japanese}');
          } catch (e) {
            print('❌ Error parsing saved word: $e');
            // Si erreur, obtenir un nouveau mot
            _dailyWord = await _dictionaryService.getRandomWord();
          }
        } else {
          print('⚠️ No saved word found, getting new one...');
          _dailyWord = await _dictionaryService.getRandomWord();
        }
      }

      return _dailyWord;
    } catch (e) {
      print('❌ VocabularyService: Error getting daily word:  $e');
      return null;
    }
  }

  // Sauvegarder un mot
  Future<void> saveWord(Word word) async {
    if (! _savedWords.any((w) => w.japanese == word.japanese)) {
      _savedWords.add(word);
      await _saveToDisk();
    }
  }

  // Supprimer un mot
  Future<void> removeWord(Word word) async {
    _savedWords.removeWhere((w) => w.japanese == word.japanese);
    await _saveToDisk();
  }

  // Prononcer un mot en japonais
  Future<void> pronounceJapanese(String text) async {
    await _ttsService.speakJapanese(text);
  }

  // Prononcer en anglais
  Future<void> pronounceEnglish(String text) async {
    await _ttsService.speakEnglish(text);
  }

  // Charger les mots sauvegardés
  Future<void> _loadSavedWords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('saved_words');

      if (savedData != null) {
        final List<dynamic> decoded = json.decode(savedData);
        _savedWords = decoded. map((json) => Word.fromJson(json)).toList();
        print('📚 Loaded ${_savedWords.length} saved words');
      } else {
        print('📚 No saved words found');
      }
    } catch (e) {
      print('❌ Error loading saved words: $e');
    }
  }

  // Charger le mot du jour
  Future<void> _loadDailyWord() async {
    print('📖 VocabularyService: Loading daily word...');
    await getDailyWord();
  }

  // Sauvegarder sur disque
  Future<void> _saveToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = json.encode(_savedWords. map((w) => w.toJson()).toList());
      await prefs.setString('saved_words', encoded);
      print('💾 Saved ${_savedWords.length} words to disk');
    } catch (e) {
      print('❌ Error saving to disk: $e');
    }
  }

  void dispose() {
    _ttsService.dispose();
    _sttService.dispose();
  }
}