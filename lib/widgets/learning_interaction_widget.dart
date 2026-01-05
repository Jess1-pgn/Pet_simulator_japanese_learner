import 'package:flutter/material.dart';
import '../services/pet_learning_service.dart';
import '../services/vocabulary_service.dart';
import '../models/learning_session.dart';

class LearningInteractionWidget extends StatefulWidget {
  final VocabularyService vocabService;
  final Function(Map<String, double>) onReward;

  const LearningInteractionWidget({
    Key? key,
    required this.vocabService,
    required this.onReward,
  }) : super(key: key);

  @override
  State<LearningInteractionWidget> createState() => _LearningInteractionWidgetState();
}

class _LearningInteractionWidgetState extends State<LearningInteractionWidget> {
  late PetLearningService _petLearning;
  List<FoodItem> _currentQuiz = [];
  FoodItem? _correctAnswer;
  String _petMessage = '';
  bool _showResult = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _petLearning = PetLearningService(widget.vocabService);
    _startNewQuiz();
  }

  void _startNewQuiz() {
    setState(() {
      _currentQuiz = _petLearning.getRandomFoodQuiz(4);
      _correctAnswer = _currentQuiz. first;
      _petMessage = '${_petLearning.getRandomPhrase('hungry_jp')}\n${_correctAnswer! .nameJapanese}をちょうだい!';
      _showResult = false;
    });

    // Prononcer la demande
    widget.vocabService.pronounceJapanese(_correctAnswer!.nameJapanese);
  }

  void _handleFoodSelection(FoodItem selectedFood) {
    final isCorrect = selectedFood.nameJapanese == _correctAnswer! .nameJapanese;

    setState(() {
      _isCorrect = isCorrect;
      _showResult = true;

      if (isCorrect) {
        _petMessage = '${_petLearning.getRandomPhrase('happy_jp')}\n${_petLearning.getRandomPhrase('happy_en')}';
        widget.vocabService.pronounceJapanese(_petLearning.getRandomPhrase('happy_jp'));
      } else {
        _petMessage = '違うよ...  ${_correctAnswer!.nameJapanese} (${_correctAnswer!.nameEnglish})だよ';
        widget.vocabService. pronounceJapanese('違うよ');
      }
    });

    // Donner la récompense au pet
    final reward = _petLearning.calculateReward(isCorrect);
    widget.onReward(reward);

    // Prochain quiz après 2 secondes
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _startNewQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:  Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Message du pet
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _showResult
                  ? (_isCorrect ? Colors.green[100] : Colors.red[100])
                  : Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  '🐱',
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _petMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () {
                    if (_correctAnswer != null) {
                      widget.vocabService.pronounceJapanese(_correctAnswer!.nameJapanese);
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Options de nourriture
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing:  12,
              crossAxisSpacing:  12,
              childAspectRatio: 1.2,
            ),
            itemCount: _currentQuiz.length,
            itemBuilder: (context, index) {
              final food = _currentQuiz[index];
              final isCorrectChoice = food.nameJapanese == _correctAnswer?. nameJapanese;

              return InkWell(
                onTap: _showResult ? null : () => _handleFoodSelection(food),
                child: Container(
                  decoration: BoxDecoration(
                    color: _showResult && isCorrectChoice
                        ? Colors.green[200]
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _showResult && isCorrectChoice
                          ? Colors.green
                          : Colors. grey,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: [
                      Text(
                        food.emoji,
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        food.nameJapanese,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight. bold,
                        ),
                      ),
                      Text(
                        food.nameEnglish,
                        style:  TextStyle(
                          fontSize: 12,
                          color: Colors. grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}