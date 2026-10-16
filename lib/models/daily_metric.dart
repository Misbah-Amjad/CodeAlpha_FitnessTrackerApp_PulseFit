import 'dart:convert';
import 'package:intl/intl.dart';

class DailyMetric {
  final String dateString; // 'YYYY-MM-DD'
  final int steps;
  final int waterMl; // in milliliters (e.g. 2500 ml)
  final double? weightKg;
  final double? sleepHours;
  final int? restingHeartRate;
  final String? mood;

  DailyMetric({
    required this.dateString,
    this.steps = 0,
    this.waterMl = 0,
    this.weightKg,
    this.sleepHours,
    this.restingHeartRate,
    this.mood,
  });

  static String formatDate(DateTime dt) {
    return DateFormat('yyyy-MM-dd').format(dt);
  }

  DateTime get dateTime => DateTime.parse(dateString);

  DailyMetric copyWith({
    String? dateString,
    int? steps,
    int? waterMl,
    double? weightKg,
    double? sleepHours,
    int? restingHeartRate,
    String? mood,
  }) {
    return DailyMetric(
      dateString: dateString ?? this.dateString,
      steps: steps ?? this.steps,
      waterMl: waterMl ?? this.waterMl,
      weightKg: weightKg ?? this.weightKg,
      sleepHours: sleepHours ?? this.sleepHours,
      restingHeartRate: restingHeartRate ?? this.restingHeartRate,
      mood: mood ?? this.mood,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateString': dateString,
      'steps': steps,
      'waterMl': waterMl,
      'weightKg': weightKg,
      'sleepHours': sleepHours,
      'restingHeartRate': restingHeartRate,
      'mood': mood,
    };
  }

  factory DailyMetric.fromMap(Map<String, dynamic> map) {
    return DailyMetric(
      dateString: map['dateString'] as String? ?? formatDate(DateTime.now()),
      steps: (map['steps'] as num?)?.toInt() ?? 0,
      waterMl: (map['waterMl'] as num?)?.toInt() ?? 0,
      weightKg: (map['weightKg'] as num?)?.toDouble(),
      sleepHours: (map['sleepHours'] as num?)?.toDouble(),
      restingHeartRate: (map['restingHeartRate'] as num?)?.toInt(),
      mood: map['mood'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyMetric.fromJson(String source) =>
      DailyMetric.fromMap(json.decode(source) as Map<String, dynamic>);
}
