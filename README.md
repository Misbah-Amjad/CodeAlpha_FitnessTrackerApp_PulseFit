# PulseFit • Modern Fitness Tracker Application

> **CodeAlpha App Development Internship Project**
>
> A Flutter-based fitness tracking application developed as part of my **CodeAlpha App Development Internship**.
>
> **PulseFit — Track Your Fitness. Build Your Best Self.**

---

PulseFit is a modern, polished fitness tracking application built with Flutter and Dart. It features a professional user interface, sleek glassmorphism aesthetics, interactive charts, personalized fitness goals, workout logging, progress analytics, and offline-first local data persistence.

## 🌟 Core Features & Highlights

### 1. 📊 Interactive Dashboard & Activity Rings
- **Concentric Activity Rings:** Animated progress rings for active calories, steps, active minutes, and hydration.
- **Interactive Ring Inspector:** Tap on ring legends to highlight metrics and completion percentages.
- **Metric Cards Grid:** Glassmorphism cards displaying fitness metrics, target progress, and quick-entry actions.
- **Dynamic Date Navigator:** View and log workouts for today, yesterday, or previous dates.
- **Active Workout Streaks:** Track consecutive days of fitness activity.
- **Today's Timeline:** View, edit, and delete logged workouts.

### 2. 🏋️ Comprehensive Workout & Activity Logging
- **12+ Exercise Categories:** Running, cycling, swimming, walking, weight lifting, HIIT, yoga, Pilates, boxing, hiking, jump rope, and custom exercises.
- **MET-Based Calorie Estimation:** Estimate calories burned based on activity, duration, body weight, and workout intensity.
- **Manual Calorie Override:** Enter custom calorie values when needed.
- **Strength Tracking:** Record sets, repetitions, and weights lifted.
- **Cardio Tracking:** Log distance, average heart rate, and session notes.
- **Intensity Selector:** Choose from low, moderate, high, and extreme intensity levels.

### 3. 📈 Advanced Analytics & Visual Reports
- **Weekly and Monthly Analytics:** Switch between 7-day and 30-day performance reports.
- **Interactive Bar Charts:** Visualize calories, steps, active minutes, and hydration.
- **Workout Category Distribution:** Explore activity breakdowns across workout categories.
- **Weight Trend Tracking:** Monitor weight changes against a target weight.
- **Personal Records:** Highlight peak calorie burn, highest daily steps, longest workout, and best streak.
- **Daily Averages:** Review average fitness metrics.

### 4. 📖 Searchable Workout History
- Search workout titles, notes, and activity types.
- Filter activities by category.
- Review session counts, calories burned, and total exercise duration.
- Edit existing workouts or delete entries with confirmation.

### 5. 🎯 Personalized Goals & Achievement Badges
- Customize daily targets for steps, calories, hydration, active minutes, sleep, and body weight.
- Earn achievement badges for milestones such as First Step, Hydration Hero, Calorie Crusher, and 10k Club.
- Track progress with visual indicators and gamified achievements.

### 6. 👤 Profile, BMI & Data Management
- Configure name, age, gender, height, and weight.
- Calculate Body Mass Index (BMI).
- Switch between metric and imperial units.
- Choose dark or light mode.
- Export and import fitness records in JSON format.
- Reset demo data to explore a sample 7-day workout dataset.

---

## 🛠️ Tech Stack & Architecture

- **Framework:** Flutter
- **Programming Language:** Dart
- **State Management:** ChangeNotifier
- **Local Persistence:** SharedPreferences with JSON serialization
- **Charts & Visualization:** fl_chart and CustomPainter
- **Typography:** Google Fonts — Plus Jakarta Sans
- **Unique Identifiers:** UUID
- **Date Formatting:** intl
- **Development Environment:** Visual Studio Code

## 📱 App Screenshots

Explore **PulseFit — Modern Fitness Tracker**, designed to help users track workouts, monitor progress, and build healthier habits.

### 🚀 Launch & Splash

<p align="center">
  <img src="screenshots/launch%20screen.jpeg" width="220" alt="PulseFit Launch Screen">
  &nbsp;&nbsp;
  <img src="screenshots/splash%20screen.jpeg" width="220" alt="PulseFit Splash Screen">
