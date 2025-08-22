class Machine {
  final String name;
  final String machineId;
  final String status;
  final double temperature;
  final int serviceProgress;
  final int serviceTotal;
  final DateTime serviceDue;
  final int runningHours;

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

  Machine copyWith({
    String? name,
    String? machineId,
    String? status,
    double? temperature,
    int? serviceProgress,
    int? serviceTotal,
    DateTime? serviceDue,
    int? runningHours,
  }) {
    return Machine(
      name: name ?? this.name,
      machineId: machineId ?? this.machineId,
      status: status ?? this.status,
      temperature: temperature ?? this.temperature,
      serviceProgress: serviceProgress ?? this.serviceProgress,
      serviceTotal: serviceTotal ?? this.serviceTotal,
      serviceDue: serviceDue ?? this.serviceDue,
      runningHours: runningHours ?? this.runningHours,
    );
  }
}
