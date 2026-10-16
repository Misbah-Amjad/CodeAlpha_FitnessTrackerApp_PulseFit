import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/fitness_state.dart';
import '../theme/app_colors.dart';

enum ChartMetricType {
  calories,
  steps,
  activeMinutes,
  water,
}

class WeeklyBarChartWidget extends StatefulWidget {
  final List<DaySummary> summaries;
  final ChartMetricType initialType;

  const WeeklyBarChartWidget({
    super.key,
    required this.summaries,
    this.initialType = ChartMetricType.calories,
  });

  @override
  State<WeeklyBarChartWidget> createState() => _WeeklyBarChartWidgetState();
}

class _WeeklyBarChartWidgetState extends State<WeeklyBarChartWidget> {
  late ChartMetricType _selectedType;
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final summaries = widget.summaries;

    final isLongRange = summaries.length > 7;
    final timeframeStr = isLongRange ? 'Last ${summaries.length} Days' : 'Last 7 Days';

    Color barColor;
    LinearGradient barGradient;
    String unit;
    String title;

    switch (_selectedType) {
      case ChartMetricType.calories:
        barColor = AppColors.coral;
        barGradient = AppColors.calorieGradient;
        unit = 'kcal';
        title = 'Calories ($timeframeStr)';
        break;
      case ChartMetricType.steps:
        barColor = AppColors.primary;
        barGradient = AppColors.stepsGradient;
        unit = 'steps';
        title = 'Steps ($timeframeStr)';
        break;
      case ChartMetricType.activeMinutes:
        barColor = AppColors.purple;
        barGradient = AppColors.activeTimeGradient;
        unit = 'mins';
        title = 'Active Time ($timeframeStr)';
        break;
      case ChartMetricType.water:
        barColor = AppColors.cyan;
        barGradient = AppColors.waterGradient;
        unit = 'ml';
        title = 'Hydration ($timeframeStr)';
        break;
    }

    double maxVal = 0;
    double totalVal = 0;
    for (var s in summaries) {
      double val = _getValue(s);
      if (val > maxVal) maxVal = val;
      totalVal += val;
    }
    final avgVal = summaries.isNotEmpty ? (totalVal / summaries.length).round() : 0;
    if (maxVal == 0) maxVal = 100;
    final maxY = maxVal * 1.25;

    final double rodWidth = isLongRange
        ? (summaries.length > 20 ? 4.5 : 7.0)
        : 14.0;
    final double touchedRodWidth = isLongRange
        ? (summaries.length > 20 ? 7.0 : 10.0)
        : 18.0;

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
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Metric Switcher Pills
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Daily Avg: $avgVal $unit',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: barColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Metric Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTypeChip('Calories', ChartMetricType.calories, AppColors.coral, isDark),
                const SizedBox(width: 8),
                _buildTypeChip('Steps', ChartMetricType.steps, AppColors.primary, isDark),
                const SizedBox(width: 8),
                _buildTypeChip('Active Min', ChartMetricType.activeMinutes, AppColors.purple, isDark),
                const SizedBox(width: 8),
                _buildTypeChip('Water', ChartMetricType.water, AppColors.cyan, isDark),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Bar Chart
          SizedBox(
            height: 190,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) =>
                        isDark ? AppColors.darkCardHover : AppColors.lightTextPrimary,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final day = summaries[group.x.toInt()];
                      final dayName = DateFormat('EEE, MMM d').format(day.date);
                      return BarTooltipItem(
                        '$dayName\n',
                        const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.normal,
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text: '${rod.toY.toInt()} $unit',
                            style: TextStyle(
                              color: barColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  touchCallback: (event, response) {
                    if (response?.spot != null && event is! FlTapUpEvent) {
                      setState(() {
                        _touchedIndex = response!.spot!.touchedBarGroupIndex;
                      });
                    } else {
                      setState(() {
                        _touchedIndex = -1;
                      });
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      getTitlesWidget: (value, meta) {
                        if (value == 0 || value >= maxY) return const SizedBox.shrink();
                        if (value % (maxY / 3).round() != 0 && value != (maxY / 2).round()) {
                          return const SizedBox.shrink();
                        }
                        String text = value >= 1000 ? '${(value / 1000).toStringAsFixed(1)}k' : '${value.toInt()}';
                        return Text(
                          text,
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= summaries.length) return const SizedBox.shrink();
                        
                        // For long range (> 7 days), display at most 5 evenly distributed labels
                        if (isLongRange) {
                          final step = (summaries.length / 4).ceil();
                          final shouldShow = (idx % step == 0) || (idx == summaries.length - 1);
                          if (!shouldShow) return const SizedBox.shrink();

                          final d = summaries[idx].date;
                          return SideTitleWidget(
                            meta: meta,
                            space: 4,
                            child: Text(
                              DateFormat('M/d').format(d),
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }

                        // For 7 days or fewer, show day letter or 'Today'
                        final d = summaries[idx].date;
                        final isToday = DateFormat('yyyy-MM-dd').format(d) ==
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                        final dayLabel = DateFormat('E').format(d).substring(0, 1);

                        return SideTitleWidget(
                          meta: meta,
                          space: 4,
                          child: Text(
                            isToday ? 'Today' : dayLabel,
                            style: TextStyle(
                              color: isToday
                                  ? barColor
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                              fontSize: isToday ? 11 : 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: isDark ? AppColors.darkBorder.withOpacity(0.5) : AppColors.lightBorder,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                barGroups: List.generate(summaries.length, (i) {
                  final val = _getValue(summaries[i]);
                  final isTouched = i == _touchedIndex;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: val,
                        gradient: barGradient,
                        width: isTouched ? touchedRodWidth : rodWidth,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(isLongRange ? 3 : 8)),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY,
                          color: isDark ? AppColors.darkCardHover.withOpacity(0.4) : AppColors.lightBorder.withOpacity(0.5),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getValue(DaySummary summary) {
    switch (_selectedType) {
      case ChartMetricType.calories:
        return summary.calories.toDouble();
      case ChartMetricType.steps:
        return summary.steps.toDouble();
      case ChartMetricType.activeMinutes:
        return summary.activeMinutes.toDouble();
      case ChartMetricType.water:
        return summary.waterMl.toDouble();
    }
  }

  Widget _buildTypeChip(String label, ChartMetricType type, Color color, bool isDark) {
    final isSelected = _selectedType == type;
    return InkWell(
      onTap: () => setState(() => _selectedType = type),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : (isDark ? AppColors.darkCardHover : AppColors.lightCardHover),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }
}
