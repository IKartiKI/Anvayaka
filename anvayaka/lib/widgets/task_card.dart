// lib/widgets/task_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getTimeRemaining(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    if (difference.isNegative) {
      return '${difference.inDays.abs()} days overdue';
    } else {
      return '${difference.inDays} days';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.status,
                    style: TextStyle(color: _getStatusColor(task.status), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              task.description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              'Progress',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            LinearPercentIndicator(
              lineHeight: 8.0,
              percent: task.progress,
              backgroundColor: Colors.grey[200]!,
              progressColor: Colors.blue,
              barRadius: const Radius.circular(4),
              trailing: Text('${(task.progress * 100).toInt()}%'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Due: ${DateFormat('dd/MM/yyyy').format(task.dueDate)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.timer, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _getTimeRemaining(task.dueDate),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Assigned Workers',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: task.assignedWorkers.map((worker) {
                return CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  radius: 12,
                  child: Text(
                    worker,
                    style: const TextStyle(fontSize: 10, color: Colors.blue),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}