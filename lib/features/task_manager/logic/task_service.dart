import 'package:dart_task_manager/features/task_manager/entities/task.dart';

class TaskService {
  final List<Task> _tasks = [];

  /// Get all tasks
  List<Task> getAllTasks() {
    return List.unmodifiable(_tasks);
  }

  /// Get task_manager by ID
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add a new task_manager
  Task addTask(Task task) {
    _tasks.add(task);
    return task;
  }

  /// Update an existing task_manager
  Task? updateTask(String id, Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      // Create a new task_manager with the same ID but updated properties
      final task = Task(
        id: id,
        name: updatedTask.name,
        description: updatedTask.description,
        deadline: updatedTask.deadline,
        solved: updatedTask.solved,
      );
      _tasks[index] = task;
      return task;
    }
    return null;
  }

  /// Delete a task_manager by ID
  bool deleteTask(String id) {
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == id);
    return _tasks.length < initialLength;
  }
}
