import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/word.dart';

class DictionaryService {
  static const String _baseUrl = 'https://jisho.org/api/v1/search/words';

  // Chercher un mot
  Future<List<Word>> searchWord(String query) async {
    if (query.trim().isEmpty) {
      print('Query is empty');
      return [];
    }

    try {
      print('Searching for: $query');
      final encodedQuery = Uri.encodeComponent(query);
      final url = Uri.parse('$_baseUrl?keyword=$encodedQuery');

      print('Request URL: $url');

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['data'] as List? ;

        if (results == null || results.isEmpty) {
          print('No results found for:  $query');
          return [];
        }

        print('Found ${results.length} results');

        final words = results.map((json) {
          try {
            return Word.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            print('Error parsing individual word: $e');
            return null;
          }
        }).whereType<Word>().toList();

        return words;
      } else {
        throw Exception('Failed to search word:  ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching word: $e');
      return [];
    }
  }

  // Obtenir un mot aléatoire pour le "mot du jour"
  Future<Word? > getRandomWord({String? jlptLevel}) async {
    try {
      // Liste de mots communs pour débutants
      final commonWords = [
        'こんにちは', // bonjour
        'ありがとう', // merci
        'さようなら', // au revoir
        '犬',         // chien
        '猫',         // chat
        '食べる',     // manger
        '飲む',       // boire
        '行く',       // aller
        '来る',       // venir
        '見る',       // voir
        '本',         // livre
        '水',         // eau
        '学校',       // école
        '家',         // maison
        '友達',       // ami
        '愛',         // amour
        '時間',       // temps
        '人',         // personne
        '日本',       // Japon
        '音楽',       // musique
      ];

      commonWords.shuffle();
      final randomWord = commonWords.first;

      print('Getting random word: $randomWord');
      final results = await searchWord(randomWord);

      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      print('Error getting random word: $e');
      return null;
    }
  }

  // Obtenir des mots par catégorie
  Future<List<Word>> getWordsByCategory(String category) async {
    final categoryMap = {
      'food': '食べ物',
      'animals': '動物',
      'colors': '色',
      'numbers': '数字',
      'greetings': '挨拶',
      'family': '家族',
      'body': '体',
      'weather': '天気',
    };

    final query = categoryMap[category] ?? category;
    return searchWord(query);
  }
}