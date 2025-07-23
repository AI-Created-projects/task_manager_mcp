import 'package:mcp_client/mcp_client.dart';

void main() async {
  // Create client configuration
  final config = McpClient.simpleConfig(name: 'Example Client', version: '1.0.0', enableDebugLogging: true);

  // Create transport configuration
  final transportConfig = TransportConfig.sse(
    serverUrl: 'http://localhost:8081/sse',
    headers: {'User-Agent': 'MCP-Client/1.0'},
  );

  // Create and connect client
  final clientResult = await McpClient.createAndConnect(config: config, transportConfig: transportConfig);

  final client = clientResult.fold((c) => c, (error) => throw Exception('Failed to connect: $error'));

  // List available tools on the server
  final tools = await client.listTools();
  print('Available tools: ${tools.map((t) => t.name).join(', ')}');

  //// Call a tool
  //final result = await client.callTool('calculator', {'operation': 'add', 'a': 5, 'b': 3});
  //print('Result: ${(result.content.first as TextContent).text}');

  client.disconnect();
}
