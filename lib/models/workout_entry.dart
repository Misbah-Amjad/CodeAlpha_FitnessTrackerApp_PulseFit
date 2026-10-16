import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'activity_type.dart';

enum WorkoutIntensity {
  low,
  moderate,
  high,
  extreme,
}

extension WorkoutIntensityExt on WorkoutIntensity {
  String get displayName {
    switch (this) {
      case WorkoutIntensity.low:
        return 'Low (Casual)';
      case WorkoutIntensity.moderate:
        return 'Moderate (Steady)';
      case WorkoutIntensity.high:
        return 'High (Intense)';
      case WorkoutIntensity.extreme:
        return 'Extreme (Max Effort)';
    }
  }

  double get multiplier {
    switch (this) {
      case WorkoutIntensity.low:
        return 0.85;
      case WorkoutIntensity.moderate:
        return 1.0;
      case WorkoutIntensity.high:
        return 1.25;
      case WorkoutIntensity.extreme:
        return 1.45;
    }
  }
}

class WorkoutEntry {
  final String id;
  final String activityTypeId;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final double? distanceKm;
  final WorkoutIntensity intensity;
  final DateTime timestamp;
  final String? notes;
  final int? sets;
  final int? reps;
  final double? weightLiftedKg;
  final int? avgHeartRate;

  WorkoutEntry({
    String? id,
    required this.activityTypeId,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.distanceKm,
    this.intensity = WorkoutIntensity.moderate,
    DateTime? timestamp,
    this.notes,
    this.sets,
    this.reps,
    this.weightLiftedKg,
    this.avgHeartRate,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  ActivityType get activityType => ActivityType.getById(activityTypeId);

  WorkoutEntry copyWith({
    String? id,
    String? activityTypeId,
    String? title,
    int? durationMinutes,
    int? caloriesBurned,
    double? distanceKm,
    WorkoutIntensity? intensity,
    DateTime? timestamp,
    String? notes,
    int? sets,
    int? reps,
    double? weightLiftedKg,
    int? avgHeartRate,
  }) {
    return WorkoutEntry(
      id: id ?? this.id,
      activityTypeId: activityTypeId ?? this.activityTypeId,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      distanceKm: distanceKm ?? this.distanceKm,
      intensity: intensity ?? this.intensity,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weightLiftedKg: weightLiftedKg ?? this.weightLiftedKg,
      avgHeartRate: avgHeartRate ?? this.avgHeartRate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activityTypeId': activityTypeId,
      'title': title,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'distanceKm': distanceKm,
      'intensity': intensity.name,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
      'sets': sets,
      'reps': reps,
      'weightLiftedKg': weightLiftedKg,
      'avgHeartRate': avgHeartRate,
    };
  }

  factory WorkoutEntry.fromMap(Map<String, dynamic> map) {
    return WorkoutEntry(
      id: map['id'] as String? ?? const Uuid().v4(),
      activityTypeId: map['activityTypeId'] as String? ?? 'other',
      title: map['title'] as String? ?? 'Workout',
      durationMinutes: (map['durationMinutes'] as num?)?.toInt() ?? 0,
      caloriesBurned: (map['caloriesBurned'] as num?)?.toInt() ?? 0,
      distanceKm: (map['distanceKm'] as num?)?.toDouble(),
      intensity: WorkoutIntensity.values.firstWhere(
        (e) => e.name == map['intensity'],
        orElse: () => WorkoutIntensity.moderate,
      ),
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.now(),
      notes: map['notes'] as String?,
      sets: (map['sets'] as num?)?.toInt(),
      reps: (map['reps'] as num?)?.toInt(),
      weightLiftedKg: (map['weightLiftedKg'] as num?)?.toDouble(),
      avgHeartRate: (map['avgHeartRate'] as num?)?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutEntry.fromJson(String source) =>
      WorkoutEntry.fromMap(json.decode(source) as Map<String, dynamic>);
}
