import "dart:convert";
import 'package:http/http.dart' as http;

import '../models/task.dart';
import '../../../constants/env_values.dart';

class TasksService {
  static const _endpoint = '/tasks.json';
  static const _url = Api.URL;

  static final _uri = Uri.https(_url, _endpoint);

  static Future<List<Task>> getTasks() async {
    List<Task> tasks = [];
    try {
      final response = await http.get(_uri);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        responseData.forEach((taskId, task) {
          tasks.add(
            Task(
              id: taskId,
              task: task['task'],
              timestamp: DateTime.fromMillisecondsSinceEpoch(task['time']),
            ),
          );
        });
      }
    } catch (error) {
      print(error);
      // resend error
      throw error;
    }
    return tasks;
  }

  static Future<Task> addTask(String task) async {
    try {
      final time = DateTime.now().millisecondsSinceEpoch;
      final response = await http.post(_uri,
          body: json.encode({
            'task': task,
            'time': time,
          }));

      final responseBody = json.decode(response.body) as Map<String, dynamic>;

      return Task(
        id: responseBody['name'],
        task: task,
        timestamp: DateTime.fromMillisecondsSinceEpoch(time),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  static Future<bool> deleteTask(String taskId) async {
    final _uri = Uri.https(_url, '/tasks/$taskId.json');
    try {
      final response = await http.delete(_uri);
      if (response.statusCode >= 400) {
        return false;
      }
      return true;
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
