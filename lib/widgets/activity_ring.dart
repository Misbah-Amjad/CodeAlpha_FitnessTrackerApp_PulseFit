import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ActivityRingWidget extends StatefulWidget {
  final double caloriesProgress; // 0.0 to 1.0+
  final double stepsProgress;
  final double activeTimeProgress;
  final double waterProgress;
  final int calories;
  final int caloriesGoal;
  final int steps;
  final int stepsGoal;
  final int activeMins;
  final int activeMinsGoal;
  final int waterMl;
  final int waterGoal;

  const ActivityRingWidget({
    super.key,
    required this.caloriesProgress,
    required this.stepsProgress,
    required this.activeTimeProgress,
    required this.waterProgress,
    required this.calories,
    required this.caloriesGoal,
    required this.steps,
    required this.stepsGoal,
    required this.activeMins,
    required this.activeMinsGoal,
    required this.waterMl,
    required this.waterGoal,
  });

  @override
  State<ActivityRingWidget> createState() => _ActivityRingWidgetState();
}

class _ActivityRingWidgetState extends State<ActivityRingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _anim;
  int _selectedRingIndex = 0; // 0: Calories, 1: Steps, 2: Active Time, 3: Water

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant ActivityRingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.caloriesProgress != widget.caloriesProgress ||
        oldWidget.stepsProgress != widget.stepsProgress ||
        oldWidget.activeTimeProgress != widget.activeTimeProgress ||
        oldWidget.waterProgress != widget.waterProgress) {
      _animController.reset();
      _animController.forward();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Activity Rings',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tap ring tabs to inspect progress',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 13, color: AppColors.primary),
                    const SizedBox(width: 3),
                    Text(
                      '${((widget.caloriesProgress + widget.stepsProgress + widget.activeTimeProgress + widget.waterProgress) / 4 * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              // Concentric Animated Rings
              Expanded(
                flex: 5,
                child: Center(
                  child: SizedBox(
                    width: 155,
                    height: 155,
                    child: AnimatedBuilder(
                      animation: _anim,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: ConcentricRingsPainter(
                            caloriesProgress: widget.caloriesProgress * _anim.value,
                            stepsProgress: widget.stepsProgress * _anim.value,
                            activeTimeProgress: widget.activeTimeProgress * _anim.value,
                            waterProgress: widget.waterProgress * _anim.value,
                            isDark: isDark,
                          ),
                          child: Center(
                            child: _buildCenterInfo(isDark),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Ring Legend and Selection
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    _buildRingLegendItem(
                      index: 0,
                      label: 'Calories',
                      value: '${widget.calories} / ${widget.caloriesGoal} kcal',
                      progress: widget.caloriesProgress,
                      color: AppColors.coral,
                      icon: Icons.local_fire_department_rounded,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildRingLegendItem(
                      index: 1,
                      label: 'Steps',
                      value: '${widget.steps} / ${widget.stepsGoal}',
                      progress: widget.stepsProgress,
                      color: AppColors.primary,
                      icon: Icons.directions_walk_rounded,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildRingLegendItem(
                      index: 2,
                      label: 'Active Time',
                      value: '${widget.activeMins} / ${widget.activeMinsGoal} mins',
                      progress: widget.activeTimeProgress,
                      color: AppColors.purple,
                      icon: Icons.timer_rounded,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildRingLegendItem(
                      index: 3,
                      label: 'Hydration',
                      value: '${widget.waterMl} / ${widget.waterGoal} ml',
                      progress: widget.waterProgress,
                      color: AppColors.cyan,
                      icon: Icons.water_drop_rounded,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCenterInfo(bool isDark) {
    String title = 'Calories';
    String value = '${widget.calories}';
    String unit = 'kcal';
    Color color = AppColors.coral;

    if (_selectedRingIndex == 1) {
      title = 'Steps';
      value = '${widget.steps}';
      unit = 'steps';
      color = AppColors.primary;
    } else if (_selectedRingIndex == 2) {
      title = 'Active';
      value = '${widget.activeMins}';
      unit = 'min';
      color = AppColors.purple;
    } else if (_selectedRingIndex == 3) {
      title = 'Water';
      value = '${widget.waterMl}';
      unit = 'ml';
      color = AppColors.cyan;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            height: 1.1,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildRingLegendItem({
    required int index,
    required String label,
    required String value,
    required double progress,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _selectedRingIndex == index;
    final pct = (progress * 100).toInt();

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRingIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(isDark ? 0.2 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color.withOpacity(0.5) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 13, color: color),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$pct%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConcentricRingsPainter extends CustomPainter {
  final double caloriesProgress;
  final double stepsProgress;
  final double activeTimeProgress;
  final double waterProgress;
  final bool isDark;

  ConcentricRingsPainter({
    required this.caloriesProgress,
    required this.stepsProgress,
    required this.activeTimeProgress,
    required this.waterProgress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 10.0;
    const ringSpacing = 4.0;

    final rings = [
      {'color': AppColors.coral, 'progress': caloriesProgress, 'radius': size.width / 2 - strokeWidth / 2},
      {'color': AppColors.primary, 'progress': stepsProgress, 'radius': size.width / 2 - strokeWidth / 2 - strokeWidth - ringSpacing},
      {'color': AppColors.purple, 'progress': activeTimeProgress, 'radius': size.width / 2 - strokeWidth / 2 - (strokeWidth + ringSpacing) * 2},
      {'color': AppColors.cyan, 'progress': waterProgress, 'radius': size.width / 2 - strokeWidth / 2 - (strokeWidth + ringSpacing) * 3},
    ];

    for (var ring in rings) {
      final color = ring['color'] as Color;
      final progress = (ring['progress'] as double).clamp(0.0, 1.0);
      final radius = ring['radius'] as double;

      // Background track
      final trackPaint = Paint()
        ..color = isDark ? color.withOpacity(0.18) : color.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(center, radius, trackPaint);

      // Active Arc
      if (progress > 0) {
        final activePaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

        final sweepAngle = 2 * math.pi * progress;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -math.pi / 2,
          sweepAngle,
          false,
          activePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ConcentricRingsPainter oldDelegate) {
    return oldDelegate.caloriesProgress != caloriesProgress ||
        oldDelegate.stepsProgress != stepsProgress ||
        oldDelegate.activeTimeProgress != activeTimeProgress ||
        oldDelegate.waterProgress != waterProgress ||
        oldDelegate.isDark != isDark;
  }
}
