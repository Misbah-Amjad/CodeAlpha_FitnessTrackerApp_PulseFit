import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity_type.dart';
import '../models/workout_entry.dart';
import '../services/fitness_state.dart';
import '../theme/app_colors.dart';

class LogWorkoutScreen extends StatefulWidget {
  final FitnessState state;
  final WorkoutEntry? initialWorkout; // For editing if passed

  const LogWorkoutScreen({
    super.key,
    required this.state,
    this.initialWorkout,
  });

  @override
  State<LogWorkoutScreen> createState() => _LogWorkoutScreenState();
}

class _LogWorkoutScreenState extends State<LogWorkoutScreen> {
  late ActivityType _selectedActivity;
  late TextEditingController _titleCtrl;
  late TextEditingController _durationCtrl;
  late TextEditingController _caloriesCtrl;
  late TextEditingController _distanceCtrl;
  late TextEditingController _setsCtrl;
  late TextEditingController _repsCtrl;
  late TextEditingController _weightLiftedCtrl;
  late TextEditingController _heartRateCtrl;
  late TextEditingController _notesCtrl;

  late WorkoutIntensity _intensity;
  late DateTime _selectedDateTime;
  bool _manualCalories = false;
  bool _showStrengthDetails = false;

  @override
  void initState() {
    super.initState();
    final init = widget.initialWorkout;
    if (init != null) {
      _selectedActivity = init.activityType;
      _titleCtrl = TextEditingController(text: init.title);
      _durationCtrl = TextEditingController(text: '${init.durationMinutes}');
      _caloriesCtrl = TextEditingController(text: '${init.caloriesBurned}');
      _distanceCtrl = TextEditingController(text: init.distanceKm != null ? '${init.distanceKm}' : '');
      _setsCtrl = TextEditingController(text: init.sets != null ? '${init.sets}' : '');
      _repsCtrl = TextEditingController(text: init.reps != null ? '${init.reps}' : '');
      _weightLiftedCtrl = TextEditingController(text: init.weightLiftedKg != null ? '${init.weightLiftedKg}' : '');
      _heartRateCtrl = TextEditingController(text: init.avgHeartRate != null ? '${init.avgHeartRate}' : '');
      _notesCtrl = TextEditingController(text: init.notes ?? '');
      _intensity = init.intensity;
      _selectedDateTime = init.timestamp;
      _manualCalories = true;
      _showStrengthDetails = init.sets != null || init.weightLiftedKg != null;
    } else {
      _selectedActivity = ActivityType.all.first;
      _titleCtrl = TextEditingController(text: _selectedActivity.name);
      _durationCtrl = TextEditingController(text: '30');
      _distanceCtrl = TextEditingController();
      _setsCtrl = TextEditingController();
      _repsCtrl = TextEditingController();
      _weightLiftedCtrl = TextEditingController();
      _heartRateCtrl = TextEditingController();
      _notesCtrl = TextEditingController();
      _intensity = WorkoutIntensity.moderate;
      _selectedDateTime = DateTime.now();

      final initialEst = _calculateEstimatedCalories(30, _selectedActivity, _intensity);
      _caloriesCtrl = TextEditingController(text: '$initialEst');
      _showStrengthDetails = _selectedActivity.category == ActivityCategory.strength;
    }
  }

  int _calculateEstimatedCalories(int duration, ActivityType activity, WorkoutIntensity intensity) {
    final userWeight = widget.state.profile.currentWeightKg;
    final base = ActivityType.estimateCalories(
      activity: activity,
      durationMinutes: duration,
      weightKg: userWeight,
    );
    return (base * intensity.multiplier).round();
  }

