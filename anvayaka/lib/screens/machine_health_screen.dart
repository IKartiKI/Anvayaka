// lib/screens/machine_health_screen.dart
import 'package:flutter/material.dart';
import '../models/machine.dart';
import '../widgets/machine_card.dart';
import '../services/api_service.dart'; // <-- Import your service

class MachineHealthScreen extends StatefulWidget {
  const MachineHealthScreen({super.key});

  @override
  _MachineHealthScreenState createState() => _MachineHealthScreenState();
}

class _MachineHealthScreenState extends State<MachineHealthScreen> {
  List<Machine> machines = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMachineData();
  }

  Future<void> _fetchMachineData() async {
    setState(() => isLoading = true);

    try {
      // Call API service to fetch new temp
      double temp = await ApiService.fetchLatestTemperature();

      setState(() {
        // If CNC Machine exists, update only its temperature
        final index = machines.indexWhere((m) => m.machineId == 'M001');
        if (index != -1) {
          machines[index] = machines[index].copyWith(temperature: temp);
        } else {
          // If list is empty initially, add CNC Machine
          machines.add(
            Machine(
              name: 'CNC Machine 1',
              machineId: 'M001',
              status: 'Healthy',
              temperature: temp,
              serviceProgress: 1450,
              serviceTotal: 2000,
              serviceDue: DateTime(2024, 9, 15),
              runningHours: 1250,
            ),
          );

          // Also add the other machines only once (initial load)
          machines.addAll([
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
          ]);
        }
      });
    } catch (e) {
      debugPrint("Error fetching machine data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 1 : 2;
    final childAspectRatio = screenWidth < 600 ? 1.6 : 1.2;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Machine Health',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Live monitoring and temperatures',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _fetchMachineData,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
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
