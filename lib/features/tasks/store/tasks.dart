import 'package:get/get.dart';
import '../models/task.dart';
import '../services/tasks_service.dart';

class TasksStore extends GetxController {
  /* List<Rx<Task>> tasks = <Rx<Task>>[].obs; */

  RxList<Task> tasks = RxList<Task>();

  Future<void> getTasks() async {
    try {
      final response = await TasksService.getTasks();
      /* tasks = _convertTasks(response); */
      tasks = RxList.of(response);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addTask(String task) async {
    try {
      final response = await TasksService.addTask(task);
      final newTasks = [...tasks];
      newTasks.add(response);
      tasks = RxList.of(newTasks);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final response = await TasksService.deleteTask(taskId);
      if (response) {
        final updatedTasks = [...tasks];
        updatedTasks.removeWhere((task) => task.id == taskId);
        tasks = RxList.of(updatedTasks);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  List<Rx<Task>> _convertTasks(List<Task> tasks) {
    return tasks.map((task) => task.obs).toList();
  }
}
