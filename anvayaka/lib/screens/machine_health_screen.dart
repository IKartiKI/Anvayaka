// lib/screens/machine_health_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/machine.dart';
import '../widgets/machine_card.dart';

class MachineHealthScreen extends StatelessWidget {
  const MachineHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive grid configuration
    final crossAxisCount = screenWidth < 600 ? 1 : 2;
    final childAspectRatio = screenWidth < 600 ? 1.6 : 1.2;
    
    final List<Machine> machines = [
      Machine(
        name: 'CNC Machine 1',
        machineId: 'M001',
        status: 'Healthy',
        temperature: 45.0,
        serviceProgress: 1450,
        serviceTotal: 2000,
        serviceDue: DateTime(2024, 9, 15),
        runningHours: 1250,
      ),
      Machine(
        name: 'Welding Station A',
        machineId: 'M002',
        status: 'Warning',
        temperature: 72.0,
        serviceProgress: 1980,
        serviceTotal: 2000,
        serviceDue: DateTime(2024, 8, 20),
        runningHours: 1890,
      ),
      Machine(
        name: 'Paint Booth 1',
        machineId: 'M003',
        status: 'Critical',
        temperature: 38.0,
        serviceProgress: 2100,
        serviceTotal: 2000,
        serviceDue: DateTime(2024, 8, 5),
        runningHours: 2150,
      ),
      Machine(
        name: 'Assembly Line B',
        machineId: 'M004',
        status: 'Healthy',
        temperature: 42.0,
        serviceProgress: 850,
        serviceTotal: 1500,
        serviceDue: DateTime(2024, 10, 1),
        runningHours: 890,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Machine Health',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Live monitoring and temperatures',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            '4 Machines Monitored',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: machines.length,
              itemBuilder: (context, index) {
                return MachineCard(machine: machines[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}