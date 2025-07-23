import 'dart:convert';

import 'package:mcp_server/mcp_server.dart';

extension CallToolResultExt on CallToolResult {
  static CallToolResult send(Map<String, dynamic> json) {
    return CallToolResult(
      content: [
        TextContent.fromJson({"text": jsonEncode(json)}),
      ],
    );
  }
}

