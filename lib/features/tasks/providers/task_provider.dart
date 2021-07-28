import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../services/tasks_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks {
    return [..._tasks];
  }

  Future<void> getTasks() async {
    try {
      final response = await TasksService.getTasks();
      _tasks = response;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addTask(String task) async {
    try {
      final response = await TasksService.addTask(task);
      _tasks.add(response);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final response = await TasksService.deleteTask(taskId);
      if (response) {
        _tasks.removeWhere((task) => task.id == taskId);
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
