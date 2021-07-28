import 'package:bloc/bloc.dart';

import '../models/task.dart';
import '../services/tasks_service.dart';

// =======CUBIT=======
class TaskCubit extends Cubit<List<Task>> {
  TaskCubit() : super([]);

  List<Task> get tasks => [...state];

  Future<void> getTasks() async {
    try {
      final response = await TasksService.getTasks();
      emit(response);
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
      emit(newTasks);
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
        emit(updatedTasks);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

// =======BLOC=======

enum TaskEvents {
  getTasks,
  addTask,
  deleteTask,
}

class TaskEvent {
  final TaskEvents event;
  final Map<String, dynamic>? payload;

  TaskEvent({
    required this.event,
    this.payload,
  });
}

class TaskBloc extends Bloc<TaskEvent, List<Task>> {
  TaskBloc() : super([]);

  List<Task> get tasks => [...state];

  @override
  Stream<List<Task>> mapEventToState(TaskEvent event) async* {
    print(event.event);
    switch (event.event) {
      case TaskEvents.getTasks:
        final tasks = await _getTasks();
        yield tasks;
        break;
      case TaskEvents.addTask:
        final task = event.payload!['task'] as String;
        print(task);
        final tasks = await _addTask(task);
        print(tasks);
        yield tasks;
        break;
      case TaskEvents.deleteTask:
        final taskId = event.payload!['taskId'] as String;
        final tasks = await _deleteTask(taskId);
        yield tasks;
        break;
    }
  }

  Future<List<Task>> _getTasks() async {
    try {
      return await TasksService.getTasks();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<Task>> _addTask(String task) async {
    try {
      final response = await TasksService.addTask(task);
      final newTasks = tasks;
      newTasks.add(response);
      return newTasks;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<Task>> _deleteTask(String taskId) async {
    try {
      final response = await TasksService.deleteTask(taskId);
      if (response) {
        final updatedTasks = tasks;
        updatedTasks.removeWhere((task) => task.id == taskId);
        return updatedTasks;
      }
      return state;
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
