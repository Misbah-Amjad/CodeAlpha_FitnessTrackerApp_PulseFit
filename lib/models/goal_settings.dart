import 'dart:convert';

class GoalSettings {
  final int dailyStepsGoal;
  final int dailyCaloriesGoal;
  final int dailyWaterMlGoal;
  final int dailyActiveMinutesGoal;
  final double dailySleepGoalHours;
  final double? targetWeightKg;

  const GoalSettings({
    this.dailyStepsGoal = 10000,
    this.dailyCaloriesGoal = 600,
    this.dailyWaterMlGoal = 2500,
    this.dailyActiveMinutesGoal = 45,
    this.dailySleepGoalHours = 8.0,
    this.targetWeightKg = 70.0,
  });

  GoalSettings copyWith({
    int? dailyStepsGoal,
    int? dailyCaloriesGoal,
    int? dailyWaterMlGoal,
    int? dailyActiveMinutesGoal,
    double? dailySleepGoalHours,
    double? targetWeightKg,
  }) {
    return GoalSettings(
      dailyStepsGoal: dailyStepsGoal ?? this.dailyStepsGoal,
      dailyCaloriesGoal: dailyCaloriesGoal ?? this.dailyCaloriesGoal,
      dailyWaterMlGoal: dailyWaterMlGoal ?? this.dailyWaterMlGoal,
      dailyActiveMinutesGoal: dailyActiveMinutesGoal ?? this.dailyActiveMinutesGoal,
      dailySleepGoalHours: dailySleepGoalHours ?? this.dailySleepGoalHours,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dailyStepsGoal': dailyStepsGoal,
      'dailyCaloriesGoal': dailyCaloriesGoal,
      'dailyWaterMlGoal': dailyWaterMlGoal,
      'dailyActiveMinutesGoal': dailyActiveMinutesGoal,
      'dailySleepGoalHours': dailySleepGoalHours,
      'targetWeightKg': targetWeightKg,
    };
  }

  factory GoalSettings.fromMap(Map<String, dynamic> map) {
    return GoalSettings(
      dailyStepsGoal: (map['dailyStepsGoal'] as num?)?.toInt() ?? 10000,
      dailyCaloriesGoal: (map['dailyCaloriesGoal'] as num?)?.toInt() ?? 600,
      dailyWaterMlGoal: (map['dailyWaterMlGoal'] as num?)?.toInt() ?? 2500,
      dailyActiveMinutesGoal: (map['dailyActiveMinutesGoal'] as num?)?.toInt() ?? 45,
      dailySleepGoalHours: (map['dailySleepGoalHours'] as num?)?.toDouble() ?? 8.0,
      targetWeightKg: (map['targetWeightKg'] as num?)?.toDouble() ?? 70.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GoalSettings.fromJson(String source) =>
      GoalSettings.fromMap(json.decode(source) as Map<String, dynamic>);
}
