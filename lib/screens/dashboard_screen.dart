import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/fitness_state.dart';
import '../theme/app_colors.dart';
import '../widgets/activity_ring.dart';
import '../widgets/metric_card.dart';
import '../widgets/weekly_bar_chart.dart';
import '../widgets/workout_card.dart';
import '../widgets/quick_log_sheet.dart';
import 'log_workout_screen.dart';

class DashboardScreen extends StatelessWidget {
  final FitnessState state;

  const DashboardScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = state.profile;
    final goals = state.goals;
    final isToday = state.selectedDateStr == state.todayStr;

    final workouts = state.workoutsForSelectedDate;
    final totalCalories = state.selectedDateWorkoutCalories;
    final totalSteps = state.selectedDateSteps;
    final totalActiveMins = state.selectedDateActiveMinutes;
    final totalWater = state.selectedDateWaterMl;
    final weight = state.selectedDateWeight ?? profile.currentWeightKg;
    final sleep = state.selectedDateSleep ?? 7.5;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // refresh trigger
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Top App Bar / Greeting
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: Text(
                          profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'A',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${profile.name.split(' ').first}! 👋',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Let\'s smash your fitness goals today',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Streak Flame Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF7A00), Color(0xFFFF3D00)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF3D00).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department_rounded, size: 18, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              '${state.currentStreak} Days',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Date Navigator Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left_rounded),
                          onPressed: () {
                            state.setSelectedDate(state.selectedDate.subtract(const Duration(days: 1)));
                          },
                        ),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: state.selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(const Duration(days: 1)),
                            );
                            if (picked != null) {
                              state.setSelectedDate(picked);
                            }
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month_rounded, size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                isToday
                                    ? 'Today, ${DateFormat('MMM d').format(state.selectedDate)}'
                                    : DateFormat('EEEE, MMM d').format(state.selectedDate),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right_rounded),
                          onPressed: isToday
                              ? null
                              : () {
                                  state.setSelectedDate(state.selectedDate.add(const Duration(days: 1)));
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Hero Activity Rings
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: ActivityRingWidget(
                    caloriesProgress: state.caloriesProgress,
                    stepsProgress: state.stepsProgress,
                    activeTimeProgress: state.activeTimeProgress,
                    waterProgress: state.waterProgress,
                    calories: totalCalories,
                    caloriesGoal: goals.dailyCaloriesGoal,
                    steps: totalSteps,
                    stepsGoal: goals.dailyStepsGoal,
                    activeMins: totalActiveMins,
                    activeMinsGoal: goals.dailyActiveMinutesGoal,
                    waterMl: totalWater,
                    waterGoal: goals.dailyWaterMlGoal,
                  ),
                ),
              ),

              // Quick Actions Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Log Actions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildQuickActionBtn(
                              context: context,
                              label: 'Log Workout',
                              icon: Icons.fitness_center_rounded,
                              color: AppColors.primary,
                              isDark: isDark,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LogWorkoutScreen(state: state),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            _buildQuickActionBtn(
                              context: context,
                              label: '+ Water',
                              icon: Icons.water_drop_rounded,
                              color: AppColors.cyan,
                              isDark: isDark,
                              onTap: () => QuickLogSheet.showWaterLogger(context, state),
                            ),
                            const SizedBox(width: 10),
                            _buildQuickActionBtn(
                              context: context,
                              label: 'Log Steps',
                              icon: Icons.directions_walk_rounded,
                              color: AppColors.primaryLight,
                              isDark: isDark,
                              onTap: () => QuickLogSheet.showStepsLogger(context, state),
                            ),
                            const SizedBox(width: 10),
                            _buildQuickActionBtn(
                              context: context,
                              label: 'Weight',
                              icon: Icons.scale_rounded,
                              color: AppColors.secondary,
                              isDark: isDark,
                              onTap: () => QuickLogSheet.showWeightLogger(context, state),
                            ),
                            const SizedBox(width: 10),
                            _buildQuickActionBtn(
                              context: context,
                              label: 'Sleep',
                              icon: Icons.bedtime_rounded,
                              color: AppColors.purple,
                              isDark: isDark,
                              onTap: () => QuickLogSheet.showSleepLogger(context, state),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Metric Cards Grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Metrics',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.15,
                        children: [
                          MetricCard(
                            title: 'Active Calories',
                            value: '$totalCalories',
                            unit: 'kcal',
                            subtitle: 'Goal: ${goals.dailyCaloriesGoal} kcal',
                            icon: Icons.local_fire_department_rounded,
                            accentColor: AppColors.coral,
                            progress: state.caloriesProgress,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LogWorkoutScreen(state: state),
                                ),
                              );
                            },
                          ),
                          MetricCard(
                            title: 'Steps Count',
                            value: NumberFormat('#,###').format(totalSteps),
                            unit: 'steps',
                            subtitle: 'Goal: ${NumberFormat('#,###').format(goals.dailyStepsGoal)}',
                            icon: Icons.directions_walk_rounded,
                            accentColor: AppColors.primary,
                            progress: state.stepsProgress,
                            quickAddLabel: 'Log',
                            onQuickAdd: () => QuickLogSheet.showStepsLogger(context, state),
                            onTap: () => QuickLogSheet.showStepsLogger(context, state),
                          ),
                          MetricCard(
                            title: 'Active Time',
                            value: '$totalActiveMins',
                            unit: 'mins',
                            subtitle: 'Goal: ${goals.dailyActiveMinutesGoal} mins',
                            icon: Icons.timer_rounded,
                            accentColor: AppColors.purple,
                            progress: state.activeTimeProgress,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LogWorkoutScreen(state: state),
                                ),
                              );
                            },
                          ),
                          MetricCard(
                            title: 'Hydration',
                            value: '$totalWater',
                            unit: 'ml',
                            subtitle: 'Goal: ${goals.dailyWaterMlGoal} ml',
                            icon: Icons.water_drop_rounded,
                            accentColor: AppColors.cyan,
                            progress: state.waterProgress,
                            quickAddLabel: '+250ml',
                            onQuickAdd: () => state.addWater(250),
                            onTap: () => QuickLogSheet.showWaterLogger(context, state),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Weight & Sleep 2-Column Row
                      Row(
                        children: [
                          Expanded(
                            child: MetricCard(
                              title: 'Body Weight',
                              value: weight.toStringAsFixed(1),
                              unit: 'kg',
                              subtitle: 'BMI: ${profile.bmi.toStringAsFixed(1)} (${profile.bmiCategory})',
                              icon: Icons.monitor_weight_rounded,
                              accentColor: AppColors.secondary,
                              progress: 1.0,
                              quickAddLabel: 'Log',
                              onQuickAdd: () => QuickLogSheet.showWeightLogger(context, state),
                              onTap: () => QuickLogSheet.showWeightLogger(context, state),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: MetricCard(
                              title: 'Sleep Duration',
                              value: sleep.toStringAsFixed(1),
                              unit: 'hrs',
                              subtitle: 'Goal: ${goals.dailySleepGoalHours} hrs',
                              icon: Icons.bedtime_rounded,
                              accentColor: AppColors.accent,
                              progress: (sleep / goals.dailySleepGoalHours).clamp(0.0, 1.0),
                              quickAddLabel: 'Log',
                              onQuickAdd: () => QuickLogSheet.showSleepLogger(context, state),
                              onTap: () => QuickLogSheet.showSleepLogger(context, state),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Weekly Summary Bar Chart
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: WeeklyBarChartWidget(summaries: state.weeklySummaries),
                ),
              ),

              // Today's Workouts Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isToday ? 'Today\'s Workouts' : 'Workouts on ${DateFormat('MMM d').format(state.selectedDate)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.primary),
                            label: const Text('Add', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LogWorkoutScreen(state: state),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (workouts.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : AppColors.lightCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.fitness_center_rounded,
                                size: 40,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'No workouts logged for this date',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tap "+ Add" to log your exercises and burn calories!',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        ...workouts.map((w) {
                          return WorkoutCard(
                            workout: w,
                            onDelete: () => state.deleteWorkout(w.id),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LogWorkoutScreen(state: state, initialWorkout: w),
                                ),
                              );
                            },
                          );
                        }),
                    ],
                  ),
                ),
              ),

              // Motivational Daily Quote Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.secondary.withOpacity(0.15),
                          AppColors.primary.withOpacity(0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.tips_and_updates_rounded, color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daily Fitness Insight',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Consistency builds champions. Keep hitting your daily activity rings and stay properly hydrated!',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionBtn({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.15 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
