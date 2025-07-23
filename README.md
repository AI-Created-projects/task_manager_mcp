# Dart Task Manager MCP Server

Task Manager MCP Server is a Dart application that implements an MCP (Model Context Protocol) server for task management. The server provides tools for creating, viewing, editing, and deleting tasks.

## Project Description

This project implements a simple task manager as an MCP server using the [mcp_server](https://pub.dev/packages/mcp_server) and [mcp_client](https://pub.dev/packages/mcp_client) packages. The MCP server provides an interface for task management that can be used by AI assistants or other applications.

Each task has the following properties:
- **ID**: Unique identifier for the task
- **Name**: Name of the task
- **Description**: Description of the task
- **Deadline**: Deadline for completing the task
- **Group**: Group the task belongs to (work, personal, open source)

## Installation

### Requirements
- Dart SDK 3.8.0 or higher

### Installation Steps

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd dart_task_manager
   ```

2. Install dependencies:
   ```bash
   dart pub get
   ```

## Project Structure

```
dart_task_manager/
├── bin/
│   ├── mcp_client.dart    # Example MCP client implementation
│   └── mcp_server.dart    # Example MCP server implementation
├── lib/
│   ├── main.dart          # Server entry point
│   └── features/
│       └── task_manager/
│           ├── entities/
│           │   ├── task.dart        # Task entity
│           │   └── task_group.dart  # Task group enum
│           ├── logic/
│           │   ├── task_controller.dart  # MCP tool handlers
│           │   └── task_service.dart     # Task business logic
│           └── task_manager_mcp.dart     # MCP server configuration
```

## Running the MCP Server

To run the MCP server, use the following command:

```bash
dart run bin/mcp_server.dart
```

The server will start and listen on localhost:8081/sse. To stop the server, press `Ctrl+C`.

## Available Tools

The MCP server provides the following tools:

### 1. create_task

Creates a new task.

**Input Parameters:**
- `name` (string, required): Name of the task
- `description` (string, optional): Description of the task
- `deadline` (string, optional): Deadline for the task in ISO 8601 format (YYYY-MM-DD)
- `group` (string, required): Group the task belongs to (work, personal, open source)

**Output:**
- Object representing the created task

### 2. list_tasks

Returns a list of all tasks.

**Input Parameters:**
- None

**Output:**
- Array of objects representing tasks

### 3. update_task

Updates an existing task.

**Input Parameters:**
- `id` (string, required): ID of the task to update
- `name` (string, optional): New name of the task
- `description` (string, optional): New description of the task
- `deadline` (string, optional): New deadline for the task in ISO 8601 format (YYYY-MM-DD)
- `group` (string, optional): New group the task belongs to (work, personal, open source)

**Output:**
- Object with information about the success of the operation and the updated task

### 4. delete_task

Deletes a task.

**Input Parameters:**
- `id` (string, required): ID of the task to delete

**Output:**
- Object with information about the success of the operation

### 5. get_task

Gets a task by ID.

**Input Parameters:**
- `id` (string, required): ID of the task to get

**Output:**
- Object representing the task

### 6. calculator

Performs basic mathematical calculations.

**Input Parameters:**
- `operation` (string, required): Mathematical operation to perform (add, subtract, multiply, divide)
- `a` (number, required): First operand
- `b` (number, required): Second operand

**Output:**
- Text content with the calculation result

## Usage Examples

### Example 1: Using the MCP Server with an AI Assistant

1. Run the MCP server:
   ```bash
   dart run bin/mcp_server.dart
   ```

2. Connect an AI assistant to the MCP server.

3. Use the MCP server tools:

   ```
   // Create a new task
   use_mcp_tool(
     server_name: "task-manager",
     tool_name: "create_task",
     arguments: {
       "name": "Complete project",
       "description": "Implement all required features",
       "deadline": "2025-08-01",
       "group": "work"
     }
   )

   // Get list of tasks
   use_mcp_tool(
     server_name: "task-manager",
     tool_name: "list_tasks",
     arguments: {}
   )
   ```

### Example 2: Using the MCP Client

You can use the provided MCP client to interact with the server:

1. Run the MCP server:
   ```bash
   dart run bin/mcp_server.dart
   ```

2. In another terminal, run the MCP client:
   ```bash
   dart run bin/mcp_client.dart
   ```

3. The client will connect to the server and list available tools.

4. You can modify the client code to call specific tools:
   ```dart
   // Call the calculator tool
   final result = await client.callTool('calculator', {'operation': 'add', 'a': 5, 'b': 3});
   print('Result: ${(result.content.first as TextContent).text}');
   
   // Create a task
   final taskResult = await client.callTool('create_task', {
     'name': 'New Task',
     'description': 'Task description',
     'deadline': '2025-08-01',
     'group': 'work'
   });
   ```

## Testing

To run tests, use the following command:

```bash
dart test
```

## License

This project is licensed under the [MIT License](LICENSE).
