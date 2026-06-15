# FitTrack — Flutter Fitness Tracker

A workout and activity tracking app built with Flutter and local SQLite storage.

## Features
- Exercise logging with sets, reps, and weight
- Custom workout templates
- Progress charts and weekly summaries
- Body measurement tracking
- Local SQLite storage (no sign-up needed)
- Dark mode

## Tech Stack
- Flutter / Dart
- sqflite (SQLite)
- fl_chart (visualizations)
- intl (date formatting)

## Getting Started

```bash
flutter pub get
flutter run
```

No Firebase or backend required — all data stored locally.

## Project Structure
```
lib/
  main.dart
  models/
    workout.dart
    exercise.dart
  screens/
    home_screen.dart
    add_workout_screen.dart
    stats_screen.dart
  services/
    database_service.dart
```
