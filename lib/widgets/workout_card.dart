import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout_entry.dart';
import '../theme/app_colors.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutEntry workout;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const WorkoutCard({
    super.key,
    required this.workout,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actType = workout.activityType;
    final timeStr = DateFormat('h:mm a').format(workout.timestamp);
    final dateStr = DateFormat('EEE, MMM d').format(workout.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Activity Icon + Title + Time + Delete/Options
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: actType.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(actType.icon, color: actType.color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workout.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                '$dateStr • $timeStr',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 20),
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                              title: const Text('Delete Workout?'),
                              content: Text('Are you sure you want to remove "${workout.title}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    onDelete!();
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                // Stats Badges Row
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStatChip(
                      icon: Icons.local_fire_department_rounded,
                      text: '${workout.caloriesBurned} kcal',
                      color: AppColors.coral,
                      isDark: isDark,
                    ),
                    _buildStatChip(
                      icon: Icons.timer_rounded,
                      text: '${workout.durationMinutes} mins',
                      color: AppColors.purple,
                      isDark: isDark,
                    ),
                    if (workout.distanceKm != null && workout.distanceKm! > 0)
                      _buildStatChip(
                        icon: Icons.route_rounded,
                        text: '${workout.distanceKm!.toStringAsFixed(1)} km',
                        color: AppColors.cyan,
                        isDark: isDark,
                      ),
                    if (workout.sets != null && workout.sets! > 0)
                      _buildStatChip(
                        icon: Icons.repeat_rounded,
                        text: '${workout.sets} sets × ${workout.reps ?? 10} reps',
                        color: AppColors.accent,
                        isDark: isDark,
                      ),
                    if (workout.weightLiftedKg != null && workout.weightLiftedKg! > 0)
                      _buildStatChip(
                        icon: Icons.fitness_center_rounded,
                        text: '${workout.weightLiftedKg!.toStringAsFixed(1)} kg',
                        color: AppColors.secondary,
                        isDark: isDark,
                      ),
                    if (workout.avgHeartRate != null && workout.avgHeartRate! > 0)
                      _buildStatChip(
                        icon: Icons.favorite_rounded,
                        text: '${workout.avgHeartRate} bpm',
                        color: Colors.pinkAccent,
                        isDark: isDark,
                      ),
                  ],
                ),
                if (workout.notes != null && workout.notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardHover.withOpacity(0.5) : AppColors.lightCardHover,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.note_rounded,
                          size: 14,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            workout.notes!,
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String text,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
