#                💪 PulseFit — Modern Fitness Tracker

<p align="center">
  <strong>Track Your Fitness. Build Your Best Self.</strong>
  <br>
  A modern Flutter application for tracking workouts, monitoring fitness progress, and building healthier habits.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/CodeAlpha-App%20Development%20Internship-blue" alt="CodeAlpha Internship">
  <img src="https://img.shields.io/badge/Flutter-Mobile%20Development-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Language-Dart-0175C2?logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Storage-Offline--First-success" alt="Offline First">
</p>

---

## 📌 About the Project

**PulseFit** is a fitness tracking application developed as part of my **CodeAlpha App Development Internship**. Built with Flutter and Dart, it combines a modern user interface with interactive visualizations and practical fitness management tools.

The application allows users to log workouts, monitor daily activity, set personalized goals, review performance analytics, and track achievements. It uses local data persistence to keep fitness records available on the device.

This project demonstrates my practical experience in Flutter UI development, state management, data handling, reusable widgets, and interactive dashboard design.

## ✨ Key Features

### 📊 Interactive Fitness Dashboard
- Animated activity rings for calories, steps, active minutes, and hydration.
- Fitness metric cards with progress indicators and quick actions.
- Date navigation for reviewing activity across different days.
- Workout streaks and a daily activity timeline.
- Options to edit and delete logged activities.

### 🏋️ Workout & Activity Tracking
- Support for 12+ exercise categories, including running, walking, cycling, swimming, strength training, yoga, and HIIT.
- Workout logging with duration, intensity, and activity-specific details.
- MET-based calorie estimation using activity, duration, body weight, and intensity.
- Strength workout tracking for sets, repetitions, and weights.
- Cardio details such as distance, average heart rate, and notes.
- Manual calorie entry when needed.

### 📈 Fitness Analytics
- Weekly and monthly performance reports.
- Interactive charts for calories, steps, active minutes, and hydration.
- Workout category distribution.
- Weight trend tracking and target comparison.
- Personal records and daily average metrics.

### 📖 Workout History
- Search workouts by title, notes, or activity type.
- Filter records by workout category.
- Review exercise duration, calories, and session counts.
- Edit or delete existing workout entries.

### 🎯 Goals & Achievements
- Personalized targets for steps, calories, hydration, active minutes, sleep, and body weight.
- Visual progress tracking.
- Achievement badges for milestones such as First Step, Hydration Hero, Calorie Crusher, and 10k Club.

### 👤 Profile & Personalization
- Personal fitness profile settings.
- BMI calculation based on entered measurements.
- Metric and imperial unit options.
- Light and dark themes.
- Import and export of fitness records in JSON format.
- Sample fitness data for exploring the application's features.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Application programming language |
| ChangeNotifier | State management |
| SharedPreferences | Local data persistence |
| JSON serialization | Storing and transferring local records |
| fl_chart | Interactive data visualizations |
| CustomPainter | Custom activity ring visuals |
| Google Fonts — Plus Jakarta Sans | Typography |
| UUID | Unique identifiers |
| intl | Date and time formatting |
| Visual Studio Code | Development environment |

## 📱 App Screenshots

Explore the main screens of PulseFit.

### 🚀 Launch & Splash

<p align="center">
  <img src="screenshots/launch%20screen.jpeg" width="180" alt="PulseFit Launch Screen">
  &nbsp;&nbsp;
  <img src="screenshots/splash%20screen.jpeg" width="180" alt="PulseFit Splash Screen">
</p>

### 🏠 Dashboard

<p align="center">
  <img src="screenshots/dashboard%20%20%20screen.jpeg" width="180" alt="PulseFit Dashboard">
  &nbsp;&nbsp;
  <img src="screenshots/dashboard%202.jpeg" width="180" alt="PulseFit Dashboard Overview">
</p>

### 🏋️ Workout Tracking

<p align="center">
  <img src="screenshots/add%20log%20workout%20screen.jpeg" width="180" alt="Add Workout Screen">
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
  <img src="screenshots/goals%20and%20badges%20screen%201.jpeg" width="180" alt="Goals and Badges Screen">
  &nbsp;&nbsp;
  <img src="screenshots/goals%20and%20badges%20screen%202.jpeg" width="180" alt="Goals and Badges Overview">
</p>

### 👤 Profile & Settings

<p align="center">
  <img src="screenshots/profile%20and%20setting%20screen.jpeg" width="180" alt="Profile and Settings">
  &nbsp;&nbsp;
  <img src="screenshots/edit%20profile%20screen.jpeg" width="180" alt="Edit Profile Screen">
</p>

## 🗂️ Project Structure

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

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK compatible with your Flutter installation
- Visual Studio Code or another Flutter-compatible IDE
- A configured device, emulator, or supported desktop environment

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/Misbah-Amjad/CodeAlpha_PulseFit.git
cd CodeAlpha_PulseFit
```

**2. Install dependencies**

```bash
flutter pub get
```

**3. Run the application**

For a connected Android device or configured emulator:

```bash
flutter run
```

For Chrome, if web support is configured:

```bash
flutter run -d chrome
```

For Windows desktop, if Windows desktop support is configured:

```bash
flutter run -d windows
```

**4. Run tests**

```bash
flutter test
```

## 💡 Skills Demonstrated

Through this project, I gained practical experience in:

- Building responsive Flutter interfaces and reusable UI components.
- Implementing state management with ChangeNotifier.
- Managing locally persisted application data.
- Creating interactive charts and custom-painted activity indicators.
- Handling workout records, user preferences, and date-based activity.
- Organizing application code into models, services, screens, themes, and widgets.
- Designing a consistent user experience with modern visual styling.

## 🎓 CodeAlpha Internship

PulseFit was developed as part of my **CodeAlpha App Development Internship**.

This project represents my hands-on practice in mobile application development and my continued growth as a Flutter developer. It also serves as part of my professional portfolio.

## 👩‍💻 Developer

**Misbah Amjad**  
Flutter Developer | BS Information Technology, University of Sahiwal

- **GitHub:** [Misbah-Amjad](https://github.com/Misbah-Amjad)
- **LinkedIn:** [Misbah Amjad](https://www.linkedin.com/in/misbahh-amjad/)

---

<p align="center">
  <strong>PulseFit — Track Your Progress. Celebrate Your Consistency. Keep Moving.</strong>
</p>