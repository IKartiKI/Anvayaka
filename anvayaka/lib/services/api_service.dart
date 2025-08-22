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

  // Fetch latest temperature
  static Future<double> fetchLatestTemperature() async {
    final response = await http.get(Uri.parse('$baseUrl/get_latest_temperature/'));


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Ensure we parse double
      print(data);
      return (data['temperature'] as num).toDouble();
    } else {
      throw Exception("Failed to fetch temperature");
    }
  }


  static Future<List<Map<String, dynamic>>> getTasks() async {
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

  static Future<Map<String, dynamic>> startLiveUpdate(String taskId) async {
    try {
      print('[ApiService] POST startLiveUpdate url: $baseUrl/mqtt/start/ body: {task_id: $taskId}');
      final response = await http.post(
        Uri.parse('$baseUrl/mqtt/start/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'task_id': taskId,
        }),
      );

      print('[ApiService] POST startLiveUpdate status: ${response.statusCode} body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to start live update: ${response.statusCode}');
      }
    } catch (e) {
      print('[ApiService] POST startLiveUpdate error: $e');
      throw Exception('Error starting live update: $e');
    }
  }

  static Future<Map<String, dynamic>> getLiveUpdate(String taskId) async {
    try {
      print('[ApiService] GET getLiveUpdate url: $baseUrl/live_update/?task_id=$taskId');
      final response = await http.get(
        Uri.parse('$baseUrl/live_update/?task_id=$taskId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('[ApiService] GET getLiveUpdate status: ${response.statusCode} body: ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get live update: ${response.statusCode}');
      }
    } catch (e) {
      print('[ApiService] GET getLiveUpdate error: $e');
      throw Exception('Error getting live update: $e');
    }
  }

  // Stop Live Update
  Future<Map<String, dynamic>> stopLiveUpdate(String taskId) async {
    final url = Uri.parse('$baseUrl/mqtt/stop/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'task_id': taskId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to stop live update');
    }
  }


  static Future<void> deleteTask(String taskId) async {
    try {
      final url = '$baseUrl/task/$taskId/';
      print('[ApiService] DELETE deleteTask url: $url');
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('[ApiService] DELETE deleteTask status: ${response.statusCode} body: ${response.body}');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      print('[ApiService] DELETE deleteTask error: $e');
      throw Exception('Error deleting task: $e');
    }
  }
}
