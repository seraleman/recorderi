import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/flashcard_provider.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';
import 'study_screen.dart';

class CardSetScreen extends ConsumerWidget {
  final String setId;

  const CardSetScreen({super.key, required this.setId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(flashcardProvider(setId));
    final set = DatabaseService.getSet(setId);

    return Scaffold(
      appBar: AppBar(
        title: Text(set?.name ?? 'Cards'),
        actions: [
          if (cards.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Study',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudyScreen(setId: setId),
                  ),
                );
              },
            ),
        ],
      ),
      body:
          cards.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.style_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: paddingLarge),
                    Text(
                      'No cards yet',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: paddingSmall),
                    Text(
                      'Tap + to create your first card',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(paddingMedium),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: paddingMedium),
                    child: ListTile(
                      title: Text(
                        card.question,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        card.answer,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (card.isLearned)
                            Icon(
                              Icons.check_circle,
                              color: Colors.green[600],
                              size: 20,
                            ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed:
                                () => _showEditDialog(context, ref, card.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed:
                                () => _showDeleteDialog(context, ref, card.id),
                          ),
                        ],
                      ),
                      onTap:
                          () => _showCardDialog(
                            context,
                            card.question,
                            card.answer,
                          ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCardDialog(BuildContext context, String question, String answer) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Card Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: paddingSmall),
                Text(question),
                const SizedBox(height: paddingMedium),
                Text(
                  'Answer:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: paddingSmall),
                Text(answer),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('New Card'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    labelText: 'Question',
                    hintText: 'What is...?',
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: paddingMedium),
                TextField(
                  controller: answerController,
                  decoration: const InputDecoration(
                    labelText: 'Answer',
                    hintText: 'The answer is...',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  if (questionController.text.trim().isNotEmpty &&
                      answerController.text.trim().isNotEmpty) {
                    await createCard(
                      setId,
                      questionController.text.trim(),
                      answerController.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                      ref.invalidate(flashcardProvider(setId));
                    }
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, String cardId) {
    final card = DatabaseService.getCard(cardId);
    if (card == null) return;

    final questionController = TextEditingController(text: card.question);
    final answerController = TextEditingController(text: card.answer);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Card'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(labelText: 'Question'),
                  autofocus: true,
                ),
                const SizedBox(height: paddingMedium),
                TextField(
                  controller: answerController,
                  decoration: const InputDecoration(labelText: 'Answer'),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  if (questionController.text.trim().isNotEmpty &&
                      answerController.text.trim().isNotEmpty) {
                    await updateCard(
                      cardId,
                      questionController.text.trim(),
                      answerController.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                      ref.invalidate(flashcardProvider(setId));
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String cardId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Card'),
            content: const Text('Are you sure you want to delete this card?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  await deleteCard(cardId);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ref.invalidate(flashcardProvider(setId));
                  }
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
