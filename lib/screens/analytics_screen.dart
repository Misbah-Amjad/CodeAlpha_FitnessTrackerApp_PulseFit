import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/fitness_state.dart';
import '../theme/app_colors.dart';
import '../widgets/weekly_bar_chart.dart';
import '../widgets/category_distribution_chart.dart';
import '../widgets/weight_trend_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  final FitnessState state;

  const AnalyticsScreen({
    super.key,
    required this.state,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedTimeframeIndex = 0; // 0: 7 Days, 1: 30 Days

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final summaries = _selectedTimeframeIndex == 0
        ? widget.state.weeklySummaries
        : widget.state.monthlySummaries;

    final totalCalories = summaries.fold(0, (s, d) => s + d.calories);
    final totalSteps = summaries.fold(0, (s, d) => s + d.steps);
    final totalActiveMins = summaries.fold(0, (s, d) => s + d.activeMinutes);
    final totalDist = summaries.fold(0.0, (s, d) => s + d.distanceKm);
    final totalWorkouts = summaries.fold(0, (s, d) => s + d.workoutCount);

    final avgCalories = summaries.isNotEmpty ? (totalCalories / summaries.length).round() : 0;
    final avgSteps = summaries.isNotEmpty ? (totalSteps / summaries.length).round() : 0;
    final avgActiveMins = summaries.isNotEmpty ? (totalActiveMins / summaries.length).round() : 0;

    // Personal bests
    int maxCaloriesInOneSession = 0;
    int maxDurationInOneSession = 0;
    String topWorkoutTitle = 'None';
    for (var w in widget.state.workouts) {
      if (w.caloriesBurned > maxCaloriesInOneSession) {
        maxCaloriesInOneSession = w.caloriesBurned;
        topWorkoutTitle = w.title;
      }
      if (w.durationMinutes > maxDurationInOneSession) {
        maxDurationInOneSession = w.durationMinutes;
      }
    }

    int maxStepsInOneDay = 0;
    for (var m in widget.state.dailyMetrics.values) {
      if (m.steps > maxStepsInOneDay) {
        maxStepsInOneDay = m.steps;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Progress'),
        actions: [
          // Timeframe toggle
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardHover : AppColors.lightCardHover,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTimeframeBtn('7 Days', 0, isDark),
                _buildTimeframeBtn('30 Days', 1, isDark),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Overview Hero
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _selectedTimeframeIndex == 0 ? 'Weekly Performance' : 'Monthly Performance',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$totalWorkouts Workouts',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildHeroStat(
                          label: 'Total Burned',
                          value: NumberFormat('#,###').format(totalCalories),
                          unit: 'kcal',
                          color: AppColors.coral,
                          icon: Icons.local_fire_department_rounded,
                        ),
                      ),
                      Container(height: 40, width: 1, color: AppColors.darkBorder),
                      Expanded(
                        child: _buildHeroStat(
                          label: 'Total Steps',
                          value: NumberFormat('#,###').format(totalSteps),
                          unit: 'steps',
                          color: AppColors.primary,
                          icon: Icons.directions_walk_rounded,
                        ),
                      ),
                      Container(height: 40, width: 1, color: AppColors.darkBorder),
                      Expanded(
                        child: _buildHeroStat(
                          label: 'Active Time',
                          value: '$totalActiveMins',
                          unit: 'mins',
                          color: AppColors.purple,
                          icon: Icons.timer_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Bar Chart
            WeeklyBarChartWidget(summaries: summaries),
            const SizedBox(height: 20),

            // Workout Category Distribution Donut Chart
            CategoryDistributionChart(
              distribution: widget.state.categoryCalorieDistribution,
            ),
            const SizedBox(height: 20),

            // Weight Progress Line Chart
            WeightTrendChartWidget(
              summaries: summaries,
              targetWeightKg: widget.state.goals.targetWeightKg,
            ),
            const SizedBox(height: 20),

            // Daily Averages Breakdown
            Text(
              'Daily Averages',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  _buildAverageRow('Average Daily Calories', '$avgCalories kcal', Icons.local_fire_department_rounded, AppColors.coral, isDark),
                  Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, height: 20),
                  _buildAverageRow('Average Daily Steps', '${NumberFormat('#,###').format(avgSteps)} steps', Icons.directions_walk_rounded, AppColors.primary, isDark),
                  Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, height: 20),
                  _buildAverageRow('Average Daily Active Time', '$avgActiveMins mins', Icons.timer_rounded, AppColors.purple, isDark),
                  Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, height: 20),
                  _buildAverageRow('Total Distance Covered', '${totalDist.toStringAsFixed(1)} km', Icons.route_rounded, AppColors.cyan, isDark),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Personal Records & Highlights
            Text(
              'Personal Records & Highlights',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildPRCard(
                    title: 'Peak Single Burn',
                    value: '$maxCaloriesInOneSession kcal',
                    subtitle: topWorkoutTitle,
                    icon: Icons.emoji_events_rounded,
                    color: AppColors.accent,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPRCard(
                    title: 'Most Steps in a Day',
                    value: NumberFormat('#,###').format(maxStepsInOneDay),
                    subtitle: 'Daily Milestone',
                    icon: Icons.military_tech_rounded,
                    color: AppColors.primary,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildPRCard(
                    title: 'Longest Workout',
                    value: '$maxDurationInOneSession mins',
                    subtitle: 'Endurance record',
                    icon: Icons.timer_outlined,
                    color: AppColors.purple,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPRCard(
                    title: 'Active Streak',
                    value: '${widget.state.currentStreak} Days',
                    subtitle: 'Consistency Score',
                    icon: Icons.local_fire_department_rounded,
                    color: AppColors.coral,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeBtn(String label, int index, bool isDark) {
    final isSelected = _selectedTimeframeIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedTimeframeIndex = index),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroStat({
    required String label,
    required String value,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white60,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAverageRow(String label, String value, IconData icon, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPRCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
