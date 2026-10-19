# SplitFive (FitTrack) — Offline-First Flutter Workout Tracker

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite_(sqflite)-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![Provider](https://img.shields.io/badge/Provider_State-7B2CBF?style=for-the-badge&logo=flutter&logoColor=white)
![fl_chart](https://img.shields.io/badge/fl__chart-FF6B6B?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

> Log workouts, watch your progress, and own your data — no account, no cloud, no friction.

---

## 🎯 Project Overview & Business Value

Mainstream fitness apps gate basic tracking behind sign-ups, ads, and subscriptions. **FitTrack** is deliberately **offline-first**: every workout lives on the device in SQLite, the app works in airplane mode, and nothing personal ever leaves the phone. It targets lifters and casual athletes who want fast, private, distraction-free workout logging.

---

## ✨ Key Features

- **Exercise logging** — record exercises with sets, reps, and weight in a fast add-workout flow.
- **Progress charts & weekly summaries** — `fl_chart` visualizations on a dedicated stats screen.
- **Home dashboard** — recent sessions and quick actions at a glance.
- **100% local storage** — SQLite via `sqflite`; zero sign-up, zero network dependency.

### 📸 Screenshots

> Add captures to a `docs/screenshots/` folder and reference them here:

```html
<p align="center">
  <img src="docs/screenshots/home.png" alt="Home dashboard" width="260" />
  <img src="docs/screenshots/add_workout.png" alt="Add workout" width="260" />
  <img src="docs/screenshots/stats.png" alt="Progress charts" width="260" />
</p>
```

---

## 🏗️ System Architecture & Tech Stack

**Pattern:** Layered Flutter app — screens → Provider state → a single data-access service → SQLite. All SQL lives behind one testable seam.

**Data flow:**

```
UI (Screens) ──> Provider (state & notify) ──> DatabaseService ──> sqflite (SQLite)
     └──────────── fl_chart renders stats from DB aggregates
```

| Layer | Files | Responsibility |
|---|---|---|
| Screens | `lib/screens/home_screen.dart`, `add_workout_screen.dart`, `stats_screen.dart` | UI & interaction |
| State | Provider (`provider: ^6.1.1`) | Reactive state propagation |
| Data | `lib/services/database_service.dart` | All SQLite CRUD in one place |
| Utilities | `intl` (dates), `fl_chart` (charts) | Formatting & visualization |

---

## 🗄️ Database Schema & Entity Overview (on-device)

- **workouts** — `id`, `name`, `date`, `notes`
- **exercises / sets** — `id`, `workout_id` (FK), `name`, `sets`, `reps`, `weight`

One workout has many logged exercises; stats are aggregated over the `date` column for weekly summaries.

---

## 🚀 Getting Started

**Prerequisites:** Flutter SDK ≥ 3.0 (stable channel)

```bash
git clone https://github.com/Khalid341/splitfive.git
cd splitfive
flutter pub get
flutter run
```

No Firebase, no backend, no API keys — everything runs locally out of the box.

---

## 🔒 Security & Best Practices Implemented

- **Privacy by architecture** — no PII ever leaves the device; no analytics SDKs.
- **Single data-access seam** — all SQL in `DatabaseService`, preventing scattered/raw queries in UI code.
- **Linted codebase** — `flutter_lints` enforced; strong Dart 3 typing throughout.
- **Parameterized sqflite queries** — safe against injection even in local storage.

---

## 🗺️ Roadmap

- [ ] Custom workout templates / routines
- [ ] Body measurement tracking
- [ ] CSV export & local backup
- [ ] Optional cloud sync (Firebase, `me-central2` region)
- [ ] Rest-timer and plate calculator

## 🤝 Contributing

Fork, branch (`git checkout -b feature/your-feature`), run `flutter analyze` before committing, and open a PR against `master`. Keep SQL inside `DatabaseService` and UI free of data-layer code.

## 📄 License

Distributed under the MIT License.
