import 'package:dart_task_manager/extensions.dart';

import 'task_service.dart';
import 'todoist_repository.dart';
import 'package:mcp_server/mcp_server.dart';

/// Controller for handling task and project operations through MCP
class TaskController {
  final TaskService taskService;

  /// Constructor for TaskController
  TaskController({TaskService? taskService})
    : taskService = taskService ?? TaskService();

  /// List all tasks
  Future<CallToolResult> listTasks() async {
    try {
      final tasks = await taskService.listAllTasks();
      return CallToolResultExt.send({
        'success': true,
        'tasks': tasks.map((task) => task.toJson()).toList(),
      });
    } catch (e) {
      return _handleError(e, 'Failed to list tasks');
    }
  }

  /// List tasks for a specific project
  Future<CallToolResult> listTasksByProject(String projectId) async {
    try {
      final tasks = await taskService.getTasksByProject(projectId);
      return CallToolResultExt.send({
        'success': true,
        'tasks': tasks.map((task) => task.toJson()).toList(),
        'project_id': projectId,
      });
    } catch (e) {
      return _handleError(e, 'Failed to list tasks for project');
    }
  }

  /// Create a new task (handles both tasks and subtasks)
  Future<CallToolResult> createTask({
    required String name,
    String description = '',
    String? projectId,
    String? parentId,
    DateTime? deadline,
    int priority = 1,
  }) async {
    try {
      final createdTask = await taskService.createTask(
        name: name,
        description: description,
        projectId: projectId,
        parentId: parentId,
        deadline: deadline,
        priority: priority,
      );
      return CallToolResultExt.send({
        'success': true,
        'task': createdTask.toJson()
      });
    } catch (e) {
      return _handleError(e, 'Failed to create task');
    }
  }

  /// Update an existing task
  Future<CallToolResult> updateTask({
    required String id,
    String? name,
    String? description,
    String? projectId,
    DateTime? deadline,
    bool? solved,
    int? priority,
  }) async {
    try {
      final updatedTask = await taskService.updateTask(
        taskId: id,
        name: name,
        description: description,
        projectId: projectId,
        deadline: deadline,
        solved: solved,
        priority: priority,
      );
      return CallToolResultExt.send({
        'success': true,
        'task': updatedTask.toJson()
      });
    } catch (e) {
      return _handleError(e, 'Failed to update task');
    }
  }

  /// Delete a task by ID
  Future<CallToolResult> deleteTask(String id) async {
    try {
      final success = await taskService.deleteTask(id);
      return CallToolResultExt.send({
        'success': success,
        'id': id,
      });
    } catch (e) {
      return _handleError(e, 'Failed to delete task');
    }
  }

  /// List all projects
  Future<CallToolResult> listProjects() async {
    try {
      final projects = await taskService.listAllProjects();
      return CallToolResultExt.send({
        'success': true,
        'projects': projects.map((project) => project.toJson()).toList(),
      });
    } catch (e) {
      return _handleError(e, 'Failed to list projects');
    }
  }

  /// Handle errors and convert them to appropriate response format
  CallToolResult _handleError(dynamic error, String defaultMessage) {
    if (error is TodoistAuthException) {
      return CallToolResultExt.send({
        'success': false,
        'error': error.toString(),
        'code': 'AUTH_ERROR'
      });
    } else if (error is TodoistApiException) {
      return CallToolResultExt.send({
        'success': false,
        'error': error.toString(),
        'code': 'API_ERROR',
        'status': error.statusCode
      });
    } else if (error is TaskServiceException) {
      return CallToolResultExt.send({
        'success': false,
        'error': error.toString(),
        'code': 'SERVICE_ERROR'
      });
    } else {
      return CallToolResultExt.send({
        'success': false,
        'error': '$defaultMessage: ${error.toString()}',
        'code': 'UNKNOWN_ERROR'
      });
    }
  }
}
