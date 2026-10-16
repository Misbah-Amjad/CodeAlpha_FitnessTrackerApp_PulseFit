import 'package:flutter/material.dart';
import '../services/fitness_state.dart';
import '../theme/app_colors.dart';

class QuickLogSheet {
  static void showWaterLogger(BuildContext context, FitnessState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _WaterLogModal(state: state),
    );
  }

  static void showStepsLogger(BuildContext context, FitnessState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _StepsLogModal(state: state),
    );
  }

  static void showWeightLogger(BuildContext context, FitnessState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _WeightLogModal(state: state),
    );
  }

  static void showSleepLogger(BuildContext context, FitnessState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _SleepLogModal(state: state),
    );
  }
}

class _WaterLogModal extends StatefulWidget {
  final FitnessState state;
  const _WaterLogModal({required this.state});

  @override
  State<_WaterLogModal> createState() => _WaterLogModalState();
}

class _WaterLogModalState extends State<_WaterLogModal> {
  final TextEditingController _customCtrl = TextEditingController();

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentWater = widget.state.selectedDateWaterMl;
    final goal = widget.state.goals.dailyWaterMlGoal;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.water_drop_rounded, color: AppColors.cyan, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Log Water Intake',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Current: $currentWater / $goal ml (${((currentWater / (goal == 0 ? 1 : goal)) * 100).toInt()}%)',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Preset Buttons
            Row(
              children: [
                Expanded(
                  child: _buildPresetButton(
                    context,
                    '+250 ml',
                    'Glass',
                    Icons.local_drink_rounded,
                    () {
                      widget.state.addWater(250);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added 250 ml of water!')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPresetButton(
                    context,
                    '+500 ml',
                    'Bottle',
                    Icons.water_rounded,
                    () {
                      widget.state.addWater(500);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added 500 ml of water!')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPresetButton(
                    context,
                    '+750 ml',
                    'Flask',
                    Icons.sports_bar_rounded,
                    () {
                      widget.state.addWater(750);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added 750 ml of water!')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Custom Total (ml)',
                      hintText: 'e.g. 2400',
                      prefixIcon: Icon(Icons.edit_rounded, size: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cyan,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  ),
                  onPressed: () {
                    final val = int.tryParse(_customCtrl.text);
                    if (val != null && val >= 0) {
                      widget.state.setWater(val);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Water intake updated to $val ml!')),
                      );
                    }
                  },
                  child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardHover : AppColors.lightCardHover,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.cyan.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.cyan, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepsLogModal extends StatefulWidget {
  final FitnessState state;
  const _StepsLogModal({required this.state});

  @override
  State<_StepsLogModal> createState() => _StepsLogModalState();
}

class _StepsLogModalState extends State<_StepsLogModal> {
  late TextEditingController _stepsCtrl;

  @override
  void initState() {
    super.initState();
    _stepsCtrl = TextEditingController(text: '${widget.state.selectedDateSteps}');
  }

  @override
  void dispose() {
    _stepsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.directions_walk_rounded, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Log Daily Steps',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Update total steps walked today',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Quick adder pills
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAddPill('+1,000', 1000),
                _buildAddPill('+2,500', 2500),
                _buildAddPill('+5,000', 5000),
              ],
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _stepsCtrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Total Steps Today',
                hintText: 'e.g. 8500',
                prefixIcon: Icon(Icons.directions_walk_rounded),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final steps = int.tryParse(_stepsCtrl.text);
                  if (steps != null && steps >= 0) {
                    widget.state.setSteps(steps);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Steps updated to $steps!')),
                    );
                  }
                },
                child: const Text('Save Step Count'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPill(String label, int add) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        final cur = int.tryParse(_stepsCtrl.text) ?? 0;
        _stepsCtrl.text = '${cur + add}';
      },
    );
  }
}

class _WeightLogModal extends StatefulWidget {
  final FitnessState state;
  const _WeightLogModal({required this.state});

  @override
  State<_WeightLogModal> createState() => _WeightLogModalState();
}

class _WeightLogModalState extends State<_WeightLogModal> {
  late TextEditingController _weightCtrl;

  @override
  void initState() {
    super.initState();
    final curWeight = widget.state.selectedDateWeight ?? widget.state.profile.currentWeightKg;
    _weightCtrl = TextEditingController(text: curWeight.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.monitor_weight_rounded, color: AppColors.secondary, size: 28),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Log Body Weight',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Record your weight check-in for today',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                hintText: 'e.g. 72.5',
                prefixIcon: Icon(Icons.scale_rounded),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  final weight = double.tryParse(_weightCtrl.text);
                  if (weight != null && weight > 20 && weight < 300) {
                    widget.state.setWeight(weight);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Weight recorded: ${weight.toStringAsFixed(1)} kg')),
                    );
                  }
                },
                child: const Text('Save Weight Entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SleepLogModal extends StatefulWidget {
  final FitnessState state;
  const _SleepLogModal({required this.state});

  @override
  State<_SleepLogModal> createState() => _SleepLogModalState();
}

class _SleepLogModalState extends State<_SleepLogModal> {
  double _sleepHours = 7.5;

  @override
  void initState() {
    super.initState();
    _sleepHours = widget.state.selectedDateSleep ?? 7.5;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bedtime_rounded, color: AppColors.purple, size: 28),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Log Sleep & Recovery',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Track last night’s total sleep duration',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '${_sleepHours.toStringAsFixed(1)} Hours',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.purple),
            ),
            Slider(
              value: _sleepHours,
              min: 3.0,
              max: 14.0,
              divisions: 22,
              activeColor: AppColors.purple,
              label: '${_sleepHours.toStringAsFixed(1)} hrs',
              onChanged: (val) {
                setState(() {
                  _sleepHours = val;
                });
              },
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  widget.state.setSleep(_sleepHours);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sleep logged: ${_sleepHours.toStringAsFixed(1)} hours')),
                  );
                },
                child: const Text('Save Sleep Log'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
