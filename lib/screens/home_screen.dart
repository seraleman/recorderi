import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/card_set_provider.dart';
import '../providers/flashcard_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_layout.dart';
import '../utils/adaptive_dialogs.dart';
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
              ? ResponsiveCenter(
                maxWidth: MaxWidths.card,
                child: Center(
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: paddingSmall),
                      Text(
                        'Tap + to create your first set',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : ResponsiveCenter(
                maxWidth: MaxWidths.content,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Padding(
                      padding: EdgeInsets.all(
                        context.isMobile ? paddingMedium : paddingLarge,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Card Sets',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: paddingSmall),
                          Text(
                            '${sets.length} ${sets.length == 1 ? 'set' : 'sets'} available',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    // Grid/List
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final columns = getResponsiveColumns(context);
                          final spacing = getResponsiveSpacing(context);

                          if (columns == 1) {
                            // Mobile: use ListView
                            return ListView.builder(
                              padding: EdgeInsets.all(spacing),
                              itemCount: sets.length,
                              itemBuilder: (context, index) {
                                final set = sets[index];
                                return Card(
                                  margin: EdgeInsets.only(bottom: spacing),
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
                                        final cards = ref.watch(
                                          flashcardProvider(set.id),
                                        );
                                        final learned =
                                            cards
                                                .where((c) => c.isLearned)
                                                .length;
                                        return Text(
                                          '${cards.length} cards • $learned learned',
                                        );
                                      },
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed:
                                          () => _showDeleteDialog(
                                            context,
                                            ref,
                                            set.id,
                                          ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  CardSetScreen(setId: set.id),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }

                          // Tablet/Desktop: use GridView with max extent to prevent overflow
                          return GridView.builder(
                            padding: EdgeInsets.all(spacing),
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 400,
                                  crossAxisSpacing: spacing,
                                  mainAxisSpacing: spacing,
                                  mainAxisExtent: 100,
                                ),
                            itemCount: sets.length,
                            itemBuilder: (context, index) {
                              final set = sets[index];
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                CardSetScreen(setId: set.id),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      paddingMedium,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Color(set.color),
                                          radius: 24,
                                          child: Text(
                                            set.name[0].toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: paddingMedium),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                set.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              const SizedBox(height: 4),
                                              Consumer(
                                                builder: (context, ref, _) {
                                                  final cards = ref.watch(
                                                    flashcardProvider(set.id),
                                                  );
                                                  final learned =
                                                      cards
                                                          .where(
                                                            (c) => c.isLearned,
                                                          )
                                                          .length;
                                                  return Text(
                                                    '${cards.length} cards · $learned learned',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          tooltip: 'Delete set',
                                          onPressed:
                                              () => _showDeleteDialog(
                                                context,
                                                ref,
                                                set.id,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, ref),
        icon: const Icon(Icons.add),
        label: context.isMobile ? const Text('') : const Text('New Set'),
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final result = await showAdaptiveInputDialog(
      context: context,
      title: 'New Card Set',
      label: 'Set name',
      hint: 'e.g., Math, History',
      cancelText: 'Cancel',
      confirmText: 'Create',
    );

    if (result != null && result.isNotEmpty) {
      ref.read(cardSetProvider.notifier).createSet(result);
    }
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    String setId,
  ) async {
    await showAdaptiveConfirmDialog(
      context: context,
      title: 'Delete Set',
      content: 'Are you sure? This will delete all cards in this set.',
      cancelText: 'Cancel',
      confirmText: 'Delete',
      isDestructive: true,
      onConfirm: () {
        ref.read(cardSetProvider.notifier).deleteSet(setId);
      },
    );
  }
}
