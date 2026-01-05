import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/vocabulary_service.dart';
import '../models/word.dart';
import '../utils/app_theme.dart';

class LearningTestScreen extends StatefulWidget {
  const LearningTestScreen({Key? key}) : super(key: key);

  @override
  State<LearningTestScreen> createState() => _LearningTestScreenState();
}

class _LearningTestScreenState extends State<LearningTestScreen> {
  final VocabularyService _vocabService = VocabularyService();
  final TextEditingController _searchController = TextEditingController();

  List<Word> _searchResults = [];
  Word? _dailyWord;
  bool _isLoading = false;
  String _recognizedText = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    print('🎬 LearningTestScreen: Starting initialization...');

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await _vocabService.initialize();
      print('✅ LearningTestScreen: VocabService initialized');

      _dailyWord = await _vocabService.getDailyWord();
      print('📅 LearningTestScreen:  Daily word = ${_dailyWord?. japanese ??  "null"}');

      if (_dailyWord == null) {
        setState(() => _errorMessage = 'Could not load daily word.  Check internet connection.');
        print('⚠️ LearningTestScreen: Daily word is null');
      } else {
        print('✅ LearningTestScreen: Daily word loaded successfully');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error initializing:  $e');
      print('❌ LearningTestScreen:  Initialization error: $e');
    } finally {
      setState(() => _isLoading = false);
      print('🏁 LearningTestScreen:  Initialization complete');
    }
  }

  Future<void> _refreshDailyWord() async {
    print('🔄 LearningTestScreen: Refreshing daily word...');

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Force un nouveau mot en effaçant la date
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('daily_word_date');
      print('🗑️ LearningTestScreen: Cleared daily word date');

      _dailyWord = await _vocabService. getDailyWord();

      if (_dailyWord == null) {
        setState(() => _errorMessage = 'Could not load daily word');
        print('❌ LearningTestScreen: Failed to get new daily word');
      } else {
        print('✅ LearningTestScreen: Daily word refreshed:  ${_dailyWord!.japanese}');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error refreshing: $e');
      print('❌ LearningTestScreen:  Refresh error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchWord() async {
    if (_searchController.text.isEmpty) return;

    print('🔍 LearningTestScreen: Searching for "${_searchController.text}"');

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _searchResults = [];
    });

    try {
      _searchResults = await _vocabService. searchWord(_searchController.text);

      if (_searchResults.isEmpty) {
        setState(() => _errorMessage = 'No results found for "${_searchController.text}"');
        print('⚠️ LearningTestScreen: No results found');
      } else {
        print('✅ LearningTestScreen: Found ${_searchResults. length} results');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Search error: $e');
      print('❌ LearningTestScreen: Search error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _startListening() async {
    await _vocabService.stt.startListeningJapanese(
      onResult: (text) {
        setState(() => _recognizedText = text);
      },
    );
    setState(() {});
  }

  Future<void> _stopListening() async {
    await _vocabService. stt.stopListening();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
            child: SafeArea(
              child: Column(
                  children: [
              // Custom App Bar
              Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    '📚 Dictionary & Learning',
                    style: AppTheme.headingStyle,
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      // Error message
                      if (_errorMessage.isNotEmpty)
                  Container(
                  padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: AppTheme.smallRadius,
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),

            // Daily Word Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration:  BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end:  Alignment.bottomRight,
                  colors: [Color(0xFFFFF9C4), Color(0xFFFFE082)],
                ),
                borderRadius: AppTheme.mediumRadius,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '📚 ',
                        style:  TextStyle(fontSize: 24),
                      ),
                      Text(
                        'Daily Word',
                        style: AppTheme.subheadingStyle,
                      ),
                      const Spacer(),
                      // Bouton refresh
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _isLoading ? null : _refreshDailyWord,
                        tooltip: 'Get new word',
                        color: AppTheme.primaryColor,
                      ),
                      if (_isLoading && _dailyWord == null)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_dailyWord != null) ...[
                    Text(
                      _dailyWord!.japanese,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight:  FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _dailyWord!.reading,
                      style: TextStyle(
                        fontSize:  20,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _dailyWord!.englishMeanings.join(', '),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F5D75),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () =>
                              _vocabService.pronounceJapanese(_dailyWord!.japanese),
                          icon: const Icon(Icons.volume_up),
                          label: const Text('🇯🇵 Japanese'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed:  () => _vocabService
                              .pronounceEnglish(_dailyWord!.englishMeanings. first),
                          icon: const Icon(Icons.volume_up),
                          label: const Text('🇬🇧 English'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_dailyWord! .isCommon)
                      Chip(
                        label: const Text('Common Word'),
                        backgroundColor: Colors.green[100],
                        avatar: const Icon(Icons.star, size: 16),
                      ),
                  ] else if (! _isLoading)
                    Column(
                      children: [
                        const Text(
                          'Could not load daily word.',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton. icon(
                          onPressed: _refreshDailyWord,
                          icon: const Icon(Icons. refresh),
                          label:  const Text('Try Again'),
                          style:  ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Search Section
            Text(
              '🔍 Search Dictionary',
              style: AppTheme.subheadingStyle,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search word (Japanese or English)',
                hintText: 'Try:  犬, cat, hello, こんにちは',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: AppTheme.smallRadius,
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons. search),
                  onPressed:  _searchWord,
                ),
              ),
              onSubmitted: (_) => _searchWord(),
            ),

            const SizedBox(height: 16),

            // Speech Recognition Card (disabled)
            Container(
              width: double. infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: AppTheme.smallRadius,
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                children: [
                  const Text(
                    '🎤 Speech Recognition',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _recognizedText. isEmpty
                        ? 'Coming soon!  (Feature disabled)'
                        : _recognizedText,
                    style:  const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: null, // Disabled
                    icon: const Icon(Icons.mic_off),
                    label: const Text('Not Available'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      disabledBackgroundColor: Colors. grey,
                      disabledForegroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Search Results
            if (_isLoading)
        const Center(
    child:  Padding(
    padding: EdgeInsets.all(32.0),
    child: CircularProgressIndicator(),
    ),
    )
    else if (_searchResults.isNotEmpty) ...[
    Text(
    'Search Results (${_searchResults.length})',
    style: AppTheme.subheadingStyle,
    ),
    const SizedBox(height: 12),
    ..._searchResults.take(10).map((word) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: AppTheme.smallRadius,
    boxShadow: AppTheme.cardShadow,
    ),
    child:  ListTile(
    contentPadding: const EdgeInsets.all(16),
    title: Text(
    '${word.japanese} (${word.reading})',
    style: const TextStyle(
    fontSize: 18,
    fontWeight:  FontWeight.bold,
    ),
    ),
    subtitle:  Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(
    word.englishMeanings.join(', '),
    style: TextStyle(color: Colors.grey[600]),
    ),
    ),
    trailing: IconButton(
    icon: const Icon(Icons. volume_up, color: AppTheme.primaryColor),
    onPressed: () =>
    _vocabService.pronounceJapanese(word.japanese),
    ),
    onTap: () {
    _showWordDetails(word);
    },
    ),
    )),
    ],
    ],
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }

  void _showWordDetails(Word word) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(word.japanese),
        content: SingleChildScrollView(
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reading: ${word.reading}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                'Meanings: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...word.englishMeanings. map((meaning) => Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Text('• $meaning'),
              )),
              const SizedBox(height: 12),
              if (word.isCommon)
                Chip(
                  label: const Text('Common Word'),
                  backgroundColor: Colors.green[100],
                  avatar: const Icon(Icons.star, size: 16),
                ),
              if (word.jlptLevel. isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child:  Chip(
                    label: Text('JLPT:  ${word.jlptLevel. join(", ")}'),
                    backgroundColor:  Colors.blue[100],
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton. icon(
            onPressed: () {
              _vocabService.pronounceJapanese(word.japanese);
            },
            icon: const Icon(Icons.volume_up),
            label: const Text('Pronounce'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _vocabService.dispose();
    _searchController.dispose();
    super.dispose();
  }
}