// lib/screens/assign_task_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String _timeAllotted = '';
  final List<String> _workers = [
    'Raj Kumar (Cutting)',
    'Priya Sharma (Stitching)',
    'Amit Singh (Sole Attachment)',
    'Sunita Devi (Assembly)',
    'Vikash Yadav (Packing)',
    'Sumitra Devi(Finishing)'
  ];
  final List<String> _tasks = [
    'Cutting',
    'Stitching',
    'Assembly',
    'Sole Attachment',
    'Finishing',
    'Packing',
  ];
  List<String> _selectedWorkers = [];

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
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
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
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: 'Time Allotted'),
                              onChanged: (value) => _timeAllotted = value,
                              validator: (value) => value!.isEmpty ? 'Please enter time allotted' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Assign to Laborers', style: TextStyle(fontSize: 14)),
                      ..._workers.map((worker) => CheckboxListTile(
                        title: Text(worker),
                        value: _selectedWorkers.contains(worker),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedWorkers.add(worker);
                            } else {
                              _selectedWorkers.remove(worker);
                            }
                          });
                        },
                      )),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Handle task assignment logic here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Task Assigned Successfully')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Center(child: Text('Assign Task', style: TextStyle(color: Colors.white))),
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