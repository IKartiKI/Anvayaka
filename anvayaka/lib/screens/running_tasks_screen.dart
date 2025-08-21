// lib/screens/running_tasks_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../services/api_service.dart';
import '../widgets/task_card.dart';

class RunningTasksScreen extends StatefulWidget {
  const RunningTasksScreen({super.key});

  @override
  _RunningTasksScreenState createState() => _RunningTasksScreenState();
}

class _RunningTasksScreenState extends State<RunningTasksScreen> {
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;
  String? _error;
  Map<String, int> _taskProgress = {};
  Map<String, Timer> _progressTimers = {};
  String? _activeTaskId;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final tasks = await ApiService.getTasks();
      
      // Sort tasks by creation date (assuming there's a created_at field, otherwise by ID)
      // Latest tasks first (descending order)
      final sortedTasks = List<Map<String, dynamic>>.from(tasks);
      sortedTasks.sort((a, b) {
        // Try to sort by created_at if available, otherwise by ID (assuming newer IDs come later)
        final aCreatedAt = a['created_at'];
        final bCreatedAt = b['created_at'];
        
        if (aCreatedAt != null && bCreatedAt != null) {
          return DateTime.parse(bCreatedAt).compareTo(DateTime.parse(aCreatedAt));
        } else {
          // Fallback: sort by ID (assuming newer tasks have later IDs)
          final aId = a['id']?.toString() ?? '';
          final bId = b['id']?.toString() ?? '';
          return bId.compareTo(aId);
        }
      });
      
      setState(() {
        _tasks = sortedTasks;
        _isLoading = false;
      });

