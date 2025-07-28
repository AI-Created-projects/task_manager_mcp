import 'package:dart_task_manager/features/task_manager/logic/task_service.dart';
import 'package:mcp_server/mcp_server.dart';

import 'logic/task_controller.dart';

/// MCP server implementation for task management
class TaskManagerMcp {
  final TaskController _taskController;

  /// Constructor for TaskManagerMcp
  TaskManagerMcp({TaskService? taskService}) :
    _taskController = TaskController(taskService: taskService ?? TaskService());

  /// Register all tools with the MCP server
  void registerTools(Server server) {
    _registerProjectTools(server);
    _registerTaskTools(server);
  }

  /// Register project management tools
  void _registerProjectTools(Server server) {
    // List projects tool
    server.addTool(
      name: 'list_projects',
      description: 'List all projects',
      inputSchema: {'type': 'object', 'properties': {}},
      handler: (args) => _taskController.listProjects(),
    );
  }

  /// Register task management tools
  void _registerTaskTools(Server server) {
    // List all tasks
    server.addTool(
      name: 'list_tasks',
      description: 'List all tasks',
      inputSchema: {'type': 'object', 'properties': {}},
      handler: (args) => _taskController.listTasks(),
    );

    // List tasks by project
    server.addTool(
      name: 'list_tasks_by_project',
      description: 'List all tasks in a specific project',
      inputSchema: {
        'type': 'object',
        'properties': {
          'project_id': {'type': 'string', 'description': 'ID of the project'},
        },
        'required': ['project_id'],
      },
      handler: (args) => _taskController.listTasksByProject(args['project_id'] as String),
    );

    // Create task
    server.addTool(
      name: 'create_task',
      description: 'Create a new task or subtask',
      inputSchema: {
        'type': 'object',
        'properties': {
          'name': {'type': 'string', 'description': 'Name of the task'},
          'description': {'type': 'string', 'description': 'Description of the task'},
          'project_id': {'type': 'string', 'description': 'ID of the project this task belongs to'},
          'parent_id': {'type': 'string', 'description': 'ID of the parent task (for subtasks)'},
          'deadline': {
            'type': 'string',
            'description': 'Deadline for the task in ISO 8601 format (YYYY-MM-DD)',
          },
          'priority': {'type': 'integer', 'description': 'Priority of the task (1-4, where 4 is highest)'},
        },
        'required': ['name'],
      },
      handler: (args) => _taskController.createTask(
        name: args['name'] as String,
        description: args['description'] as String? ?? '',
        projectId: args['project_id'] as String?,
        parentId: args['parent_id'] as String?,
        deadline: args['deadline'] != null ? DateTime.parse(args['deadline'] as String) : null,
        priority: args['priority'] as int? ?? 1,
      ),
    );

    // Update task
    server.addTool(
      name: 'update_task',
      description: 'Update an existing task',
      inputSchema: {
        'type': 'object',
        'properties': {
          'id': {'type': 'string', 'description': 'ID of the task to update'},
          'name': {'type': 'string', 'description': 'New name of the task'},
          'description': {'type': 'string', 'description': 'New description of the task'},
          'project_id': {'type': 'string', 'description': 'New project ID for the task'},
          'deadline': {
            'type': 'string',
            'description': 'New deadline for the task in ISO 8601 format (YYYY-MM-DD)',
          },
          'solved': {'type': 'boolean', 'description': 'Whether the task is completed or not'},
          'priority': {'type': 'integer', 'description': 'New priority of the task (1-4, where 4 is highest)'},
        },
        'required': ['id'],
      },
      handler: (args) => _taskController.updateTask(
        id: args['id'] as String,
        name: args['name'] as String?,
        description: args['description'] as String?,
        projectId: args['project_id'] as String?,
        deadline: args['deadline'] != null ? DateTime.parse(args['deadline'] as String) : null,
        solved: args['solved'] as bool?,
        priority: args['priority'] as int?,
      ),
    );

    // Delete task
    server.addTool(
      name: 'delete_task',
      description: 'Delete a task',
      inputSchema: {
        'type': 'object',
        'properties': {
          'id': {'type': 'string', 'description': 'ID of the task to delete'},
        },
        'required': ['id'],
      },
      handler: (args) => _taskController.deleteTask(args['id'] as String),
    );
  }
}
