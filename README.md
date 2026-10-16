# PulseFit • Modern Fitness Tracker Application

A modern, polished, and feature-complete fitness tracking application developed in Flutter. Built with professional UI/UX design principles, sleek glassmorphism aesthetics, responsive layouts, interactive charts, and offline-first local persistence.

---

## 🌟 Core Features & Highlights

### 1. 📊 Interactive Dashboard & Activity Rings
- **Apple/Garmin-style Concentric Activity Rings**: Animated real-time visual progress rings for **Active Calories**, **Steps**, **Active Minutes**, and **Hydration**.
- **Interactive Ring Inspector**: Tap on any ring legend (Calories, Steps, Active, Water) to dynamically highlight metrics and percentage completions.
- **Metric Cards Grid**: Glassmorphism cards displaying live values, target completion progress bars, and one-tap quick-entry actions.
- **Dynamic Date Navigator**: Seamlessly view and log workouts for today, yesterday, or any past calendar date.
- **Active Workout Streaks**: Motivational streak counter tracking consecutive days of consistency.
- **Today's Timeline**: Interactive feed of all logged workouts with options to view, edit, or delete entries.

### 2. 🏋️ Comprehensive Manual Workout & Activity Logging
- **12+ Exercise Categories**: Running, Cycling, Swimming, Walking, Weight Lifting, HIIT/Circuit, Yoga, Pilates, Boxing, Hiking, Jump Rope, and Custom Exercises.
- **Smart MET-based Calorie Estimator**: Automatically calculates calories burned based on scientific Metabolic Equivalent of Task (MET) formula, exercise duration, user body weight, and workout intensity.
- **Manual Calorie Override**: One-tap toggle allowing precise manual calorie entry whenever needed.
- **Strength & Resistance Tracking**: Log sets, reps, and weight lifted (kg).
- **Cardio & Vitals Support**: Log distance covered (km), average heart rate (bpm), and detailed session notes.
- **Intensity Selector**: Low (Casual), Moderate (Steady), High (Intense), and Extreme (Max Effort).

### 3. 📈 Advanced Analytics & Visual Reports
- **Multi-Period Switcher**: Toggle between 7-Day (Weekly) and 30-Day (Monthly) performance analysis.
- **Weekly & Monthly Bar Charts**: Gradient bar graphs for Calories, Steps, Active Time, and Water with day-by-day interactive tooltips.
- **Workout Category Donut Chart**: Breakdown of workout volume across Cardio, Strength, Flexibility, Sports, and Outdoor activities.
- **Weight Progress Trend Line**: Curved line graph illustrating weight fluctuations over time compared against your target goal weight.
- **Personal Records (PRs) & Highlights**: Instant recognition for Peak Single-Session Burn, Highest Daily Steps, Longest Workout Session, and Best Streak.
- **Daily Averages Breakdown**: Comprehensive summary table of average daily metrics.

### 4. 📖 Searchable Workout Log Book (History)
- Real-time search across workout titles, notes, and activity types.
- Category filters (Cardio, Strength, Flexibility, Sports, Outdoor).
- Filter summary banner displaying total session count, aggregate calories burned, and total exercise time.
- Tap to edit existing logs or delete with a confirmation dialog.

### 5. 🎯 Custom Goals & Gamification Badges
- **Personalized Target Customizer**: Interactive sliders for Daily Steps, Daily Calorie Burn, Water Hydration (ml), Active Exercise Minutes, Sleep Goal (hrs), and Target Body Weight (kg).
- **Milestones & Achievement Badges**: Gamified achievements (e.g., *First Step*, *Hydration Hero*, *Calorie Crusher*, *Consistency Starter*, *10k Club*, *Centurion*, *Cross-Trainer*) with animated progress indicators.

### 6. 👤 Profile, BMI & Local Storage Management
- User profile configuration (Name, Age, Gender, Height, Weight).
- Automatic BMI (Body Mass Index) calculation with status indicator.
- Unit system selection (Metric vs Imperial).
- **Theme Switcher**: Dark Mode (sleek slate & neon accents) and Light Mode.
- **JSON Data Export & Import**: Backup all fitness records as a JSON file or copy to clipboard; restore anytime.
- **Demo Data Reset**: Instant reset option to restore a pre-populated 7-day realistic workout dataset for testing.

---

## 🛠️ Architecture & Tech Stack

- **Framework**: Flutter 3.38+ / Dart 3.10+
- **State Management**: Reactive `ChangeNotifier` (`FitnessState`)
- **Data Persistence**: `shared_preferences` with JSON serialization/deserialization
- **Charts & Visuals**: `fl_chart` + Custom Canvas `CustomPainter`
- **Typography & Styling**: `google_fonts` (Plus Jakarta Sans)
- **Unique IDs**: `uuid`
- **Internationalization & Formatting**: `intl`

### Directory Structure
```
lib/
├── main.dart                          # Application entry point & theme configuration
├── models/
│   ├── activity_type.dart             # Exercise categories, icons, MET factors
│   ├── workout_entry.dart             # Workout log model & JSON serialization
│   ├── daily_metric.dart              # Daily steps, hydration, sleep & weight
│   ├── goal_settings.dart             # User daily target goals
│   ├── user_profile.dart              # User profile & BMI calculation
│   └── achievement.dart               # Gamification badges & milestones
├── services/
│   ├── fitness_repository.dart        # SharedPreferences persistence & seed data
│   └── fitness_state.dart             # Core reactive state provider
├── theme/
│   ├── app_colors.dart                # Theme palettes, neon gradients, status colors
│   └── app_theme.dart                 # Dark and Light ThemeData definitions
├── widgets/
│   ├── activity_ring.dart             # Concentric animated activity rings
│   ├── metric_card.dart               # Metric stat card with progress bars
│   ├── weekly_bar_chart.dart          # Bar charts for calories, steps, water
│   ├── category_distribution_chart.dart # Donut chart for workout categories
│   ├── weight_trend_chart.dart        # Line chart for weight progression
│   ├── workout_card.dart              # Workout card with badges & details
│   ├── achievement_badge_card.dart    # Milestone badge cards
│   └── quick_log_sheet.dart           # Modal sheets for water, steps, sleep, weight
└── screens/
    ├── main_navigation_screen.dart    # Bottom navigation controller & FAB
    ├── dashboard_screen.dart          # Main dashboard overview
    ├── analytics_screen.dart          # Progress reports & trend analytics
    ├── history_screen.dart            # Searchable & filterable workout log book
    ├── goals_screen.dart              # Goals adjustment & achievements
    ├── profile_screen.dart            # Profile, BMI gauge, settings, export/import
    └── log_workout_screen.dart        # Manual workout logger & MET calculator
```

---

## 🚀 How to Run the App

### Prerequisites
1. Ensure Flutter is installed on your machine:
   ```bash
   flutter --version
   ```
2. Get project dependencies:
   ```bash
   flutter pub get
   ```

### Run on Chrome / Web:
```bash
flutter run -d chrome
```

### Run on Windows Desktop:
```bash
flutter run -d windows
```

### Run on Connected Android / iOS Device or Emulator:
```bash
flutter run
```

### Run Unit and Widget Tests:
```bash
flutter test
```
