import 'package:rxdart/rxdart.dart';

import '../models/task.dart';
import '../services/tasks_service.dart';

class _TaskBloc {
  final _tasks = BehaviorSubject<List<Task>>();

  ValueStream<List<Task>> get tasks$ => _tasks.stream;

  List<Task> get tasks => [..._tasks.value];

  Future<void> getTasks() async {
    try {
      final response = await TasksService.getTasks();
      _tasks.add(response);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addTask(String task) async {
    try {
      final response = await TasksService.addTask(task);
      final newTasks = tasks;
      newTasks.add(response);
      _tasks.add(newTasks);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final response = await TasksService.deleteTask(taskId);
      if (response) {
        final updatedTasks = tasks;
        updatedTasks.removeWhere((task) => task.id == taskId);
        _tasks.add(updatedTasks);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void dispose() {
    _tasks.close();
  }
}

// Generate a single instance for all the entire app
// lifecycle
final bloc = _TaskBloc();
