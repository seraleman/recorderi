import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/flashcard_provider.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';
import '../utils/responsive_layout.dart';
import '../utils/adaptive_dialogs.dart';
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
              : ResponsiveCenter(
                maxWidth: MaxWidths.card,
                child: ListView.builder(
                  padding: EdgeInsets.all(getResponsiveSpacing(context)),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return Card(
                      margin: EdgeInsets.only(
                        bottom: getResponsiveSpacing(context),
                      ),
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
                                  () =>
                                      _showDeleteDialog(context, ref, card.id),
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
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCardDialog(BuildContext context, String question, String answer) {
    showAdaptiveInfoDialog(
      context: context,
      title: 'Card Details',
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
      buttonText: 'Close',
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final result = await showAdaptiveMultiInputDialog(
      context: context,
      title: 'New Card',
      field1Label: 'Question',
      field1Hint: 'What is...?',
      field2Label: 'Answer',
      field2Hint: 'The answer is...',
      cancelText: 'Cancel',
      confirmText: 'Create',
      field2MaxLines: 3,
    );

    if (result != null && context.mounted) {
      await createCard(setId, result['field1']!, result['field2']!);
      if (context.mounted) {
        ref.invalidate(flashcardProvider(setId));
      }
    }
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    String cardId,
  ) async {
    final card = DatabaseService.getCard(cardId);
    if (card == null) return;

    final result = await showAdaptiveMultiInputDialog(
      context: context,
      title: 'Edit Card',
      field1Label: 'Question',
      field1Hint: 'What is...?',
      field1InitialValue: card.question,
      field2Label: 'Answer',
      field2Hint: 'The answer is...',
      field2InitialValue: card.answer,
      cancelText: 'Cancel',
      confirmText: 'Save',
      field2MaxLines: 3,
    );

    if (result != null && context.mounted) {
      await updateCard(cardId, result['field1']!, result['field2']!);
      if (context.mounted) {
        ref.invalidate(flashcardProvider(setId));
      }
    }
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    String cardId,
  ) async {
    await showAdaptiveConfirmDialog(
      context: context,
      title: 'Delete Card',
      content: 'Are you sure you want to delete this card?',
      cancelText: 'Cancel',
      confirmText: 'Delete',
      isDestructive: true,
      onConfirm: () async {
        await deleteCard(cardId);
        if (context.mounted) {
          ref.invalidate(flashcardProvider(setId));
        }
      },
    );
  }
}
