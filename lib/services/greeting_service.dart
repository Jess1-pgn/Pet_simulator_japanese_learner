import 'tts_service.dart';
import 'dart:math';

class GreetingService {
  final TTSService _ttsService = TTSService();

  final List<Map<String, String>> greetings = [
    {
      'japanese': 'こんにちは',
      'english': 'Hello',
    },
    {
      'japanese': 'おはよう',
      'english': 'Good morning',
    },
    {
      'japanese': 'こんばんは',
      'english': 'Good evening',
    },
    {
      'japanese': '元気? ',
      'english': 'How are you?',
    },
    {
      'japanese':  'また会えて嬉しい',
      'english': 'Nice to see you again',
    },
  ];

  // Dire bonjour en japonais puis en anglais
  Future<void> sayBilingualGreeting() async {
    final greeting = greetings[Random().nextInt(greetings.length)];

    // Dit en japonais d'abord
    await _ttsService.speakJapanese(greeting['japanese']!);

    // Attend 1 seconde
    await Future. delayed(const Duration(seconds: 1));

    // Puis en anglais
    await _ttsService.speakEnglish(greeting['english']!);
  }

  void dispose() {
    _ttsService.dispose();
  }
}