
class STTService {
  bool _isInitialized = false;
  bool _isListening = false;

  bool get isListening => _isListening;
  bool get isInitialized => _isInitialized;

  // Placeholder - à implémenter plus tard
  Future<bool> initialize() async {
    _isInitialized = true;
    print('STT Service:  Coming soon! ');
    return true;
  }

  Future<void> startListeningJapanese({
    required Function(String) onResult,
  }) async {
    _isListening = true;
    print('Listening Japanese:  Coming soon!');
    // Simulation
    await Future.delayed(const Duration(seconds: 2));
    onResult('こんにちは (simulé)');
  }

  Future<void> startListeningEnglish({
    required Function(String) onResult,
  }) async {
    _isListening = true;
    print('Listening English: Coming soon!');
    await Future.delayed(const Duration(seconds: 2));
    onResult('Hello (simulated)');
  }

  Future<void> stopListening() async {
    _isListening = false;
  }

  Future<List<dynamic>> getLocales() async {
    return [];
  }

  void dispose() {}
}