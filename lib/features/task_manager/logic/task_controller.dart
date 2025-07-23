import 'package:dart_task_manager/extensions.dart';

import '../entities/task.dart';
import 'task_service.dart';
import 'package:mcp_server/mcp_server.dart';

class TaskController {
  final TaskService taskService;

  TaskController({TaskService? taskService}) : taskService = taskService ?? TaskService();

  Future<CallToolResult> listTasks() async {
    final tasks = taskService.getAllTasks();
    return CallToolResultExt.send({
      'tasks': [...tasks.map((task) => task.toJson())],
    });
  }

  Future<CallToolResult> createTask(Task task) async {
    final createdTask = taskService.addTask(task);
    return CallToolResultExt.send(createdTask.toJson());
  }

  Future<CallToolResult> updateTask(Task task) async {
    final existingTask = taskService.getTaskById(task.id);
    Map<String, dynamic> result = {};

    if (existingTask == null) {
      result = {'success': false, 'task_manager': null};
    } else {
      final updatedTask = taskService.updateTask(task.id, task);
      result = {'success': updatedTask != null, 'task_manager': updatedTask?.toJson()};
    }

    return CallToolResultExt.send(result);
  }

  Future<CallToolResult> deleteTask(String id) async {
    final success = taskService.deleteTask(id);
    return CallToolResultExt.send({'success': success});
  }
}
