import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codealpha_fitness_tracker/models/activity_type.dart';
import 'package:codealpha_fitness_tracker/models/workout_entry.dart';
import 'package:codealpha_fitness_tracker/models/user_profile.dart';
import 'package:codealpha_fitness_tracker/models/daily_metric.dart';
import 'package:codealpha_fitness_tracker/services/fitness_repository.dart';
import 'package:codealpha_fitness_tracker/services/fitness_state.dart';
import 'package:codealpha_fitness_tracker/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('ActivityType MET calorie calculation works correctly', () {
    final running = ActivityType.getById('running');
    final calories = ActivityType.estimateCalories(
      activity: running,
      durationMinutes: 60,
      weightKg: 70.0,
    );
    // 9.8 * 70 * 1 = 686
    expect(calories, equals(686));
  });

  test('UserProfile BMI calculation works correctly', () {
    const profile = UserProfile(
      heightCm: 180.0,
      currentWeightKg: 72.0,
    );
    // 72 / (1.8 * 1.8) = 22.22
    expect(profile.bmi.toStringAsFixed(1), equals('22.2'));
    expect(profile.bmiCategory, equals('Normal Weight'));
  });

  test('WorkoutEntry serialization and deserialization works', () {
    final entry = WorkoutEntry(
      activityTypeId: 'running',
      title: 'Morning 5k',
      durationMinutes: 30,
      caloriesBurned: 300,
      distanceKm: 5.0,
      intensity: WorkoutIntensity.high,
    );

    final jsonStr = entry.toJson();
    final restored = WorkoutEntry.fromJson(jsonStr);

    expect(restored.id, equals(entry.id));
    expect(restored.title, equals('Morning 5k'));
    expect(restored.caloriesBurned, equals(300));
    expect(restored.intensity, equals(WorkoutIntensity.high));
  });

  test('DailyMetric serialization and copyWith works', () {
    final metric = DailyMetric(
      dateString: '2026-10-09',
      steps: 8500,
      waterMl: 2200,
      weightKg: 72.5,
    );

    final updated = metric.copyWith(steps: 9000);
    expect(updated.steps, equals(9000));
    expect(updated.waterMl, equals(2200));

    final json = metric.toJson();
    final restored = DailyMetric.fromJson(json);
    expect(restored.steps, equals(8500));
  });

  test('FitnessState manages workouts and computations', () async {
    final repo = await FitnessRepository.init();
    final state = FitnessState(repo);

    final initialCount = state.workouts.length;
    final newWorkout = WorkoutEntry(
      activityTypeId: 'cycling',
      title: 'Road Cycling',
      durationMinutes: 40,
      caloriesBurned: 350,
    );

    await state.addWorkout(newWorkout);
    expect(state.workouts.length, equals(initialCount + 1));

    await state.addWater(500);
    expect(state.currentMetric.waterMl, greaterThanOrEqualTo(500));

    await state.deleteWorkout(newWorkout.id);
    expect(state.workouts.length, equals(initialCount));
  });

  testWidgets('FitnessTrackerApp smoke test and renders dashboard', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repo = await FitnessRepository.init();
    final state = FitnessState(repo);

    await tester.pumpWidget(FitnessTrackerApp(state: state));
    await tester.pump(const Duration(milliseconds: 200));

    // Verify splash screen components
    expect(find.text('SKIP'), findsOneWidget);

    // Tap SKIP to proceed to main dashboard
    await tester.tap(find.text('SKIP'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.textContaining('Hello, Alex!'), findsOneWidget);
    expect(find.text('Daily Activity Rings'), findsOneWidget);
    expect(find.text('Quick Log Actions'), findsOneWidget);
    expect(find.text('Active Calories'), findsOneWidget);
    expect(find.text('Steps Count'), findsOneWidget);
  });
}
