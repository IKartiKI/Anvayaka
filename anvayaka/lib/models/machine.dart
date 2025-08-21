// lib/models/machine.dart
class Machine {
  final String name;
  final String machineId;
  final String status;
  final double temperature;
  final int serviceProgress;
  final int serviceTotal;
  final DateTime serviceDue;
  final int runningHours;
  // just to see this on github

  Machine({
    required this.name,
    required this.machineId,
    required this.status,
    required this.temperature,
    required this.serviceProgress,
    required this.serviceTotal,
    required this.serviceDue,
    required this.runningHours,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      name: json['name'],
      machineId: json['machineId'],
      status: json['status'],
      temperature: json['temperature'],
      serviceProgress: json['serviceProgress'],
      serviceTotal: json['serviceTotal'],
      serviceDue: DateTime.parse(json['serviceDue']),
      runningHours: json['runningHours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'machineId': machineId,
      'status': status,
      'temperature': temperature,
      'serviceProgress': serviceProgress,
      'serviceTotal': serviceTotal,
      'serviceDue': serviceDue.toIso8601String(),
      'runningHours': runningHours,
    };
  }
}