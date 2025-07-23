import 'package:uuid/uuid.dart';

class Task {
  /// Unique identifier for the task_manager
  final String id;

  /// Name of the task_manager
  String name;

  /// Description of the task_manager
  String description;

  /// Deadline for the task_manager
  DateTime? deadline;

  /// Whether the task is solved or not
  bool solved;

  /// Constructor for creating a new task_manager
  Task({
    String? id,
    required this.name,
    this.description = '',
    this.deadline,
    this.solved = false,
  }) : id = id ?? const Uuid().v4();

  /// Convert task_manager to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'deadline': deadline?.toIso8601String(),
      'solved': solved,
    };
  }

  /// Create task_manager from JSON map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      solved: json['solved'] as bool? ?? false,
    );
  }

  /// Create a copy of this task_manager with optional new values
  Task copyWith({
    String? name,
    String? description,
    DateTime? deadline,
    bool? solved,
  }) {
    return Task(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      solved: solved ?? this.solved,
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, name: $name, description: $description, deadline: $deadline, solved: $solved}';
  }
}

