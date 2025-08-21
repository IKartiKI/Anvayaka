import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://anvayakabackend.onrender.com/api'; // Replace with your actual API endpoint
  
  static Future<Map<String, dynamic>> assignTask({
    required String name,
    required String description,
    required int quantity,
    required DateTime dueDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/task/'), // Replace with your actual endpoint
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'quantity': quantity,
          'due_date': '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to assign task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error assigning task: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getAssignedTasks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/task/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  static Future<Map<String, dynamic>> generateParchi({
    required String taskId,
    required String labourId,
    required String details,
    required int deliverables,
    required DateTime deadline,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/parchi/'), // Replace with your actual parchi endpoint
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'task': taskId,
          'labour': labourId,
          'details': details,
          'deliverable': deliverables,
          'deadline': '${deadline.year}-${deadline.month.toString().padLeft(2, '0')}-${deadline.day.toString().padLeft(2, '0')}',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to generate parchi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating parchi: $e');
    }
  }
}
