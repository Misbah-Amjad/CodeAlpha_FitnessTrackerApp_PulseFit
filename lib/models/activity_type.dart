import 'package:flutter/material.dart';

enum ActivityCategory {
  cardio,
  strength,
  flexibility,
  sports,
  outdoor,
}

class ActivityType {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final ActivityCategory category;
  final double metValue; // Metabolic Equivalent of Task for calorie calculations

  const ActivityType({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.category,
    required this.metValue,
  });

  static const List<ActivityType> all = [
    ActivityType(
      id: 'running',
      name: 'Running',
      icon: Icons.directions_run_rounded,
      color: Color(0xFFEF4444), // Coral Red
      category: ActivityCategory.cardio,
      metValue: 9.8,
    ),
    ActivityType(
      id: 'cycling',
      name: 'Cycling',
      icon: Icons.directions_bike_rounded,
      color: Color(0xFFF97316), // Orange
      category: ActivityCategory.cardio,
      metValue: 7.5,
    ),
    ActivityType(
      id: 'swimming',
      name: 'Swimming',
      icon: Icons.pool_rounded,
      color: Color(0xFF06B6D4), // Cyan
      category: ActivityCategory.cardio,
      metValue: 8.0,
    ),
    ActivityType(
      id: 'walking',
      name: 'Walking',
      icon: Icons.directions_walk_rounded,
      color: Color(0xFF10B981), // Emerald Green
      category: ActivityCategory.cardio,
      metValue: 3.5,
    ),
    ActivityType(
      id: 'gym_workout',
      name: 'Weight Lifting',
      icon: Icons.fitness_center_rounded,
      color: Color(0xFF8B5CF6), // Purple
      category: ActivityCategory.strength,
      metValue: 6.0,
    ),
    ActivityType(
      id: 'hiit',
      name: 'HIIT & Circuit',
      icon: Icons.bolt_rounded,
      color: Color(0xFFEC4899), // Pink
      category: ActivityCategory.cardio,
      metValue: 8.5,
    ),
    ActivityType(
      id: 'yoga',
      name: 'Yoga & Stretch',
      icon: Icons.self_improvement_rounded,
      color: Color(0xFF14B8A6), // Teal
      category: ActivityCategory.flexibility,
      metValue: 3.0,
    ),
    ActivityType(
      id: 'pilates',
      name: 'Pilates',
      icon: Icons.accessibility_new_rounded,
      color: Color(0xFFA855F7), // Light Purple
      category: ActivityCategory.flexibility,
      metValue: 3.8,
    ),
    ActivityType(
      id: 'boxing',
      name: 'Boxing',
      icon: Icons.sports_mma_rounded,
      color: Color(0xFFDC2626), // Crimson
      category: ActivityCategory.sports,
      metValue: 9.0,
    ),
    ActivityType(
      id: 'hiking',
      name: 'Hiking',
      icon: Icons.hiking_rounded,
      color: Color(0xFF84CC16), // Lime Green
      category: ActivityCategory.outdoor,
      metValue: 6.0,
    ),
    ActivityType(
      id: 'jump_rope',
      name: 'Jump Rope',
      icon: Icons.airline_stops_rounded,
      color: Color(0xFFEAB308), // Yellow
      category: ActivityCategory.cardio,
      metValue: 11.0,
    ),
    ActivityType(
      id: 'other',
      name: 'Custom Workout',
      icon: Icons.sports_gymnastics_rounded,
      color: Color(0xFF6366F1), // Indigo
      category: ActivityCategory.sports,
      metValue: 5.0,
    ),
  ];

  static ActivityType getById(String id) {
    return all.firstWhere(
      (a) => a.id.toLowerCase() == id.toLowerCase(),
      orElse: () => all.last,
    );
  }

  /// Calculates estimated calories burned given duration (mins) and body weight (kg)
  /// Formula: Calories = MET * weight (kg) * (duration in mins / 60)
  static int estimateCalories({
    required ActivityType activity,
    required int durationMinutes,
    double weightKg = 70.0,
  }) {
    final double calories = activity.metValue * weightKg * (durationMinutes / 60.0);
    return calories.round();
  }
}
