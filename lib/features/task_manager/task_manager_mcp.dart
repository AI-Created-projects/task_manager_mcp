import 'package:dart_task_manager/features/task_manager/logic/task_service.dart';
import 'package:mcp_server/mcp_server.dart';

import 'logic/task_controller.dart';

class TaskManagerMcp {
  final TaskService repository;

  TaskManagerMcp({TaskService? repository}) : repository = repository ?? TaskService();

  void registerTools(Server server) {
    final taskController = TaskController(taskService: repository);
    server.addTool(
      name: 'create_task',
      description: 'Create a new task',
      inputSchema: taskController.createTaskInputSchema,
      handler: taskController.createTask,
    );

    server.addTool(
      name: 'list_tasks',
      description: 'List all tasks',
      inputSchema: taskController.listTasksInputSchema,
      handler: taskController.listTasks,
    );

    server.addTool(
      name: 'update_task',
      description: 'Update an existing task',
      inputSchema: taskController.updateTaskInputSchema,
      handler: taskController.updateTask,
    );

    server.addTool(
      name: 'delete_task',
      description: 'Delete a task',
      inputSchema: taskController.deleteTaskInputSchema,
      handler: taskController.deleteTask,
    );
  }
}