</p>

### 🏠 Dashboard

<p align="center">
  <img src="screenshots/dashboard%20%20%20screen.jpeg" width="180" alt="PulseFit Dashboard">
  &nbsp;&nbsp;
  <img src="screenshots/dashboard%202.jpeg" width="180" alt="PulseFit Dashboard Overview">
</p>

### 🏋️ Workout Tracking

<p align="center">
  <img src="screenshots/add%20log%20workout%20screen.jpeg" width="180" alt="Add Workout">
  &nbsp;&nbsp;
  <img src="screenshots/log%20book%20screen.jpeg" width="180" alt="Workout Log Book">
</p>

### 📊 Analytics & Progress

<p align="center">
  <img src="screenshots/analytics%20screen%201.jpeg" width="180" alt="Analytics Screen 1">
  &nbsp;&nbsp;
  <img src="screenshots/analytics%20screen%202.jpeg" width="180" alt="Analytics Screen 2">
  <br><br>
  <img src="screenshots/analytics%20screen%203.jpeg" width="180" alt="Analytics Screen 3">
  &nbsp;&nbsp;
  <img src="screenshots/analytics%20screen%204.jpeg" width="180" alt="Analytics Screen 4">
</p>

### 🎯 Goals & Achievements

<p align="center">
  <img src="screenshots/goals%20and%20badges%20screen%201.jpeg" width="180" alt="Goals and Badges">
  &nbsp;&nbsp;
  <img src="screenshots/goals%20and%20badges%20screen%202.jpeg" width="180" alt="Goals and Badges Overview">
</p>

### 👤 Profile & Settings

<p align="center">
  <img src="screenshots/profile%20and%20setting%20screen.jpeg" width="180" alt="Profile and Settings">
  &nbsp;&nbsp;
  <img src="screenshots/edit%20profile%20screen.jpeg" width="180" alt="Edit Profile">
</p>

## 📂 Project Structure

```text
lib/
├── main.dart
├── models/
│   ├── achievement.dart
│   ├── activity_type.dart
│   ├── daily_metric.dart
│   ├── goal_settings.dart
│   ├── user_profile.dart
│   └── workout_entry.dart
├── services/
│   ├── fitness_repository.dart
│   └── fitness_state.dart
├── theme/
│   ├── app_colors.dart
│   └── app_theme.dart
├── widgets/
│   ├── achievement_badge_card.dart
│   ├── activity_ring.dart
│   ├── category_distribution_chart.dart
│   ├── metric_card.dart
│   ├── quick_log_sheet.dart
│   ├── weekly_bar_chart.dart
│   ├── weight_trend_chart.dart
│   └── workout_card.dart
└── screens/
    ├── analytics_screen.dart
    ├── dashboard_screen.dart
    ├── goals_screen.dart
    ├── history_screen.dart
    ├── log_workout_screen.dart
    ├── main_navigation_screen.dart
    ├── profile_screen.dart
    └── splash_screen.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- Dart SDK compatible with your Flutter installation
- Visual Studio Code or another Flutter-compatible IDE

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/Misbah-Amjad/CodeAlpha_FitnessTrackerApp_PulseFit.git
cd CodeAlpha_FitnessTrackerApp_PulseFit
```

**2. Install dependencies**

```bash
flutter pub get
```

**3. Run the application**

For Chrome:

```bash
flutter run -d chrome
```

For Windows desktop:

```bash
flutter run -d windows
```

For a connected Android device or configured emulator:

```bash
flutter run
```

**4. Run tests**

```bash
flutter test
```

---

## 🎓 Internship Project Acknowledgment

**Developed as part of the CodeAlpha App Development Internship.**

PulseFit demonstrates my practical experience in Flutter application development, Dart programming, UI/UX implementation, state management, local data persistence, fitness analytics, and interactive mobile app interfaces.

## 👩‍💻 Developer

**Misbah Amjad**

- **GitHub:** [Misbah-Amjad](https://github.com/Misbah-Amjad)
- **LinkedIn:** [Misbah Amjad](https://www.linkedin.com/in/misbahh-amjad/)

---

*PulseFit — Track your progress. Celebrate your consistency. Keep moving.*

