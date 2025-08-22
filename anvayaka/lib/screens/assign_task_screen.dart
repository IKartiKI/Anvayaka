// lib/screens/assign_task_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class AssignTaskScreen extends StatefulWidget {
  const AssignTaskScreen({super.key});

  @override
  _AssignTaskScreenState createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedTask;
  String _deliverables = '';
  DateTime? _deadline;
  String _quantity = '';
  bool _isLoading = false;
  final List<String> _tasks = [
    'Cutting',
    'Stitching & Tailoring',
    'Embroidery & Surface Work',
    'Ironing & Finishing',
    'Quality Checking',
    'Packaging',
  ];

  Future<void> _assignTask() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.assignTask(
        name: _selectedTask!,
        description: _deliverables,
        quantity: int.parse(_quantity),
        dueDate: _deadline!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task Assigned Successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Reset form
        _formKey.currentState!.reset();
        setState(() {
          _selectedTask = null;
          _deliverables = '';
          _deadline = null;
          _quantity = '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assign Task to Laborer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Create and manage work assignments',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Assign New Task',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Create and assign tasks to laborers',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Select Task'),
                        value: _selectedTask,
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Choose a task')),
                          ..._tasks.map((task) => DropdownMenuItem(
                            value: task,
                            child: Text(task),
                          )),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedTask = value;
                          });
                        },
                        validator: (value) => value == null ? 'Please select a task' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Deliverables'),
                        maxLines: 3,
                        onChanged: (value) => _deliverables = value,
                        validator: (value) => value!.isEmpty ? 'Please enter deliverables' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Quantity'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _quantity = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter quantity';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Deadline', suffixIcon: Icon(Icons.calendar_today)),
                        onTap: () async {
                          final now = DateTime.now();
                          final lastDate = DateTime(now.year + 2, 12, 31); // 2 years from now
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: now,
                            lastDate: lastDate,
                          );
                          if (picked != null) setState(() => _deadline = picked);
                        },
                        controller: TextEditingController(text: _deadline != null ? DateFormat('dd/MM/yyyy').format(_deadline!) : ''),
                        validator: (value) => _deadline == null ? 'Please select a deadline' : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : () async {
                          if (_formKey.currentState!.validate()) {
                            await _assignTask();
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: _isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                              )
                            : const Center(child: Text('Assign Task', style: TextStyle(color: Colors.white))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}