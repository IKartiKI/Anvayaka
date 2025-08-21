// lib/screens/running_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';

class RunningTasksScreen extends StatelessWidget {
  const RunningTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Task> tasks = [
      Task(
        name: 'Weld Frame Assembly',
        description: 'Complete welding of 20 frame units',
        status: 'In Progress',
        progress: 0.75,
        dueDate: DateTime(2024, 8, 15),
        assignedWorkers: ['RK', 'VY'],
      ),
      Task(
        name: 'Quality Inspection',
        description: 'Inspect 50 finished products',
        status: 'Completed',
        progress: 1.0,
        dueDate: DateTime(2024, 8, 12),
        assignedWorkers: ['AS'],
      ),
      Task(
        name: 'Paint Finishing',
        description: 'Paint 15 assembled units',
        status: 'Overdue',
        progress: 0.3,
        dueDate: DateTime(2024, 8, 10),
        assignedWorkers: ['SD'],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Running Tasks',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Monitor active work assignments',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            '2 Active Tasks',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(task: tasks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}