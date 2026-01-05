import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();

  String _currentLanguage = 'ja-JP'; // Japonais par défaut

  TTSService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage(_currentLanguage);
    await _flutterTts. setSpeechRate(0.5); // Vitesse (0.0 - 1.0)
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    // Vérifier les langues disponibles
    final languages = await _flutterTts.getLanguages;
    print('Available languages: $languages');
  }

  // Parler en japonais
  Future<void> speakJapanese(String text) async {
    await _flutterTts.setLanguage('ja-JP');
    await _flutterTts.speak(text);
  }

  // Parler en anglais
  Future<void> speakEnglish(String text) async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts. speak(text);
  }

  // Parler dans la langue courante
  Future<void> speak(String text, {String? language}) async {
    if (language != null) {
      await _flutterTts. setLanguage(language);
    }
    await _flutterTts.speak(text);
  }

  // Arrêter
  Future<void> stop() async {
    await _flutterTts.stop();
  }

  // Changer la vitesse
  Future<void> setSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  // Définir la langue par défaut
  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
    _flutterTts.setLanguage(languageCode);
  }

  // Obtenir les voix disponibles
  Future<List<dynamic>> getVoices() async {
    return await _flutterTts. getVoices;
  }

  void dispose() {
    _flutterTts.stop();
  }
}