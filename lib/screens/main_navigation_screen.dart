import 'package:flutter/material.dart';
import '../services/fitness_state.dart';
import '../theme/app_colors.dart';
import 'dashboard_screen.dart';
import 'analytics_screen.dart';
import 'history_screen.dart';
import 'goals_screen.dart';
import 'profile_screen.dart';
import 'log_workout_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final FitnessState state;

  const MainNavigationScreen({
    super.key,
    required this.state,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screens = [
      DashboardScreen(state: widget.state),
      AnalyticsScreen(state: widget.state),
      HistoryScreen(state: widget.state),
      GoalsScreen(state: widget.state),
      ProfileScreen(state: widget.state),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              activeIcon: Icon(Icons.dashboard_rounded, color: AppColors.primary),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_rounded),
              activeIcon: Icon(Icons.insights_rounded, color: AppColors.primary),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_rounded),
              activeIcon: Icon(Icons.fitness_center_rounded, color: AppColors.primary),
              label: 'Log Book',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.military_tech_rounded),
              activeIcon: Icon(Icons.military_tech_rounded, color: AppColors.primary),
              label: 'Goals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              activeIcon: Icon(Icons.person_rounded, color: AppColors.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              heroTag: null,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              elevation: 4,
              tooltip: 'Quick Log Workout',
              child: const Icon(Icons.add_rounded, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LogWorkoutScreen(state: widget.state),
                  ),
                );
              },
            )
          : null,
    );
  }
}
