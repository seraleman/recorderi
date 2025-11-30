import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stats_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_layout.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final progressBySet = stats.getProgressBySet();
    final globalProgress = stats.getGlobalProgress();
    final totalCards = stats.getTotalCards();
    final learnedCards = stats.getLearnedCards();

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body:
          totalCards == 0
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: paddingLarge),
                    Text(
                      'No statistics yet',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: paddingSmall),
                    Text(
                      'Create some cards and start studying!',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
              : ResponsiveCenter(
                maxWidth: MaxWidths.content,
                child: ListView(
                  padding: EdgeInsets.all(getResponsiveSpacing(context)),
                  children: [
                    // Global progress card
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(getResponsiveSpacing(context)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🎯 Overall Progress',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: getResponsiveSpacing(context)),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${(globalProgress * 100).toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          fontSize: context.isMobile ? 32 : 36,
                                          fontWeight: FontWeight.bold,
                                          color: appPrimaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: paddingSmall),
                                      Text(
                                        '$learnedCards / $totalCards cards learned',
                                        style: TextStyle(
                                          fontSize: context.isMobile ? 14 : 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: context.isMobile ? 70 : 80,
                                  height: context.isMobile ? 70 : 80,
                                  child: CircularProgressIndicator(
                                    value: globalProgress,
                                    strokeWidth: context.isMobile ? 6 : 8,
                                    backgroundColor: Colors.grey[200],
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          appPrimaryColor,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: getResponsiveSpacing(context)),

                    // Progress by set
                    Text(
                      'Progress by Set',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: getResponsiveSpacing(context)),

                    ...progressBySet.entries.map((entry) {
                      final data = entry.value;
                      return Card(
                        margin: EdgeInsets.only(
                          bottom: getResponsiveSpacing(context),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                            getResponsiveSpacing(context),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data.setName,
                                      style: TextStyle(
                                        fontSize: context.isMobile ? 16 : 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${data.learned}/${data.total}',
                                    style: TextStyle(
                                      fontSize: context.isMobile ? 14 : 16,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: paddingSmall),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: data.progress,
                                  minHeight: context.isMobile ? 10 : 12,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    data.progress >= 0.8
                                        ? Colors.green
                                        : data.progress >= 0.5
                                        ? Colors.orange
                                        : Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(height: paddingSmall),
                              Text(
                                '${(data.progress * 100).toStringAsFixed(0)}% completed',
                                style: TextStyle(
                                  fontSize: context.isMobile ? 12 : 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
    );
  }
}
