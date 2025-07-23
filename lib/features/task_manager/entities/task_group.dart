enum TaskGroup {
  work,
  personal,
  openSource,
}

extension TaskGroupExtension on TaskGroup {
  String toJson() {
    switch (this) {
      case TaskGroup.work:
        return 'work';
      case TaskGroup.personal:
        return 'personal';
      case TaskGroup.openSource:
        return 'open source';
    }
  }

  static TaskGroup fromString(String value) {
    switch (value.toLowerCase()) {
      case 'work':
        return TaskGroup.work;
      case 'personal':
        return TaskGroup.personal;
      case 'open source':
        return TaskGroup.openSource;
      default:
        throw ArgumentError('Invalid TaskGroup value: $value');
    }
  }
}

