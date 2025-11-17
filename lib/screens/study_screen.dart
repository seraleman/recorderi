import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/flashcard_provider.dart';
import '../services/database_service.dart';
import '../models/flashcard.dart';
import '../utils/constants.dart';

class StudyScreen extends ConsumerStatefulWidget {
  final String setId;

  const StudyScreen({super.key, required this.setId});

  @override
  ConsumerState<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends ConsumerState<StudyScreen> {
  List<Flashcard> _studyQueue = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _isRandomMode = true;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() {
    final allCards = DatabaseService.getCardsBySet(widget.setId);
    _studyQueue = allCards.where((c) => !c.isLearned).toList();

    if (_studyQueue.isEmpty) {
      _studyQueue = allCards;
    }

    if (_isRandomMode) {
      _studyQueue.shuffle();
    }

    setState(() {});
  }

  void _toggleMode() {
    setState(() {
      _isRandomMode = !_isRandomMode;
      _currentIndex = 0;
      _showAnswer = false;
      _loadCards();
    });
  }

  void _flipCard() {
    // Only allow flipping when showing question
    if (!_showAnswer) {
      setState(() {
        _showAnswer = true;
      });
    }
  }

  Future<void> _markKnown() async {
    if (_studyQueue.isEmpty) return;

    final card = _studyQueue[_currentIndex];
    await markAsLearned(card.id, true);

    setState(() {
      _correctCount++;
      _studyQueue.removeAt(_currentIndex);
      _showAnswer = false;

      if (_currentIndex >= _studyQueue.length && _studyQueue.isNotEmpty) {
        _currentIndex = 0;
      }
    });

    if (_studyQueue.isEmpty) {
      _showCompletionDialog();
    }
  }

  void _markUnknown() {
    if (_studyQueue.isEmpty) return;

    setState(() {
      final card = _studyQueue.removeAt(_currentIndex);
      _studyQueue.add(card); // Add to end of queue
      _showAnswer = false;

      if (_currentIndex >= _studyQueue.length) {
        _currentIndex = 0;
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('🎉 Congratulations!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'You\'ve completed all cards in this study session!',
                ),
                const SizedBox(height: paddingMedium),
                Text(
                  'Learned: $_correctCount cards',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to CardSetScreen
                  ref.invalidate(flashcardProvider(widget.setId));
                },
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_studyQueue.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Study')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.green[400],
              ),
              const SizedBox(height: paddingLarge),
              Text(
                'All cards learned!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: paddingSmall),
              Text(
                'Great job! 🎉',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: paddingLarge),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.invalidate(flashcardProvider(widget.setId));
                },
                child: const Text('Back to Cards'),
              ),
            ],
          ),
        ),
      );
    }

    final currentCard = _studyQueue[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Card ${_currentIndex + 1}/${_studyQueue.length}'),
        actions: [
          Chip(
            label: Text(
              '$_correctCount learned',
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: Colors.green[100],
          ),
          const SizedBox(width: paddingSmall),
        ],
      ),
      body: Column(
        children: [
          // Toggle mode button
          Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: SwitchListTile(
              title: Text(_isRandomMode ? '🔀 Random Mode' : '📋 Ordered Mode'),
              value: _isRandomMode,
              onChanged: (value) => _toggleMode(),
            ),
          ),

          // Card display
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(paddingLarge),
                child: GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Card(
                      key: ValueKey(_showAnswer),
                      elevation: 8,
                      color:
                          _showAnswer
                              ? Colors.green[50]
                              : Theme.of(context).cardColor,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(paddingLarge * 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _showAnswer ? 'Answer' : 'Question',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: paddingLarge),
                            Text(
                              _showAnswer
                                  ? currentCard.answer
                                  : currentCard.question,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (!_showAnswer) ...[
                              const SizedBox(height: paddingLarge),
                              Text(
                                'Tap to reveal answer',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Action buttons (only visible after showing answer)
          if (_showAnswer)
            Padding(
              padding: const EdgeInsets.all(paddingLarge),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _markUnknown,
                      icon: const Icon(Icons.close),
                      label: const Text('Don\'t Know'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.all(paddingMedium),
                      ),
                    ),
                  ),
                  const SizedBox(width: paddingMedium),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _markKnown,
                      icon: const Icon(Icons.check),
                      label: const Text('I Know It'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.all(paddingMedium),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
