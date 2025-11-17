import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/card_set_provider.dart';
import '../providers/flashcard_provider.dart';
import '../utils/constants.dart';
import 'card_set_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sets = ref.watch(cardSetProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordari'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            },
          ),
        ],
      ),
      body:
          sets.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.library_books_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: paddingLarge),
                    Text(
                      'No card sets yet',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: paddingSmall),
                    Text(
                      'Tap + to create your first set',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(paddingMedium),
                itemCount: sets.length,
                itemBuilder: (context, index) {
                  final set = sets[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: paddingMedium),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(set.color),
                        child: Text(
                          set.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(set.name),
                      subtitle: Consumer(
                        builder: (context, ref, _) {
                          final cards = ref.watch(flashcardProvider(set.id));
                          final learned =
                              cards.where((c) => c.isLearned).length;
                          return Text(
                            '${cards.length} cards • $learned learned',
                          );
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed:
                            () => _showDeleteDialog(context, ref, set.id),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CardSetScreen(setId: set.id),
                          ),
                        );
                      },
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

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('New Card Set'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Set name',
                hintText: 'e.g., Math, History',
              ),
              autofocus: true,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  ref.read(cardSetProvider.notifier).createSet(value.trim());
                  Navigator.pop(context);
                }
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    ref
                        .read(cardSetProvider.notifier)
                        .createSet(controller.text.trim());
                    Navigator.pop(context);
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String setId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Set'),
            content: const Text(
              'Are you sure? This will delete all cards in this set.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  ref.read(cardSetProvider.notifier).deleteSet(setId);
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
