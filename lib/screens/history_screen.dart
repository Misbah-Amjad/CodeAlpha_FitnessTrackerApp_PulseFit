import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity_type.dart';
import '../services/fitness_state.dart';
import '../theme/app_colors.dart';
import '../widgets/workout_card.dart';
import 'log_workout_screen.dart';

class HistoryScreen extends StatefulWidget {
  final FitnessState state;

  const HistoryScreen({
    super.key,
    required this.state,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  ActivityCategory? _selectedCategory; // null means All

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allWorkouts = widget.state.workouts;

    // Filter by query and category
    final query = _searchCtrl.text.toLowerCase().trim();
    final filtered = allWorkouts.where((w) {
      final matchesQuery = query.isEmpty ||
          w.title.toLowerCase().contains(query) ||
          w.activityType.name.toLowerCase().contains(query) ||
          (w.notes != null && w.notes!.toLowerCase().contains(query));

      final matchesCategory = _selectedCategory == null ||
          w.activityType.category == _selectedCategory;

      return matchesQuery && matchesCategory;
    }).toList();

    final totalBurned = filtered.fold(0, (s, w) => s + w.caloriesBurned);
    final totalMins = filtered.fold(0, (s, w) => s + w.durationMinutes);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Log Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
            tooltip: 'Log New Workout',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LogWorkoutScreen(state: widget.state),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search & Filters Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search workouts, notes, activities...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              setState(() {
                                _searchCtrl.clear();
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (val) => setState(() {}),
                ),
                const SizedBox(height: 12),
                // Category Filter Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('All Categories', null, isDark),
                      const SizedBox(width: 8),
                      _buildCategoryChip('Cardio', ActivityCategory.cardio, isDark),
                      const SizedBox(width: 8),
                      _buildCategoryChip('Strength', ActivityCategory.strength, isDark),
                      const SizedBox(width: 8),
                      _buildCategoryChip('Flexibility', ActivityCategory.flexibility, isDark),
                      const SizedBox(width: 8),
                      _buildCategoryChip('Sports', ActivityCategory.sports, isDark),
                      const SizedBox(width: 8),
                      _buildCategoryChip('Outdoor', ActivityCategory.outdoor, isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filter Summary Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filtered.length} ${filtered.length == 1 ? 'Session' : 'Sessions'} Found',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${NumberFormat('#,###').format(totalBurned)} kcal',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.coral,
                      ),
                    ),
                    const Text(' • ', style: TextStyle(color: Colors.grey)),
                    Text(
                      '$totalMins mins',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Workout list
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_toggle_off_rounded,
                            size: 64,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No workouts match your filter',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try resetting filters or log a new workout session.',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Log Workout'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LogWorkoutScreen(state: widget.state),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final workout = filtered[i];
                      return WorkoutCard(
                        workout: workout,
                        onDelete: () => widget.state.deleteWorkout(workout.id),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LogWorkoutScreen(
                                state: widget.state,
                                initialWorkout: workout,
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
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Log Workout', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LogWorkoutScreen(state: widget.state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(String label, ActivityCategory? category, bool isDark) {
    final isSelected = _selectedCategory == category;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary.withOpacity(0.25),
      side: BorderSide(
        color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
      ),
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
      },
    );
  }
}
