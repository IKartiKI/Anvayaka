// lib/screens/laborers_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/labour.dart';
import '../services/labour_service.dart';
import '../widgets/labour_card.dart';
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
    
    final List<Labour> labours = LabourService.getAllLabours();

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
              '${labours.length} Total Labourers',
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
                itemCount: labours.length,
                itemBuilder: (context, index) {
                  return LabourCard(labour: labours[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}