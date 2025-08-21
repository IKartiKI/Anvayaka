// lib/models/task.dart
class Task {
  final String name;
  final String description;
  final String status;
  final double progress;
  final DateTime dueDate;
  final List<String> assignedWorkers;

  Task({
    required this.name,
    required this.description,
    required this.status,
    required this.progress,
    required this.dueDate,
    required this.assignedWorkers,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      description: json['description'],
      status: json['status'],
      progress: json['progress'],
      dueDate: DateTime.parse(json['dueDate']),
      assignedWorkers: List<String>.from(json['assignedWorkers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'progress': progress,
      'dueDate': dueDate.toIso8601String(),
      'assignedWorkers': assignedWorkers,
    };
  }
}