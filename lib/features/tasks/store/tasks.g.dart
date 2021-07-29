// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TasksStore on _TasksStore, Store {
  final _$tasksAtom = Atom(name: '_TasksStore.tasks');

  @override
  List<Task> get tasks {
    _$tasksAtom.reportRead();
    return super.tasks;
  }

  @override
  set tasks(List<Task> value) {
    _$tasksAtom.reportWrite(value, super.tasks, () {
      super.tasks = value;
    });
  }

  final _$getTasksAsyncAction = AsyncAction('_TasksStore.getTasks');

  @override
  Future<void> getTasks() {
    return _$getTasksAsyncAction.run(() => super.getTasks());
  }

  final _$addTaskAsyncAction = AsyncAction('_TasksStore.addTask');

  @override
  Future<void> addTask(String task) {
    return _$addTaskAsyncAction.run(() => super.addTask(task));
  }

  final _$deleteTaskAsyncAction = AsyncAction('_TasksStore.deleteTask');

  @override
  Future<void> deleteTask(String taskId) {
    return _$deleteTaskAsyncAction.run(() => super.deleteTask(taskId));
  }

  @override
  String toString() {
    return '''
tasks: ${tasks}
    ''';
  }
}
