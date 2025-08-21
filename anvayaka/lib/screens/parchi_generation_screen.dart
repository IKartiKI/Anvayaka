// lib/screens/parchi_generation_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../widgets/parchi_generation_form.dart';

class ParchiGenerationScreen extends StatefulWidget {
  const ParchiGenerationScreen({super.key});

  @override
  _ParchiGenerationScreenState createState() => _ParchiGenerationScreenState();
}

class _ParchiGenerationScreenState extends State<ParchiGenerationScreen> {
  List<Map<String, dynamic>> _assignedTasks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAssignedTasks();
  }

  Future<void> _loadAssignedTasks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final tasks = await ApiService.getAssignedTasks();
      setState(() {
        _assignedTasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
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
                'Assigned Tasks',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: _loadAssignedTasks,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
              ),
            ],
          ),
          const Text(
            'View all assigned tasks and their details',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (_error != null)
            Center(
              child: Column(
                children: [
                  Text(
                    'Error: $_error',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadAssignedTasks,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else if (_assignedTasks.isEmpty)
            const Center(
              child: Text(
                'No assigned tasks found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _assignedTasks.length,
                itemBuilder: (context, index) {
                  final task = _assignedTasks[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  task['name'] ?? 'Unnamed Task',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Task ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            task['description'] ?? 'No description available',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 12),
                                                     Row(
                             children: [
                               const Icon(
                                 Icons.calendar_today,
                                 size: 16,
                                 color: Colors.grey,
                               ),
                               const SizedBox(width: 8),
                               Text(
                                 'Due: ${_formatDate(task['due_date'] ?? '')}',
                                 style: const TextStyle(
                                   fontSize: 14,
                                   color: Colors.grey,
                                 ),
                               ),
                             ],
                           ),
                           const SizedBox(height: 16),
                           SizedBox(
                             width: double.infinity,
                             child: ElevatedButton.icon(
                               onPressed: () {
                                 showDialog(
                                   context: context,
                                   builder: (context) => ParchiGenerationForm(task: task),
                                 );
                               },
                               icon: const Icon(Icons.assignment, size: 18),
                               label: const Text('Generate Parchi'),
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.green,
                                 foregroundColor: Colors.white,
                                 padding: const EdgeInsets.symmetric(vertical: 12),
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                               ),
                             ),
                           ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}