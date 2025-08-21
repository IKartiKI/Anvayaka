// lib/screens/parchi_generation_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ParchiGenerationScreen extends StatefulWidget {
  const ParchiGenerationScreen({super.key});

  @override
  _ParchiGenerationScreenState createState() => _ParchiGenerationScreenState();
}

class _ParchiGenerationScreenState extends State<ParchiGenerationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _companyName = 'Anvayaka Manufacturing';
  String? _selectedLaborer;
  String? _selectedJob;
  String _timeAllotted = '';

  @override
  Widget build(BuildContext context) {
    final List<String> laborers = [
      'Raj Kumar (Welding)',
      'Priya Sharma (Assembly)',
      'Amit Singh (Quality Control)',
      'Sunita Devi (Painting)',
      'Vikash Yadav (Machine Operation)',
    ];
    final List<String> jobs = ['Welding', 'Assembly', 'Quality Control', 'Painting', 'Machine Operation'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Parchi Generation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Generate task slips for workers',
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
                      'Parchi Generator',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Generate task slips for laborers',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Company Name'),
                      initialValue: _companyName,
                      onChanged: (value) => _companyName = value,
                      validator: (value) => value!.isEmpty ? 'Please enter company name' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Select Laborer'),
                      value: _selectedLaborer,
                      items: laborers.map((laborer) {
                        return DropdownMenuItem(value: laborer, child: Text(laborer));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLaborer = value;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a laborer' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Select Job'),
                      value: _selectedJob,
                      items: jobs.map((job) {
                        return DropdownMenuItem(value: job, child: Text(job));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedJob = value;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a job' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Time Allotted'),
                      onChanged: (value) => _timeAllotted = value,
                      validator: (value) => value!.isEmpty ? 'Please enter time allotted' : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle parchi generation logic here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Parchi Generated Successfully')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Center(child: Text('Generate Parchi', style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}