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
      print('📅 LearningTestScreen: Daily word = ${_dailyWord?.japanese ??  "null"}');

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
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('daily_word_date');
      print('🗑️ LearningTestScreen: Cleared daily word date');

      _dailyWord = await _vocabService.getDailyWord();

      if (_dailyWord == null) {
        setState(() => _errorMessage = 'Could not load daily word');
        print('❌ LearningTestScreen:  Failed to get new daily word');
      } else {
        print('✅ LearningTestScreen: Daily word refreshed:  ${_dailyWord! .japanese}');
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

    print('🔍 LearningTestScreen:  Searching for "${_searchController.text}"');

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _searchResults = [];
    });

    try {
      _searchResults = await _vocabService.searchWord(_searchController.text);

      if (_searchResults. isEmpty) {
        setState(() => _errorMessage = 'No results found for "${_searchController.text}"');
        print('⚠️ LearningTestScreen: No results found');
      } else {
        print('✅ LearningTestScreen: Found ${_searchResults.length} results');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Search error: $e');
      print('❌ LearningTestScreen: Search error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient:  AppTheme.phoneGradient,
            ),
            child: SafeArea(
              child: Column(
                  children: [
              // Custom App Bar avec style glassmorphism
              Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: AppTheme.glassDecoration,
                child: Row(
                  children: [
                    const Text(
                      '📚',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Dictionary',
                      style: AppTheme.titleStyle. copyWith(fontSize: 22),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment. start,
                      children: [
                      // Error message
                      if (_errorMessage.isNotEmpty)
                  Container(
                  padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.red. withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Daily Word Card avec glassmorphism
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white. withOpacity(0.25),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius:  30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '✨ ',
                        style: TextStyle(fontSize: 24),
                      ),
                      const Text(
                        'Daily Word',
                        style: TextStyle(
                          fontSize:  20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      // Bouton refresh
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon:  const Icon(Icons.refresh),
                          onPressed: _isLoading ? null : _refreshDailyWord,
                          tooltip: 'Get new word',
                          color: Colors.white,
                        ),
                      ),
                      if (_isLoading && _dailyWord == null)
                        const Padding(
                          padding:  EdgeInsets.only(left: 10),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child:  CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_dailyWord != null) ...[
                    Text(
                      _dailyWord!.japanese,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight:  FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height:  8),
                    Text(
                      _dailyWord!.reading,
                      style: const TextStyle(
                        fontSize:  20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius:  BorderRadius.circular(15),
                      ),
                      child: Text(
                        _dailyWord!.englishMeanings.join(', '),
                        style:  const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height:  20),
                    Row(
                      children: [
                        Expanded(
                          child:  ElevatedButton.icon(
                            onPressed: () => _vocabService
                                .pronounceJapanese(_dailyWord!.japanese),
                            icon: const Icon(Icons.volume_up, size: 20),
                            label: const Text('🇯🇵'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white. withOpacity(0.3),
                              foregroundColor:  Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width:  10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _vocabService. pronounceEnglish(
                                _dailyWord!.englishMeanings. first),
                            icon: const Icon(Icons.volume_up, size: 20),
                            label: const Text('🇬🇧'),
                            style: ElevatedButton. styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.3),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_dailyWord!.isCommon)
                      Padding(
                        padding:  const EdgeInsets.only(top: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.3),
                            borderRadius:  BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.amber. withOpacity(0.6),
                              width: 2,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              SizedBox(width: 5),
                              Text(
                                'Common Word',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ] else if (! _isLoading)
                    Column(
                      children: [
                        const Text(
                          'Could not load daily word.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _refreshDailyWord,
                          icon: const Icon(Icons. refresh),
                          label: const Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.white.withOpacity(0.3),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius. circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Search Section
            const Text(
              '🔍 Search Dictionary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset:  Offset(0, 2),
                    blurRadius:  8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Search word',
                labelStyle: TextStyle(color: Colors.white. withOpacity(0.8)),
                hintText: 'Try:  犬, cat, hello, こんにちは',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: Colors. white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:  BorderSide(
                    color: Colors.white. withOpacity(0.5),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:  BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: _searchWord,
                ),
              ),
              onSubmitted: (_) => _searchWord(),
            ),

            const SizedBox(height: 24),

            // Search Results
            if (_isLoading)
        const Center(
    child:  Padding(
    padding: EdgeInsets.all(32.0),
    child: CircularProgressIndicator(
    color: Colors.white,
    ),
    ),
    )
    else if (_searchResults.isNotEmpty) ...[
    Text(
    'Results (${_searchResults.length})',
    style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    ),
    ),
    const SizedBox(height: 12),
    ..._searchResults.take(10).map(
    (word) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
    color: Colors.white. withOpacity(0.4),
    width: 2,
    ),
    ),
    child: ListTile(
    contentPadding: const EdgeInsets.all(16),
    title: Text(
    '${word.japanese} (${word.reading})',
    style: const TextStyle(
    fontSize: 18,
    fontWeight:  FontWeight.bold,
    color: Colors.white,
    ),
    ),
    subtitle:  Padding(
    padding: const EdgeInsets.only(top: 8),
    child:  Text(
    word. englishMeanings.join(', '),
    style: TextStyle(
    color:  Colors.white.withOpacity(0.8),
    ),
    ),
    ),
    trailing: IconButton(
    icon: const Icon(Icons.volume_up, color: Colors.white),
    onPressed: () =>
    _vocabService.pronounceJapanese(word.japanese),
    ),
    onTap: () => _showWordDetails(word),
    ),
    ),
    ),
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
        backgroundColor: const Color(0xFFA29BFE),
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(20),
        ),
        title: Text(
          word.japanese,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reading: ${word.reading}',
                style: const TextStyle(fontSize: 16, color: Colors. white),
              ),
              const SizedBox(height: 12),
              const Text(
                'Meanings: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              ...word.englishMeanings.map(
                    (meaning) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text(
                    '• $meaning',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height:  12),
              if (word.isCommon)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical:  6),
                  decoration:  BoxDecoration(
                    color: Colors.amber.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: const Row(
                    mainAxisSize:  MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 5),
                      Text(
                        'Common Word',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (word.jlptLevel. isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Text(
                      'JLPT:  ${word.jlptLevel. join(", ")}',
                      style:  const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton. icon(
            onPressed: () => _vocabService.pronounceJapanese(word.japanese),
            icon: const Icon(Icons.volume_up, color: Colors.white),
            label: const Text('Pronounce', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
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