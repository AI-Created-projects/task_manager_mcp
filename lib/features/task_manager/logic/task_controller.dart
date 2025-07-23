import '../entities/task.dart';
import '../entities/task_group.dart';
import 'task_service.dart';
import 'package:mcp_server/mcp_server.dart';

class TaskController {
  final TaskService taskService;

  TaskController({TaskService? taskService}) : taskService = taskService ?? TaskService();

  get listTasksInputSchema => {'type': 'object', 'properties': {}};

  Future<CallToolResult> listTasks(Map<String, dynamic> args) async {
    final tasks = taskService.getAllTasks();
    final taskList = tasks.map((task) => task.toJson()).toList();
    return CallToolResult(
      content: [
        Content.fromJson({'tasks': taskList}),
      ],
    );
  }

  get createTaskInputSchema => {
    'type': 'object',
    'properties': {
      'name': {'type': 'string', 'description': 'Name of the task_manager'},
      'description': {'type': 'string', 'description': 'Description of the task_manager'},
      'deadline': {'type': 'string', 'description': 'Deadline for the task_manager in ISO 8601 format (YYYY-MM-DD)'},
      'group': {'type': 'string', 'description': 'Group the task_manager belongs to (work, personal, open source)'},
    },
    'required': ['name', 'group'],
  };

  Future<CallToolResult> createTask(Map<String, dynamic> args) async {
    final name = args['name'] as String;
    final description = args['description'] as String? ?? '';
    final deadlineStr = args['deadline'] as String?;
    final groupStr = args['group'] as String;

    DateTime? deadline;
    if (deadlineStr != null && deadlineStr.isNotEmpty) {
      deadline = DateTime.parse(deadlineStr);
    }

    final group = TaskGroupExtension.fromString(groupStr);

    final task = Task(name: name, description: description, deadline: deadline, group: group);

    final createdTask = taskService.addTask(task);
    return CallToolResult(content: [Content.fromJson(createdTask.toJson())]);
  }

  get updateTaskInputSchema => {
    'type': 'object',
    'properties': {
      'id': {'type': 'string', 'description': 'ID of the task_manager to update'},
      'name': {'type': 'string', 'description': 'New name of the task_manager'},
      'description': {'type': 'string', 'description': 'New description of the task_manager'},
      'deadline': {
        'type': 'string',
        'description': 'New deadline for the task_manager in ISO 8601 format (YYYY-MM-DD)',
      },
      'group': {'type': 'string', 'description': 'New group the task_manager belongs to (work, personal, open source)'},
    },
    'required': ['id'],
  };

  Future<CallToolResult> updateTask(Map<String, dynamic> args) async {
    final id = args['id'] as String;
    final existingTask = taskService.getTaskById(id);

    if (existingTask == null) {
      return CallToolResult(
        content: [
          Content.fromJson({'success': false, 'task_manager': null}),
        ],
      );
    }

    final name = args['name'] as String? ?? existingTask.name;
    final description = args['description'] as String? ?? existingTask.description;
    final deadlineStr = args['deadline'] as String?;
    final groupStr = args['group'] as String?;

    DateTime? deadline = existingTask.deadline;
    if (deadlineStr != null) {
      if (deadlineStr.isEmpty) {
        deadline = null;
      } else {
        deadline = DateTime.parse(deadlineStr);
      }
    }

    TaskGroup group = existingTask.group;
    if (groupStr != null) {
      group = TaskGroupExtension.fromString(groupStr);
    }

    final updatedTask = Task(id: id, name: name, description: description, deadline: deadline, group: group);

    final result = taskService.updateTask(id, updatedTask);
    if (result != null) {
      return CallToolResult(
        content: [
          Content.fromJson({'success': true, 'task_manager': result.toJson()}),
        ],
      );
    } else {
      return CallToolResult(
        content: [
          Content.fromJson({'success': false, 'task_manager': null}),
        ],
      );
    }
  }

  get deleteTaskInputSchema => {
    'type': 'object',
    'properties': {
      'id': {'type': 'string', 'description': 'ID of the task_manager to delete'},
    },
    'required': ['id'],
  };

  Future<CallToolResult> deleteTask(Map<String, dynamic> args) async {
    final id = args['id'] as String;
    final success = taskService.deleteTask(id);
    return CallToolResult(
      content: [
        Content.fromJson({'success': success}),
      ],
    );
  }
}
