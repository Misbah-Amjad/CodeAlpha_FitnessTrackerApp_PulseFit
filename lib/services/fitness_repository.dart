import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_entry.dart';
import '../models/daily_metric.dart';
import '../models/goal_settings.dart';
import '../models/user_profile.dart';

class FitnessRepository {
  static const String _keyWorkouts = 'app_workouts_v1';
  static const String _keyDailyMetrics = 'app_daily_metrics_v1';
  static const String _keyGoals = 'app_goals_v1';
  static const String _keyProfile = 'app_profile_v1';
  static const String _keyDarkMode = 'app_dark_mode_v1';
  static const String _keyInitialized = 'app_initialized_seed_v1';

  final SharedPreferences _prefs;

  FitnessRepository(this._prefs);

  static Future<FitnessRepository> init() async {
    final prefs = await SharedPreferences.getInstance();
    final repo = FitnessRepository(prefs);
    if (!prefs.containsKey(_keyInitialized)) {
      await repo._seedInitialData();
      await prefs.setBool(_keyInitialized, true);
    }
    return repo;
  }

  // Workouts
  List<WorkoutEntry> getWorkouts() {
    final rawList = _prefs.getStringList(_keyWorkouts) ?? [];
    return rawList
        .map((item) => WorkoutEntry.fromJson(item))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> saveWorkouts(List<WorkoutEntry> workouts) async {
    final rawList = workouts.map((w) => w.toJson()).toList();
    await _prefs.setStringList(_keyWorkouts, rawList);
  }

  Future<void> addWorkout(WorkoutEntry workout) async {
    final list = getWorkouts();
    list.insert(0, workout);
    await saveWorkouts(list);
  }

  Future<void> deleteWorkout(String id) async {
    final list = getWorkouts().where((w) => w.id != id).toList();
    await saveWorkouts(list);
  }

  // Daily Metrics
  Map<String, DailyMetric> getDailyMetrics() {
    final raw = _prefs.getString(_keyDailyMetrics);
    if (raw == null) return {};
    try {
      final Map<String, dynamic> decoded = json.decode(raw);
      return decoded.map((key, value) =>
          MapEntry(key, DailyMetric.fromMap(value as Map<String, dynamic>)));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveDailyMetrics(Map<String, DailyMetric> metrics) async {
    final Map<String, dynamic> rawMap =
        metrics.map((key, value) => MapEntry(key, value.toMap()));
    await _prefs.setString(_keyDailyMetrics, json.encode(rawMap));
  }

  DailyMetric getMetricForDate(DateTime date) {
    final dateStr = DailyMetric.formatDate(date);
    final map = getDailyMetrics();
    return map[dateStr] ?? DailyMetric(dateString: dateStr);
  }

  Future<void> saveMetricForDate(DailyMetric metric) async {
    final map = getDailyMetrics();
    map[metric.dateString] = metric;
    await saveDailyMetrics(map);
  }

  // Goals
  GoalSettings getGoals() {
    final raw = _prefs.getString(_keyGoals);
    if (raw == null) return const GoalSettings();
    try {
      return GoalSettings.fromJson(raw);
    } catch (_) {
      return const GoalSettings();
    }
  }

  Future<void> saveGoals(GoalSettings goals) async {
    await _prefs.setString(_keyGoals, goals.toJson());
  }

  // Profile
  UserProfile getProfile() {
    final raw = _prefs.getString(_keyProfile);
    if (raw == null) return const UserProfile();
    try {
      return UserProfile.fromJson(raw);
    } catch (_) {
      return const UserProfile();
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _prefs.setString(_keyProfile, profile.toJson());
  }

  // Dark mode
  bool isDarkMode() {
    return _prefs.getBool(_keyDarkMode) ?? true;
  }

  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_keyDarkMode, isDark);
  }

  // Export / Import
  String exportAllDataToJson() {
    final data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'workouts': getWorkouts().map((w) => w.toMap()).toList(),
      'metrics': getDailyMetrics().map((k, v) => MapEntry(k, v.toMap())),
      'goals': getGoals().toMap(),
      'profile': getProfile().toMap(),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  Future<bool> importDataFromJson(String jsonString) async {
    try {
      final Map<String, dynamic> data = json.decode(jsonString);
      if (data.containsKey('workouts')) {
        final rawWorkouts = (data['workouts'] as List)
            .map((item) => WorkoutEntry.fromMap(item as Map<String, dynamic>))
            .toList();
        await saveWorkouts(rawWorkouts);
      }
      if (data.containsKey('metrics')) {
        final rawMetrics = (data['metrics'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, DailyMetric.fromMap(v as Map<String, dynamic>)),
        );
        await saveDailyMetrics(rawMetrics);
      }
      if (data.containsKey('goals')) {
        await saveGoals(GoalSettings.fromMap(data['goals'] as Map<String, dynamic>));
      }
      if (data.containsKey('profile')) {
        await saveProfile(UserProfile.fromMap(data['profile'] as Map<String, dynamic>));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> resetToSeedData() async {
    await _prefs.clear();
    await _seedInitialData();
    await _prefs.setBool(_keyInitialized, true);
  }

  Future<void> _seedInitialData() async {
    final now = DateTime.now();
    final List<WorkoutEntry> seedWorkouts = [];
    final Map<String, DailyMetric> seedMetrics = {};

    // 7 days of realistic fitness logs
    final sampleActivities = [
      {'type': 'running', 'title': 'Morning Interval Run', 'dur': 35, 'cal': 360, 'dist': 5.2, 'hr': 152},
      {'type': 'gym_workout', 'title': 'Upper Body Hypertrophy', 'dur': 50, 'cal': 320, 'sets': 16, 'reps': 10, 'wt': 65.0, 'hr': 130},
      {'type': 'cycling', 'title': 'Sunset Road Cycling', 'dur': 45, 'cal': 390, 'dist': 14.8, 'hr': 144},
      {'type': 'hiit', 'title': 'Tabata Core & Cardio', 'dur': 30, 'cal': 290, 'hr': 162},
      {'type': 'yoga', 'title': 'Vinyasa Flow Recovery', 'dur': 40, 'cal': 140, 'hr': 105},
      {'type': 'swimming', 'title': 'Freestyle Lap Swimming', 'dur': 40, 'cal': 380, 'dist': 1.6, 'hr': 148},
      {'type': 'walking', 'title': 'Brisk Evening Walk', 'dur': 30, 'cal': 135, 'dist': 2.8, 'hr': 110},
    ];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = DailyMetric.formatDate(date);

      // Varying steps and water
      final steps = (7200 + (i * 730) % 4500);
      final water = 2000 + ((i * 350) % 1200);
      final weight = 72.8 - (6 - i) * 0.12;
      final sleep = 7.0 + (i % 3) * 0.5;

      seedMetrics[dateStr] = DailyMetric(
        dateString: dateStr,
        steps: steps,
        waterMl: water,
        weightKg: double.parse(weight.toStringAsFixed(1)),
        sleepHours: sleep,
        restingHeartRate: 62 + (i % 5),
        mood: i % 2 == 0 ? 'Energized' : 'Great',
      );

      final sample = sampleActivities[i % sampleActivities.length];
      seedWorkouts.add(
        WorkoutEntry(
          activityTypeId: sample['type'] as String,
          title: sample['title'] as String,
          durationMinutes: sample['dur'] as int,
          caloriesBurned: sample['cal'] as int,
          distanceKm: sample['dist'] as double?,
          intensity: WorkoutIntensity.moderate,
          timestamp: DateTime(date.year, date.month, date.day, 8 + (i % 10), 30),
          notes: 'Felt great during the session. Consistent pacing maintained!',
          sets: sample['sets'] as int?,
          reps: sample['reps'] as int?,
          weightLiftedKg: sample['wt'] as double?,
          avgHeartRate: sample['hr'] as int?,
        ),
      );
    }

    // Add another workout for today
    seedWorkouts.insert(
      0,
      WorkoutEntry(
        activityTypeId: 'gym_workout',
        title: 'Chest & Triceps Push Day',
        durationMinutes: 45,
        caloriesBurned: 310,
        intensity: WorkoutIntensity.high,
        timestamp: DateTime(now.year, now.month, now.day, 17, 15),
        notes: 'Hit bench press personal record of 80kg x 6 reps!',
        sets: 14,
        reps: 8,
        weightLiftedKg: 75.0,
        avgHeartRate: 138,
      ),
    );

    // Save initial state
    await saveWorkouts(seedWorkouts);
    await saveDailyMetrics(seedMetrics);
    await saveGoals(const GoalSettings());
    await saveProfile(const UserProfile());
    await setDarkMode(true);
  }
}
