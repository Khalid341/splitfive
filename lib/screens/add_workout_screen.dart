import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _exerciseNameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  String _date = DateTime.now().toIso8601String().split('T')[0];
  final List<Map<String, String>> _exercises = [];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _date = picked.toIso8601String().split('T')[0];
      });
    }
  }

  void _addExercise() {
    if (_exerciseNameController.text.trim().isEmpty) return;
    setState(() {
      _exercises.add({
        'name': _exerciseNameController.text.trim(),
        'sets': _setsController.text,
        'reps': _repsController.text,
        'weight': _weightController.text,
      });
      _exerciseNameController.clear();
      _setsController.clear();
      _repsController.clear();
      _weightController.clear();
    });
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;
    final db = context.read<DatabaseService>();
    final workoutId = await db.addWorkout(
      _nameController.text.trim(),
      _date,
      int.tryParse(_durationController.text) ?? 0,
    );
    for (final e in _exercises) {
      await db.addExercise(
        workoutId,
        e['name']!,
        int.tryParse(e['sets'] ?? '0') ?? 0,
        int.tryParse(e['reps'] ?? '0') ?? 0,
        double.tryParse(e['weight'] ?? '0') ?? 0,
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Workout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Workout Name'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _durationController,
                  decoration: const InputDecoration(labelText: 'Duration (min)'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _pickDate,
                  child: Text(_date),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Exercises', style: TextStyle(fontWeight: 600)),
          const SizedBox(height: 8),
          ..._exercises.map((e) => Card(
                child: ListTile(
                  title: Text(e['name']!),
                  subtitle: Text('${e['sets']}x${e['reps']} @ ${e['weight']}kg'),
                ),
              )),
          const SizedBox(height: 12),
          TextField(
            controller: _exerciseNameController,
            decoration: const InputDecoration(labelText: 'Exercise Name'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _setsController,
                  decoration: const InputDecoration(labelText: 'Sets'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _repsController,
                  decoration: const InputDecoration(labelText: 'Reps'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _addExercise,
            icon: const Icon(Icons.add),
            label: const Text('Add Exercise'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _save,
            child: const Text('Save Workout'),
          ),
        ],
      ),
    );
  }
}
