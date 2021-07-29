import 'package:mobx/mobx.dart';

import '../models/task.dart';
import '../services/tasks_service.dart';

// We have to run: flutter packages pub run build_runner build
// in order to generate the files for this store for
// annotations to work
part 'tasks.g.dart';

class TasksStore = _TasksStore with _$TasksStore;

abstract class _TasksStore with Store {
  @observable
  List<Task> tasks = [];

  @action
  Future<void> getTasks() async {
    try {
      final response = await TasksService.getTasks();
      tasks = response;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @action
  Future<void> addTask(String task) async {
    try {
      final response = await TasksService.addTask(task);
      final newTasks = tasks;
      newTasks.add(response);
      tasks = newTasks;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @action
  Future<void> deleteTask(String taskId) async {
    try {
      final response = await TasksService.deleteTask(taskId);
      if (response) {
        final updatedTasks = tasks;
        updatedTasks.removeWhere((task) => task.id == taskId);
        tasks = updatedTasks;
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
