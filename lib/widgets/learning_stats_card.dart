import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class LearningStatsCard extends StatelessWidget {
  final int wordsLearned;
  final int correctAnswers;
  final double accuracy;

  const LearningStatsCard({
    Key? key,
    required this. wordsLearned,
    required this.correctAnswers,
    required this.accuracy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6B4CE6),
            Color(0xFF9D4EDD),
          ],
        ),
        borderRadius: AppTheme.mediumRadius,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:  [
          _buildStat('📚', 'Words', wordsLearned. toString()),
          _buildDivider(),
          _buildStat('✅', 'Correct', correctAnswers.toString()),
          _buildDivider(),
          _buildStat('📊', 'Accuracy', '${(accuracy * 100).toInt()}%'),
        ],
      ),
    );
  }

  Widget _buildStat(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color:  Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white30,
    );
  }
}