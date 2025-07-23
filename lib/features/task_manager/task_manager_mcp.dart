import 'package:dart_task_manager/features/task_manager/logic/task_service.dart';
import 'package:mcp_server/mcp_server.dart';

import 'entities/task.dart';
import 'logic/task_controller.dart';

class TaskManagerMcp {
  final TaskService repository;

  TaskManagerMcp({TaskService? repository}) : repository = repository ?? TaskService();

  void registerTools(Server server) {
    final taskController = TaskController(taskService: repository);
    server.addTool(
      name: 'create_task',
      description: 'Create a new task',
      inputSchema: {
        'type': 'object',
        'properties': {
          'name': {'type': 'string', 'description': 'Name of the task_manager'},
          'description': {'type': 'string', 'description': 'Description of the task_manager'},
          'deadline': {
            'type': 'string',
            'description': 'Deadline for the task_manager in ISO 8601 format (YYYY-MM-DD)',
          },
          'group': {'type': 'string', 'description': 'Group the task_manager belongs to (work, personal, open source)'},
        },
        'required': ['name', 'group'],
      },
      handler: (args) => taskController.createTask(Task.fromJson(args)),
    );

    server.addTool(
      name: 'list_tasks',
      description: 'List all tasks',
      inputSchema: {'type': 'object', 'properties': {}},
      handler: (args) => taskController.listTasks(),
    );

    server.addTool(
      name: 'update_task',
      description: 'Update an existing task',
      inputSchema: {
        'type': 'object',
        'properties': {
          'id': {'type': 'string', 'description': 'ID of the task_manager to update'},
          'name': {'type': 'string', 'description': 'New name of the task_manager'},
          'description': {'type': 'string', 'description': 'New description of the task_manager'},
          'deadline': {
            'type': 'string',
            'description': 'New deadline for the task_manager in ISO 8601 format (YYYY-MM-DD)',
          },
          'group': {
            'type': 'string',
            'description': 'New group the task_manager belongs to (work, personal, open source)',
          },
        },
        'required': ['id'],
      },
      handler: (args) => taskController.updateTask(Task.fromJson(args)),
    );

    server.addTool(
      name: 'delete_task',
      description: 'Delete a task',
      inputSchema: {
        'type': 'object',
        'properties': {
          'id': {'type': 'string', 'description': 'ID of the task_manager to delete'},
        },
        'required': ['id'],
      },
      handler: (args) => taskController.deleteTask(args['id'] as String),
    );
  }
}
