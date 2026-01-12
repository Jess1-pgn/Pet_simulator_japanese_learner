import 'package:flutter/material.dart';
import '../models/word.dart';
import '../utils/app_theme.dart';

class TranslatorWidget extends StatelessWidget {
  final Word?  dailyWord;
  final VoidCallback onPronounceJapanese;
  final VoidCallback onPronounceEnglish;

  const TranslatorWidget({
    Key? key,
    required this.dailyWord,
    required this.onPronounceJapanese,
    required this.onPronounceEnglish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dailyWord == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment. bottomRight,
            colors: [Color(0xFFA8E6CF), Color(0xFFB4E7F7)],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFA8E6CF).withOpacity(0.4),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: onPronounceJapanese,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFA8E6CF), Color(0xFFB4E7F7)],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFA8E6CF).withOpacity(0.4),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Text(
                  '💬',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Daily Word',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D9596),
                  ),
                ),
              ],
            ),

            const SizedBox(height:  15),

            // Japanese
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors. white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Text('🇯🇵 ', style: TextStyle(fontSize: 20)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Text(
                          dailyWord! .japanese,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          dailyWord!.reading,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors. grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Color(0xFF2D9596)),
                    onPressed: onPronounceJapanese,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // English
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius:  BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Text('🇬🇧 ', style: TextStyle(fontSize: 20)),
                  Expanded(
                    child:  Text(
                      dailyWord! .englishMeanings. join(', '),
                      style:  const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Color(0xFFFF69B4)),
                    onPressed: onPronounceEnglish,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Hint
            const Text(
              '👆 Tap to practice',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF2D9596),
              ),
            ),
          ],
        ),
      ),
    );
  }
}