      // No auto-linking or polling. Initialize static progress for all tasks.
      _stopAllLiveUpdates();
      _activeTaskId = null;
      _taskProgress.clear();
      int staticIndex = 0;
      for (final t in sortedTasks) {
        final tid = t['id']?.toString();
        if (tid == null) continue;
        final staticProgress = [0.25, 0.45, 0.75, 0.90][staticIndex % 4];
        staticIndex++;
        final totalQuantity = t['quantity'] ?? 100;
        _taskProgress[tid] = (staticProgress * totalQuantity).round();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  bool _isActiveTask(Map<String, dynamic> task) {
    final status = (task['status'] ?? '').toString().toLowerCase();
    final isActiveFlag = task['is_active'] == true;
    return isActiveFlag || status == 'active' || status == 'in progress' || status == 'in_progress';
  }

  String _getStatus(Map<String, dynamic> task) {
    final dueDate = DateTime.parse(task['due_date'] ?? DateTime.now().toIso8601String());
    final now = DateTime.now();
    
    if (dueDate.isBefore(now)) {
      return 'Overdue';
    } else if (task['status'] == 'completed') {
      return 'Completed';
    } else {
      return 'In Progress';
    }
  }

  double _getProgress(Map<String, dynamic> task) {
    final taskId = task['id']?.toString() ?? '';
    final completedQuantity = _taskProgress[taskId] ?? 0;
    final totalQuantity = task['quantity'] ?? 1;
    
    if (totalQuantity <= 0) return 0.0;
    return (completedQuantity / totalQuantity).clamp(0.0, 1.0);
  }

  Future<void> _startLiveUpdateForTask(String taskId) async {
    try {
      print('[RunningTasks] Link pressed. Starting live update for task: $taskId');
      await ApiService.startLiveUpdate(taskId);
      print('[RunningTasks] MQTT listener started successfully for task: $taskId');
    } catch (e) {
      print('[RunningTasks] Error starting live update for task $taskId: $e');
    }
  }

  Future<void> _updateTaskProgress(String taskId) async {
    try {
      final response = await ApiService.getLiveUpdate(taskId);
      final completedQuantity = response['completed_quantity'] ?? 0;
      
      print('[RunningTasks] Updated progress for task $taskId: $completedQuantity items');
      
      if (mounted) {
        setState(() {
          _taskProgress[taskId] = completedQuantity;
        });
      }
    } catch (e) {
      print('[RunningTasks] Error updating progress for task $taskId: $e');
    }
  }

  void _stopLiveUpdateForTask(String taskId) {
    print('[RunningTasks] Stopping live update for task: $taskId');
    _progressTimers[taskId]?.cancel();
    _progressTimers.remove(taskId);
  }

  void _stopAllLiveUpdates() {
    print('[RunningTasks] Stopping all live updates');
    for (var timer in _progressTimers.values) {
      timer.cancel();
    }
    _progressTimers.clear();
  }

  @override
  void dispose() {
    _stopAllLiveUpdates();
    super.dispose();
  }

  List<String> _getAssignedWorkers(Map<String, dynamic> task) {
    // For now, return static initials based on task type
    // This can be made dynamic later when we have worker assignment data
    final taskName = task['name']?.toString().toLowerCase() ?? '';
    if (taskName.contains('cutting')) {
      return ['VK', 'RK'];
    } else if (taskName.contains('stitching')) {
      return ['PS', 'RP'];
    } else if (taskName.contains('assembly')) {
      return ['SD', 'SP'];
    } else if (taskName.contains('packing')) {
      return ['VY', 'SS'];
    } else {
      return ['RK', 'PS'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Running Tasks',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: _loadTasks,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
              ),
            ],
          ),
          const Text(
            'Monitor active work assignments',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            '${_tasks.length} Total Tasks',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_error != null)
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Error: $_error',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadTasks,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_tasks.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No tasks found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return _buildTaskCard(task);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final status = _getStatus(task);
    final progress = _getProgress(task);
    final assignedWorkers = _getAssignedWorkers(task);
    final dueDate = DateTime.parse(task['due_date'] ?? DateTime.now().toIso8601String());

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
                Expanded(
                  child: Text(
                    task['name'] ?? 'Unnamed Task',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: _getStatusColor(status), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              task['description'] ?? 'No description available',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final taskId = task['id']?.toString();
                    if (taskId == null) return;
                    // Make this task the only active one and start polling
                    _stopAllLiveUpdates();
                    setState(() {
                      _activeTaskId = taskId;
                    });
                    await _startLiveUpdateForTask(taskId);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Live update linked for this task')),
                    );
                  },
                  icon: const Icon(Icons.link, color: Colors.blue),
                  label: const Text('Link', style: TextStyle(color: Colors.blue)),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () async {
                    final taskId = task['id']?.toString();
                    if (taskId == null) return;
                    await _updateTaskProgress(taskId);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Progress refreshed')),
                    );
                  },
                  icon: const Icon(Icons.refresh, color: Colors.teal),
                  label: const Text('Refresh', style: TextStyle(color: Colors.teal)),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () async {
                    final taskId = task['id']?.toString();
                    if (taskId == null) return;
                    try {
                      // Stop live updates for this task if any
                      _stopLiveUpdateForTask(taskId);
                      await ApiService.deleteTask(taskId);
                      if (!mounted) return;
                      setState(() {
                        _tasks.removeWhere((t) => (t['id']?.toString() ?? '') == taskId);
                        _taskProgress.remove(taskId);
                        if (_activeTaskId == taskId) {
                          _activeTaskId = null;
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Task deleted successfully')),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete task: $e')),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${_taskProgress[task['id']?.toString() ?? ''] ?? 0}/${task['quantity'] ?? 0} items',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearPercentIndicator(
              lineHeight: 8.0,
              percent: progress,
              backgroundColor: Colors.grey[200]!,
              progressColor: Colors.blue,
              barRadius: const Radius.circular(4),
              trailing: Text('${(progress * 100).toInt()}%'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Due: ${DateFormat('dd/MM/yyyy').format(dueDate)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.timer, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _getTimeRemaining(dueDate),
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
              children: assignedWorkers.map((worker) {
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
}