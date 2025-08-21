// lib/models/worker.dart
class Worker {
  final String initials;
  final String name;
  final int age;
  final String expertise;
  final String status;

  Worker({
    required this.initials,
    required this.name,
    required this.age,
    required this.expertise,
    required this.status,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      initials: json['initials'],
      name: json['name'],
      age: json['age'],
      expertise: json['expertise'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'initials': initials,
      'name': name,
      'age': age,
      'expertise': expertise,
      'status': status,
    };
  }
}