// lib/screens/laborers_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/worker.dart';
import '../widgets/worker_card.dart';
import '../providers/app_provider.dart';

class LaborersScreen extends StatelessWidget {
  const LaborersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive grid configuration - always 2 columns but with better aspect ratio
    final crossAxisCount = 2;
    final childAspectRatio = screenWidth < 600 ? 1.2 : 1.6;
    
    final List<Worker> workers = [
      Worker(initials: 'RK', name: 'Raj Kumar', age: 32, expertise: 'Welding', status: 'active'),
      Worker(initials: 'PS', name: 'Priya Sharma', age: 28, expertise: 'Assembly', status: 'active'),
      Worker(initials: 'AS', name: 'Amit Singh', age: 45, expertise: 'Quality Control', status: 'idle'),
      Worker(initials: 'SD', name: 'Sunita Devi', age: 35, expertise: 'Painting', status: 'on-break'),
      Worker(initials: 'VY', name: 'Vikash Yadav', age: 29, expertise: 'Machine Operation', status: 'active'),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laborers',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Manage your workforce',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              '5 Total Workers',
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
                itemCount: workers.length,
                itemBuilder: (context, index) {
                  return WorkerCard(worker: workers[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}