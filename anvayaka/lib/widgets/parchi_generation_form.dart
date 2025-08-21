import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ParchiGenerationForm extends StatefulWidget {
  final Map<String, dynamic> task;

  const ParchiGenerationForm({super.key, required this.task});

  @override
  _ParchiGenerationFormState createState() => _ParchiGenerationFormState();
}

class _ParchiGenerationFormState extends State<ParchiGenerationForm> {
  final List<String> _labourers = [
    'Raj Kumar (Cutting)',
    'Priya Sharma (Stitching)',
    'Amit Singh (Sole Attachment)',
    'Sunita Devi (Assembly)',
    'Vikash Yadav (Packing)',
    'Sumitra Devi (Finishing)',
    'Ramesh Kumar (Quality Control)',
    'Lakshmi Devi (Inspection)',
  ];
  
  List<String> _selectedLabourers = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.assignment, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Generate Parchi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.task['name'] ?? 'Task',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Task Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Task Name', widget.task['name'] ?? 'N/A'),
                    _buildDetailRow('Description', widget.task['description'] ?? 'N/A'),
                    _buildDetailRow('Due Date', _formatDate(widget.task['due_date'] ?? '')),
                    _buildDetailRow('Quantity', widget.task['quantity']?.toString() ?? 'N/A'),
                    const SizedBox(height: 20),
                    const Text(
                      'Select Labourers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Choose one or more labourers to assign this task:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._labourers.map((labourer) => CheckboxListTile(
                      title: Text(labourer),
                      value: _selectedLabourers.contains(labourer),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedLabourers.add(labourer);
                          } else {
                            _selectedLabourers.remove(labourer);
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    )),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedLabourers.isEmpty || _isLoading
                            ? null
                            : _generateParchi,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Generate Parchi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _generateParchi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // For each selected labourer, generate a parchi
      for (String labourer in _selectedLabourers) {
        await ApiService.generateParchi(
          taskId: widget.task['id'] ?? '',
          labourId: '81c89460-5bcf-4d69-8acc-31bc8029d94a', // Fixed labour ID as specified
          details: widget.task['description'] ?? '',
          deliverables: widget.task['quantity'] ?? 0,
          deadline: DateTime.parse(widget.task['due_date'] ?? DateTime.now().toIso8601String()),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Parchi generated successfully for ${_selectedLabourers.length} labourer(s)'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating parchi: ${e.toString()}'),
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
}
