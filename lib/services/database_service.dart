import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService extends ChangeNotifier {
  Database? _db;

  Future<void> initialize() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'fittrack.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE workouts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            date TEXT NOT NULL,
            duration INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE exercises (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            workoutId INTEGER NOT NULL,
            name TEXT NOT NULL,
            sets INTEGER,
            reps INTEGER,
            weight REAL,
            FOREIGN KEY (workoutId) REFERENCES workouts(id)
          )
        ''');
      },
    );
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getWorkouts() async {
    return _db!.query('workouts', orderBy: 'date DESC');
  }

  Future<List<Map<String, dynamic>>> getExercises(int workoutId) async {
    return _db!.query('exercises', where: 'workoutId = ?', whereArgs: [workoutId]);
  }

  Future<int> addWorkout(String name, String date, int duration) async {
    final id = await _db!.insert('workouts', {
      'name': name,
      'date': date,
      'duration': duration,
    });
    notifyListeners();
    return id;
  }

  Future<void> addExercise(int workoutId, String name, int sets, int reps, double weight) async {
    await _db!.insert('exercises', {
      'workoutId': workoutId,
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
    });
    notifyListeners();
  }

  Future<Map<String, double>> getStats() async {
    final workouts = await getWorkouts();
    final totalWorkouts = workouts.length;
    double totalVolume = 0;

    for (final w in workouts) {
      final exercises = await getExercises(w['id']);
      for (final e in exercises) {
        totalVolume += (e['sets'] ?? 0) * (e['reps'] ?? 0) * (e['weight'] ?? 0);
      }
    }

    return {
      'totalWorkouts': totalWorkouts.toDouble(),
      'totalVolume': totalVolume,
    };
  }

  // Weekly workout data for charts
  Future<List<Map<String, dynamic>>> getWeeklyData() async {
    final workouts = await _db!.rawQuery('''
      SELECT date, COUNT(*) as count, SUM(duration) as totalDuration
      FROM workouts
      WHERE date >= date('now', '-7 days')
      GROUP BY date
      ORDER BY date
    ''');
    return workouts;
  }
}
