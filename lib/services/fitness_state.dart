import 'package:flutter/material.dart';
import '../models/workout_entry.dart';
import '../models/daily_metric.dart';
import '../models/goal_settings.dart';
import '../models/user_profile.dart';
import '../models/achievement.dart';
import '../models/activity_type.dart';
import 'fitness_repository.dart';

class FitnessState extends ChangeNotifier {
  final FitnessRepository _repo;

  List<WorkoutEntry> _workouts = [];
  Map<String, DailyMetric> _dailyMetrics = {};
  GoalSettings _goals = const GoalSettings();
  UserProfile _profile = const UserProfile();
  bool _isDarkMode = true;
  DateTime _selectedDate = DateTime.now();

  FitnessState(this._repo) {
    _loadState();
  }

  // Getters
  List<WorkoutEntry> get workouts => _workouts;
  Map<String, DailyMetric> get dailyMetrics => _dailyMetrics;
  GoalSettings get goals => _goals;
  UserProfile get profile => _profile;
  bool get isDarkMode => _isDarkMode;
  DateTime get selectedDate => _selectedDate;

  void _loadState() {
    _workouts = _repo.getWorkouts();
    _dailyMetrics = _repo.getDailyMetrics();
    _goals = _repo.getGoals();
    _profile = _repo.getProfile();
    _isDarkMode = _repo.isDarkMode();
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  String get selectedDateStr => DailyMetric.formatDate(_selectedDate);
  String get todayStr => DailyMetric.formatDate(DateTime.now());

  DailyMetric get currentMetric {
    return _dailyMetrics[selectedDateStr] ?? DailyMetric(dateString: selectedDateStr);
  }

  List<WorkoutEntry> get workoutsForSelectedDate {
    return _workouts.where((w) {
      return DailyMetric.formatDate(w.timestamp) == selectedDateStr;
    }).toList();
  }

  List<WorkoutEntry> get todayWorkouts {
    return _workouts.where((w) {
      return DailyMetric.formatDate(w.timestamp) == todayStr;
    }).toList();
  }

  // Summary Metrics for selected date
  int get selectedDateWorkoutCalories {
    return workoutsForSelectedDate.fold(0, (sum, w) => sum + w.caloriesBurned);
  }

  int get selectedDateActiveMinutes {
    return workoutsForSelectedDate.fold(0, (sum, w) => sum + w.durationMinutes);
  }

  int get selectedDateSteps => currentMetric.steps;
  int get selectedDateWaterMl => currentMetric.waterMl;
  double? get selectedDateSleep => currentMetric.sleepHours;
  double? get selectedDateWeight => currentMetric.weightKg ?? _profile.currentWeightKg;

  // Percentage progress vs goals
  double get caloriesProgress {
    if (_goals.dailyCaloriesGoal <= 0) return 0.0;
    return (selectedDateWorkoutCalories / _goals.dailyCaloriesGoal).clamp(0.0, 1.5);
  }

  double get stepsProgress {
    if (_goals.dailyStepsGoal <= 0) return 0.0;
    return (selectedDateSteps / _goals.dailyStepsGoal).clamp(0.0, 1.5);
  }

  double get waterProgress {
    if (_goals.dailyWaterMlGoal <= 0) return 0.0;
    return (selectedDateWaterMl / _goals.dailyWaterMlGoal).clamp(0.0, 1.5);
  }

  double get activeTimeProgress {
    if (_goals.dailyActiveMinutesGoal <= 0) return 0.0;
    return (selectedDateActiveMinutes / _goals.dailyActiveMinutesGoal).clamp(0.0, 1.5);
  }

  // Streaks
  int get currentStreak {
    int streak = 0;
    DateTime checkDate = DateTime.now();
    while (true) {
      final dateKey = DailyMetric.formatDate(checkDate);
      final hasWorkout = _workouts.any((w) => DailyMetric.formatDate(w.timestamp) == dateKey);
      final hasSteps = (_dailyMetrics[dateKey]?.steps ?? 0) >= (_goals.dailyStepsGoal * 0.7);

      if (hasWorkout || hasSteps) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        // If today hasn't had workout yet, check yesterday before breaking streak
        if (streak == 0 && DailyMetric.formatDate(checkDate) == todayStr) {
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }
        break;
      }
    }
    return streak;
  }

