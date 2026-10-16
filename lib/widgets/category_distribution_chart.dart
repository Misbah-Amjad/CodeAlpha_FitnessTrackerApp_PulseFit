import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/activity_type.dart';
import '../theme/app_colors.dart';

class CategoryDistributionChart extends StatefulWidget {
  final Map<ActivityCategory, int> distribution;

  const CategoryDistributionChart({
    super.key,
    required this.distribution,
  });

  @override
  State<CategoryDistributionChart> createState() => _CategoryDistributionChartState();
}

class _CategoryDistributionChartState extends State<CategoryDistributionChart> {
  int _touchedIndex = -1;

  Color _getCategoryColor(ActivityCategory cat) {
    switch (cat) {
      case ActivityCategory.cardio:
        return AppColors.coral;
      case ActivityCategory.strength:
        return AppColors.purple;
      case ActivityCategory.flexibility:
        return AppColors.cyan;
      case ActivityCategory.sports:
        return AppColors.accent;
      case ActivityCategory.outdoor:
        return AppColors.primary;
    }
  }

  String _getCategoryName(ActivityCategory cat) {
    switch (cat) {
      case ActivityCategory.cardio:
        return 'Cardio';
      case ActivityCategory.strength:
        return 'Strength';
      case ActivityCategory.flexibility:
        return 'Flexibility';
      case ActivityCategory.sports:
        return 'Sports';
      case ActivityCategory.outdoor:
        return 'Outdoor';
    }
  }

  IconData _getCategoryIcon(ActivityCategory cat) {
    switch (cat) {
      case ActivityCategory.cardio:
        return Icons.directions_run_rounded;
      case ActivityCategory.strength:
        return Icons.fitness_center_rounded;
      case ActivityCategory.flexibility:
        return Icons.self_improvement_rounded;
      case ActivityCategory.sports:
        return Icons.sports_mma_rounded;
      case ActivityCategory.outdoor:
        return Icons.hiking_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalCalories = widget.distribution.values.fold(0, (sum, val) => sum + val);

    final entries = widget.distribution.entries
        .where((e) => e.value > 0)
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Calorie breakdown by workout category',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 20),
          if (totalCalories == 0 || entries.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No workout sessions recorded yet',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ),
            )
          else
            Row(
              children: [
                // Donut Chart
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 160,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    _touchedIndex = -1;
                                    return;
                                  }
                                  _touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 4,
                            centerSpaceRadius: 46,
                            sections: List.generate(entries.length, (i) {
                              final item = entries[i];
                              final isTouched = i == _touchedIndex;
                              final radius = isTouched ? 30.0 : 24.0;
                              final color = _getCategoryColor(item.key);

                              return PieChartSectionData(
                                color: color,
                                value: item.value.toDouble(),
                                title: '',
                                radius: radius,
                              );
                            }),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$totalCalories',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              'kcal total',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Category Legend
                Expanded(
                  flex: 6,
                  child: Column(
                    children: entries.map((e) {
                      final pct = ((e.value / totalCalories) * 100).toStringAsFixed(0);
                      final color = _getCategoryColor(e.key);
                      final name = _getCategoryName(e.key);
                      final icon = _getCategoryIcon(e.key);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(icon, size: 12, color: color),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ),
                            Text(
                              '$pct%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