  void _recalculateCalories() {
    if (!_manualCalories) {
      final dur = int.tryParse(_durationCtrl.text) ?? 0;
      final est = _calculateEstimatedCalories(dur, _selectedActivity, _intensity);
      _caloriesCtrl.text = '$est';
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _durationCtrl.dispose();
    _caloriesCtrl.dispose();
    _distanceCtrl.dispose();
    _setsCtrl.dispose();
    _repsCtrl.dispose();
    _weightLiftedCtrl.dispose();
    _heartRateCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialWorkout != null ? 'Edit Workout' : 'Log Workout'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.check_rounded, color: AppColors.primary),
            label: const Text(
              'Save',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onPressed: _saveWorkout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Exercise Selection
            Text(
              'Select Activity Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 105,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: ActivityType.all.length,
                separatorBuilder: (ctx, i) => const SizedBox(width: 12),
                itemBuilder: (ctx, i) {
                  final act = ActivityType.all[i];
                  final isSelected = act.id == _selectedActivity.id;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedActivity = act;
                        if (_titleCtrl.text.isEmpty ||
                            ActivityType.all.any((a) => a.name == _titleCtrl.text)) {
                          _titleCtrl.text = act.name;
                        }
                        if (act.category == ActivityCategory.strength) {
                          _showStrengthDetails = true;
                        }
                        _recalculateCalories();
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 85,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? act.color.withOpacity(isDark ? 0.25 : 0.15)
                            : (isDark ? AppColors.darkCard : AppColors.lightCard),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? act.color : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: act.color.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(act.icon, color: act.color, size: 22),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            act.name,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? (isDark ? Colors.white : AppColors.lightTextPrimary)
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Section 2: Workout Title
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                labelText: 'Workout Title',
                hintText: 'e.g. Morning 5k Jog, Chest Day',
                prefixIcon: Icon(_selectedActivity.icon, color: _selectedActivity.color),
              ),
            ),
            const SizedBox(height: 18),

            // Section 3: Duration & Calories
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _durationCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Duration (mins)',
                      hintText: '30',
                      prefixIcon: Icon(Icons.timer_rounded, color: AppColors.purple),
                    ),
                    onChanged: (val) => _recalculateCalories(),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextField(
                    controller: _caloriesCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Calories (kcal)',
                      hintText: '250',
                      prefixIcon: const Icon(Icons.local_fire_department_rounded, color: AppColors.coral),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _manualCalories ? Icons.lock_outline_rounded : Icons.auto_awesome_rounded,
                          size: 18,
                          color: _manualCalories ? AppColors.accent : AppColors.primary,
                        ),
                        tooltip: _manualCalories ? 'Manual Override (tap to auto-calculate)' : 'Auto-calculated',
                        onPressed: () {
                          setState(() {
                            _manualCalories = !_manualCalories;
                            if (!_manualCalories) _recalculateCalories();
                          });
                        },
                      ),
                    ),
                    onChanged: (val) => _manualCalories = true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Section 4: Intensity Level
            Text(
              'Intensity Level',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: WorkoutIntensity.values.map((intensity) {
                  final isSelected = _intensity == intensity;
                  Color color;
                  switch (intensity) {
                    case WorkoutIntensity.low:
                      color = AppColors.primary;
                      break;
                    case WorkoutIntensity.moderate:
                      color = AppColors.info;
                      break;
                    case WorkoutIntensity.high:
                      color = AppColors.accent;
                      break;
                    case WorkoutIntensity.extreme:
                      color = AppColors.coral;
                      break;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(intensity.displayName),
                      selected: isSelected,
                      selectedColor: color.withOpacity(0.25),
                      side: BorderSide(
                        color: isSelected ? color : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? color : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _intensity = intensity;
                            _recalculateCalories();
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 18),

            // Section 5: Date & Time Picker
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardHover : AppColors.lightCardHover,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              DateFormat('MMM d, yyyy').format(_selectedDateTime),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _pickTime,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardHover : AppColors.lightCardHover,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 18, color: AppColors.secondary),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('h:mm a').format(_selectedDateTime),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Optional Cardio & Vitals: Distance & Heart Rate
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _distanceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Distance (km) (optional)',
                      hintText: '5.2',
                      prefixIcon: Icon(Icons.route_rounded, color: AppColors.cyan),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextField(
                    controller: _heartRateCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Avg Heart Rate (bpm)',
                      hintText: '145',
                      prefixIcon: Icon(Icons.favorite_rounded, color: Colors.pinkAccent),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Toggle for Strength details (Sets, Reps, Weight Lifted)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Track Sets, Reps & Weight Lifted', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              value: _showStrengthDetails,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _showStrengthDetails = val),
            ),
            if (_showStrengthDetails) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _setsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Sets',
                        hintText: '4',
                        prefixIcon: Icon(Icons.repeat_rounded, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _repsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Reps/set',
                        hintText: '10',
                        prefixIcon: Icon(Icons.fitness_center_rounded, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _weightLiftedCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        hintText: '60',
                        prefixIcon: Icon(Icons.scale_rounded, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],

            // Notes field
            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Workout Notes & Highlights',
                hintText: 'Felt energized, completed all sets with strict form...',
                prefixIcon: Icon(Icons.edit_note_rounded),
              ),
            ),
            const SizedBox(height: 30),

            // Save Workout Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_rounded, size: 22),
                label: Text(
                  widget.initialWorkout != null ? 'Update Workout' : 'Log Workout Session',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _saveWorkout,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _saveWorkout() async {
    final title = _titleCtrl.text.trim().isEmpty ? _selectedActivity.name : _titleCtrl.text.trim();
    final duration = int.tryParse(_durationCtrl.text) ?? 30;
    final calories = int.tryParse(_caloriesCtrl.text) ?? _calculateEstimatedCalories(duration, _selectedActivity, _intensity);
    final distance = double.tryParse(_distanceCtrl.text);
    final sets = int.tryParse(_setsCtrl.text);
    final reps = int.tryParse(_repsCtrl.text);
    final weightLifted = double.tryParse(_weightLiftedCtrl.text);
    final heartRate = int.tryParse(_heartRateCtrl.text);
    final notes = _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim();

    final entry = WorkoutEntry(
      id: widget.initialWorkout?.id,
      activityTypeId: _selectedActivity.id,
      title: title,
      durationMinutes: duration,
      caloriesBurned: calories,
      distanceKm: distance,
      intensity: _intensity,
      timestamp: _selectedDateTime,
      notes: notes,
      sets: sets,
      reps: reps,
      weightLiftedKg: weightLifted,
      avgHeartRate: heartRate,
    );

    if (widget.initialWorkout != null) {
      await widget.state.deleteWorkout(widget.initialWorkout!.id);
    }
    await widget.state.addWorkout(entry);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully logged "$title" ($calories kcal)!'),
          backgroundColor: AppColors.primaryDark,
        ),
      );
    }
  }
}
