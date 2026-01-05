class Word {
  final String japanese;
  final String reading;
  final String romaji;
  final List<String> englishMeanings;
  final List<String> examples;
  final bool isCommon;
  final List<String> jlptLevel;

  Word({
    required this.japanese,
    required this.reading,
    required this.romaji,
    required this.englishMeanings,
    this.examples = const [],
    this.isCommon = false,
    this.jlptLevel = const [],
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    try {
      // Si c'est déjà notre format simplifié (depuis SharedPreferences)
      if (json. containsKey('japanese') && json['japanese'] is String) {
        return Word(
          japanese: json['japanese'] as String,
          reading: json['reading'] as String,
          romaji: json['romaji'] as String,
          englishMeanings: List<String>.from(json['englishMeanings'] as List),
          examples: json['examples'] != null
              ? List<String>.from(json['examples'] as List)
              : [],
          isCommon: json['isCommon'] as bool?  ?? false,
          jlptLevel: json['jlptLevel'] != null
              ? List<String>.from(json['jlptLevel'] as List)
              : [],
        );
      }

      // Sinon, c'est le format Jisho API
      final japaneseList = json['japanese'] as List? ;
      final japanese = japaneseList != null && japaneseList.isNotEmpty
          ? japaneseList[0] as Map<String, dynamic>
          :  <String, dynamic>{};

      final sensesList = json['senses'] as List?;
      final senses = sensesList ??  [];

      List<String> meanings = [];
      for (var sense in senses) {
        if (sense['english_definitions'] != null) {
          final defs = sense['english_definitions'] as List;
          meanings.addAll(defs. map((e) => e.toString()));
        }
      }

      if (meanings.isEmpty) {
        meanings = ['No definition available'];
      }

      final wordText = japanese['word']?.toString() ??
          japanese['reading']?.toString() ??
          'Unknown';
      final readingText = japanese['reading']?. toString() ?? wordText;

      return Word(
        japanese: wordText,
        reading: readingText,
        romaji: readingText,
        englishMeanings: meanings,
        isCommon: json['is_common'] as bool? ?? false,
        jlptLevel:  (json['jlpt'] as List?)?.map((e) => e.toString()).toList() ?? [],
      );
    } catch (e) {
      print('❌ Word.fromJson error: $e');
      print('JSON was: $json');
      return Word(
        japanese: 'Error',
        reading: 'Error',
        romaji: 'Error',
        englishMeanings:  ['Error parsing word:  $e'],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'japanese': japanese,
      'reading': reading,
      'romaji': romaji,
      'englishMeanings': englishMeanings,
      'examples': examples,
      'isCommon': isCommon,
      'jlptLevel': jlptLevel,
    };
  }
}