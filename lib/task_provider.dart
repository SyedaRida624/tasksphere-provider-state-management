import 'package:flutter/material.dart';
import 'task_model.dart'; // Ensure your Task model has final properties and a copyWith method

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  // Expose an unmodifiable view of the tasks to prevent accidental direct mutation
  List<Task> get tasks => List.unmodifiable(_tasks);

  int get completedTasksCount => _tasks.where((task) => task.isCompleted).length;
  int get pendingTasksCount => _tasks.where((task) => !task.isCompleted).length;

  // Add Task
  void addTask(String title, String description) {
    if (title.trim().isEmpty) return;

    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      dateTime: DateTime.now(),
    );
    _tasks.insert(0, newTask); // Newest tasks at the top
    notifyListeners(); // This triggers UI updates in real-time
  }

  // Toggle Task Status
  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      // FIX: Replace the instance with an updated copy so List.unmodifiable registers the structural change
      _tasks[index] = _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
      notifyListeners();
    }
  }

  // Update Task Text
  void updateTask(String id, String newTitle, String newDescription) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = Task(
        id: id,
        title: newTitle,
        description: newDescription,
        dateTime: _tasks[index].dateTime,
        isCompleted: _tasks[index].isCompleted,
      );
      notifyListeners();
    }
  }

  // Delete Task
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}