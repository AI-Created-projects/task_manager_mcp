import 'package:dart_task_manager/features/task_manager/task_manager_mcp.dart';
import 'package:mcp_server/mcp_server.dart';

void main() async {
  final serverResult = await McpServer.createAndStart(
    config: McpServer.simpleConfig(name: 'My Server', version: '1.0.0'),
    transportConfig: TransportConfig.sse(
      host: 'localhost',
      port: 8081,
      endpoint: '/sse',
    ),
  );

  serverResult.fold((server) async {
    TaskManagerMcp taskManagerServer = TaskManagerMcp();
    taskManagerServer.registerTools(server);
  }, (error) => print('Server failed: $error'));
}
