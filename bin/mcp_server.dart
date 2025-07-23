import 'package:mcp_server/mcp_server.dart';


void main() async {
  final serverResult = await McpServer.createAndStart(
    config: McpServer.simpleConfig(name: 'My Server', version: '1.0.0'),
    transportConfig: TransportConfig.sse(
      host: 'localhost',
      port: 8081,
      endpoint: '/sse',
      //isJsonResponseEnabled: true, // JSON response mode
    ),
  );

  serverResult.fold((server) async {
    server.addTool(
      name: 'calculator',
      description: 'Perform basic calculations',
      inputSchema: {
        'type': 'object',
        'properties': {
          'operation': {
            'type': 'string',
            'enum': ['add', 'subtract', 'multiply', 'divide'],
            'description': 'Mathematical operation to perform',
          },
          'a': {'type': 'number', 'description': 'First operand'},
          'b': {'type': 'number', 'description': 'Second operand'},
        },
        'required': ['operation', 'a', 'b'],
      },
      handler: (arguments) async {
        final operation = arguments['operation'] as String;
        final a = (arguments['a'] is int) ? (arguments['a'] as int).toDouble() : arguments['a'] as double;
        final b = (arguments['b'] is int) ? (arguments['b'] as int).toDouble() : arguments['b'] as double;

        double result;
        switch (operation) {
          case 'add':
            result = a + b;
            break;
          case 'subtract':
            result = a - b;
            break;
          case 'multiply':
            result = a * b;
            break;
          case 'divide':
            if (b == 0) {
              return CallToolResult(content: [TextContent(text: 'Division by zero error')], isError: true);
            }
            result = a / b;
            break;
          default:
            return CallToolResult(content: [TextContent(text: 'Unknown operation: $operation')], isError: true);
        }

        return CallToolResult(content: [TextContent(text: 'Result: $result')]);
      },
    );
  }, (error) => print('Server failed: $error'));
}
