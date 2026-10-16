import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    Color? color,
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
    );
  }

  static List<Achievement> get initialAchievements => [
    const Achievement(
      id: 'first_step',
      title: 'First Step',
      description: 'Log your first workout activity',
      icon: Icons.flag_rounded,
      color: Color(0xFF10B981),
      isUnlocked: true,
      progress: 1.0,
    ),
    const Achievement(
      id: 'hydration_master',
      title: 'Hydration Hero',
      description: 'Drink at least 2,500 ml of water in a single day',
      icon: Icons.water_drop_rounded,
      color: Color(0xFF06B6D4),
      isUnlocked: true,
      progress: 1.0,
    ),
    const Achievement(
      id: 'calorie_crusher',
      title: 'Calorie Crusher',
      description: 'Burn 500+ active calories in one day',
      icon: Icons.local_fire_department_rounded,
      color: Color(0xFFEF4444),
      isUnlocked: true,
      progress: 1.0,
    ),
    const Achievement(
      id: 'streak_3',
      title: 'Consistency Starter',
      description: 'Maintain a 3-day workout streak',
      icon: Icons.electric_bolt_rounded,
      color: Color(0xFFF59E0B),
      isUnlocked: true,
      progress: 1.0,
    ),
    const Achievement(
      id: 'streak_7',
      title: 'Iron Discipline',
      description: 'Achieve a 7-day fitness streak',
      icon: Icons.emoji_events_rounded,
      color: Color(0xFF8B5CF6),
      isUnlocked: false,
      progress: 0.71,
    ),
    const Achievement(
      id: 'step_10k',
      title: '10k Club',
      description: 'Hit 10,000 steps in a single day',
      icon: Icons.directions_walk_rounded,
      color: Color(0xFF10B981),
      isUnlocked: true,
      progress: 1.0,
    ),
    const Achievement(
      id: 'century_sweat',
      title: 'Centurion',
      description: 'Accumulate 100+ active workout minutes in a week',
      icon: Icons.timer_rounded,
      color: Color(0xFFEC4899),
      isUnlocked: true,
      progress: 1.0,
    ),
    const Achievement(
      id: 'diversity_champion',
      title: 'Cross-Trainer',
      description: 'Log 4 different workout types',
      icon: Icons.dashboard_customize_rounded,
      color: Color(0xFF6366F1),
      isUnlocked: true,
      progress: 1.0,
    ),
  ];
}
