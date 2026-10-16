import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/goal_settings.dart';
import '../services/fitness_state.dart';
import '../theme/app_colors.dart';
import '../widgets/achievement_badge_card.dart';

class GoalsScreen extends StatefulWidget {
  final FitnessState state;

  const GoalsScreen({
    super.key,
    required this.state,
  });

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late double _stepsGoal;
  late double _caloriesGoal;
  late double _waterGoal;
  late double _activeMinsGoal;
  late double _sleepGoal;
  late double _targetWeight;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFromState();
  }

  void _loadFromState() {
    final g = widget.state.goals;
    _stepsGoal = g.dailyStepsGoal.toDouble();
    _caloriesGoal = g.dailyCaloriesGoal.toDouble();
    _waterGoal = g.dailyWaterMlGoal.toDouble();
    _activeMinsGoal = g.dailyActiveMinutesGoal.toDouble();
    _sleepGoal = g.dailySleepGoalHours;
    _targetWeight = g.targetWeightKg ?? widget.state.profile.currentWeightKg;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final achievements = widget.state.achievements;
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals & Badges'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: [
            const Tab(text: 'Daily Targets', icon: Icon(Icons.track_changes_rounded, size: 20)),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events_rounded, size: 20),
                  const SizedBox(width: 6),
                  Text('Badges ($unlockedCount/${achievements.length})'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Goal Settings Customizer
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customize Your Daily Targets',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Adjust your daily fitness ambitions to match your personalized routine',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 24),

                // 1. Daily Steps
                _buildGoalSliderCard(
                  title: 'Daily Steps Goal',
                  valueDisplay: '${NumberFormat('#,###').format(_stepsGoal.toInt())} steps',
                  icon: Icons.directions_walk_rounded,
                  color: AppColors.primary,
                  min: 2000,
                  max: 30000,
                  divisions: 28,
                  currentValue: _stepsGoal,
                  isDark: isDark,
                  onChanged: (val) => setState(() => _stepsGoal = val),
                ),
                const SizedBox(height: 16),

                // 2. Active Calories
                _buildGoalSliderCard(
                  title: 'Daily Active Calories Burn',
                  valueDisplay: '${_caloriesGoal.toInt()} kcal',
                  icon: Icons.local_fire_department_rounded,
                  color: AppColors.coral,
                  min: 150,
                  max: 2000,
                  divisions: 37,
                  currentValue: _caloriesGoal,
                  isDark: isDark,
                  onChanged: (val) => setState(() => _caloriesGoal = val),
                ),
                const SizedBox(height: 16),

                // 3. Water Intake
                _buildGoalSliderCard(
                  title: 'Daily Water Hydration',
                  valueDisplay: '${_waterGoal.toInt()} ml',
                  icon: Icons.water_drop_rounded,
                  color: AppColors.cyan,
                  min: 1000,
                  max: 5000,
                  divisions: 40,
                  currentValue: _waterGoal,
                  isDark: isDark,
                  onChanged: (val) => setState(() => _waterGoal = val),
                ),
                const SizedBox(height: 16),

                // 4. Active Minutes
                _buildGoalSliderCard(
                  title: 'Daily Active Exercise Time',
                  valueDisplay: '${_activeMinsGoal.toInt()} mins',
                  icon: Icons.timer_rounded,
                  color: AppColors.purple,
                  min: 15,
                  max: 180,
                  divisions: 33,
                  currentValue: _activeMinsGoal,
                  isDark: isDark,
                  onChanged: (val) => setState(() => _activeMinsGoal = val),
                ),
                const SizedBox(height: 16),

                // 5. Sleep Target
                _buildGoalSliderCard(
                  title: 'Daily Sleep & Rest Goal',
                  valueDisplay: '${_sleepGoal.toStringAsFixed(1)} hrs',
                  icon: Icons.bedtime_rounded,
                  color: AppColors.accent,
                  min: 5.0,
                  max: 12.0,
                  divisions: 14,
                  currentValue: _sleepGoal,
                  isDark: isDark,
                  onChanged: (val) => setState(() => _sleepGoal = val),
                ),
                const SizedBox(height: 16),

                // 6. Target Weight
                _buildGoalSliderCard(
                  title: 'Target Body Weight',
                  valueDisplay: '${_targetWeight.toStringAsFixed(1)} kg',
                  icon: Icons.monitor_weight_rounded,
                  color: AppColors.secondary,
                  min: 40.0,
                  max: 150.0,
                  divisions: 110,
                  currentValue: _targetWeight,
                  isDark: isDark,
                  onChanged: (val) => setState(() => _targetWeight = val),
                ),
                const SizedBox(height: 30),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Save Daily Goals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    onPressed: () async {
                      final newGoals = GoalSettings(
                        dailyStepsGoal: _stepsGoal.toInt(),
                        dailyCaloriesGoal: _caloriesGoal.toInt(),
                        dailyWaterMlGoal: _waterGoal.toInt(),
                        dailyActiveMinutesGoal: _activeMinsGoal.toInt(),
                        dailySleepGoalHours: _sleepGoal,
                        targetWeightKg: _targetWeight,
                      );
                      await widget.state.updateGoals(newGoals);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitness goals updated successfully!'),
                          backgroundColor: AppColors.primaryDark,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Tab 2: Gamification Achievements & Badges
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Achievement Progress Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.military_tech_rounded, color: Colors.white, size: 36),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$unlockedCount of ${achievements.length} Badges Unlocked',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: unlockedCount / (achievements.isEmpty ? 1 : achievements.length),
                                minHeight: 6,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Keep training consistently to unlock all badges!',
                              style: TextStyle(fontSize: 11, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Milestones & Awards',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 14),

                // Badges Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: achievements.length,
                  itemBuilder: (ctx, i) {
                    return AchievementBadgeCard(achievement: achievements[i]);
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSliderCard({
    required String title,
    required String valueDisplay,
    required IconData icon,
    required Color color,
    required double min,
    required double max,
    required int divisions,
    required double currentValue,
    required bool isDark,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              Text(
                valueDisplay,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Slider(
            value: currentValue.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            activeColor: color,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