  // Weekly Stats (last 7 days)
  List<DaySummary> get weeklySummaries {
    final List<DaySummary> list = [];
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final dStr = DailyMetric.formatDate(d);
      final dayWorkouts = _workouts.where((w) => DailyMetric.formatDate(w.timestamp) == dStr).toList();
      final metric = _dailyMetrics[dStr] ?? DailyMetric(dateString: dStr);

      final cal = dayWorkouts.fold(0, (s, w) => s + w.caloriesBurned);
      final mins = dayWorkouts.fold(0, (s, w) => s + w.durationMinutes);
      final dist = dayWorkouts.fold(0.0, (s, w) => s + (w.distanceKm ?? 0.0));

      list.add(DaySummary(
        date: d,
        dateString: dStr,
        calories: cal,
        steps: metric.steps,
        waterMl: metric.waterMl,
        activeMinutes: mins,
        distanceKm: dist,
        weightKg: metric.weightKg,
        workoutCount: dayWorkouts.length,
      ));
    }
    return list;
  }

  // Monthly stats (last 30 days)
  List<DaySummary> get monthlySummaries {
    final List<DaySummary> list = [];
    final now = DateTime.now();
    for (int i = 29; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final dStr = DailyMetric.formatDate(d);
      final dayWorkouts = _workouts.where((w) => DailyMetric.formatDate(w.timestamp) == dStr).toList();
      final metric = _dailyMetrics[dStr] ?? DailyMetric(dateString: dStr);

      final cal = dayWorkouts.fold(0, (s, w) => s + w.caloriesBurned);
      final mins = dayWorkouts.fold(0, (s, w) => s + w.durationMinutes);
      final dist = dayWorkouts.fold(0.0, (s, w) => s + (w.distanceKm ?? 0.0));

      list.add(DaySummary(
        date: d,
        dateString: dStr,
        calories: cal,
        steps: metric.steps,
        waterMl: metric.waterMl,
        activeMinutes: mins,
        distanceKm: dist,
        weightKg: metric.weightKg,
        workoutCount: dayWorkouts.length,
      ));
    }
    return list;
  }

  // Category Distribution
  Map<ActivityCategory, int> get categoryCalorieDistribution {
    final Map<ActivityCategory, int> dist = {
      ActivityCategory.cardio: 0,
      ActivityCategory.strength: 0,
      ActivityCategory.flexibility: 0,
      ActivityCategory.sports: 0,
      ActivityCategory.outdoor: 0,
    };
    for (var w in _workouts) {
      final cat = w.activityType.category;
      dist[cat] = (dist[cat] ?? 0) + w.caloriesBurned;
    }
    return dist;
  }

  // All-time aggregate stats
  int get totalWorkoutsCount => _workouts.length;
  int get totalCaloriesBurned => _workouts.fold(0, (s, w) => s + w.caloriesBurned);
  int get totalActiveMinutes => _workouts.fold(0, (s, w) => s + w.durationMinutes);
  double get totalDistanceKm => _workouts.fold(0.0, (s, w) => s + (w.distanceKm ?? 0.0));

  // Achievements dynamic evaluation
  List<Achievement> get achievements {
    final base = Achievement.initialAchievements;
    final totalW = totalWorkoutsCount;
    final maxStreak = currentStreak;
    final has10k = _dailyMetrics.values.any((m) => m.steps >= 10000);
    final has2500Water = _dailyMetrics.values.any((m) => m.waterMl >= 2500);
    final distinctTypes = _workouts.map((w) => w.activityTypeId).toSet().length;

    return base.map((ach) {
      switch (ach.id) {
        case 'first_step':
          final unlocked = totalW >= 1;
          return ach.copyWith(isUnlocked: unlocked, progress: totalW >= 1 ? 1.0 : 0.0);
        case 'hydration_master':
          return ach.copyWith(isUnlocked: has2500Water, progress: has2500Water ? 1.0 : 0.6);
        case 'calorie_crusher':
          final maxDayCal = weeklySummaries.fold(0, (m, d) => d.calories > m ? d.calories : m);
          final unlocked = maxDayCal >= 500;
          return ach.copyWith(isUnlocked: unlocked, progress: (maxDayCal / 500.0).clamp(0.0, 1.0));
        case 'streak_3':
          final unlocked = maxStreak >= 3;
          return ach.copyWith(isUnlocked: unlocked, progress: (maxStreak / 3.0).clamp(0.0, 1.0));
        case 'streak_7':
          final unlocked = maxStreak >= 7;
          return ach.copyWith(isUnlocked: unlocked, progress: (maxStreak / 7.0).clamp(0.0, 1.0));
        case 'step_10k':
          return ach.copyWith(isUnlocked: has10k, progress: has10k ? 1.0 : 0.8);
        case 'century_sweat':
          final totalMins = totalActiveMinutes;
          final unlocked = totalMins >= 100;
          return ach.copyWith(isUnlocked: unlocked, progress: (totalMins / 100.0).clamp(0.0, 1.0));
        case 'diversity_champion':
          final unlocked = distinctTypes >= 4;
          return ach.copyWith(isUnlocked: unlocked, progress: (distinctTypes / 4.0).clamp(0.0, 1.0));
        default:
          return ach;
      }
    }).toList();
  }

  // State Mutation Actions
  Future<void> addWorkout(WorkoutEntry workout) async {
    await _repo.addWorkout(workout);
    _workouts = _repo.getWorkouts();
    notifyListeners();
  }

  Future<void> deleteWorkout(String id) async {
    await _repo.deleteWorkout(id);
    _workouts = _repo.getWorkouts();
    notifyListeners();
  }

  Future<void> updateDailyMetric(DailyMetric metric) async {
    await _repo.saveMetricForDate(metric);
    _dailyMetrics = _repo.getDailyMetrics();
    notifyListeners();
  }

  Future<void> addWater(int mlToAdd) async {
    final metric = currentMetric;
    final updated = metric.copyWith(waterMl: metric.waterMl + mlToAdd);
    await updateDailyMetric(updated);
  }

  Future<void> setWater(int totalMl) async {
    final metric = currentMetric;
    final updated = metric.copyWith(waterMl: totalMl);
    await updateDailyMetric(updated);
  }

  Future<void> setSteps(int steps) async {
    final metric = currentMetric;
    final updated = metric.copyWith(steps: steps);
    await updateDailyMetric(updated);
  }

  Future<void> setWeight(double weightKg) async {
    final metric = currentMetric;
    final updated = metric.copyWith(weightKg: weightKg);
    await updateDailyMetric(updated);

    // Also update profile current weight
    final updatedProfile = _profile.copyWith(currentWeightKg: weightKg);
    await updateProfile(updatedProfile);
  }

  Future<void> setSleep(double hours) async {
    final metric = currentMetric;
    final updated = metric.copyWith(sleepHours: hours);
    await updateDailyMetric(updated);
  }

  Future<void> updateGoals(GoalSettings newGoals) async {
    await _repo.saveGoals(newGoals);
    _goals = newGoals;
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile newProfile) async {
    await _repo.saveProfile(newProfile);
    _profile = newProfile;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _repo.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> resetToSeedData() async {
    await _repo.resetToSeedData();
    _loadState();
  }

  String exportJson() => _repo.exportAllDataToJson();

  Future<bool> importJson(String json) async {
    final success = await _repo.importDataFromJson(json);
    if (success) {
      _loadState();
    }
    return success;
  }
}

class DaySummary {
  final DateTime date;
  final String dateString;
  final int calories;
  final int steps;
  final int waterMl;
  final int activeMinutes;
  final double distanceKm;
  final double? weightKg;
  final int workoutCount;

  DaySummary({
    required this.date,
    required this.dateString,
    required this.calories,
    required this.steps,
    required this.waterMl,
    required this.activeMinutes,
    required this.distanceKm,
    this.weightKg,
    required this.workoutCount,
  });
}
