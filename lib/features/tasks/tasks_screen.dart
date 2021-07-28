import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/tasks_group.dart';
import 'models/task.dart';
import './services/tasks_service.dart';
import '../shared/widgets/platform_loading_spinner.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> _tasks = [];
  var _isLoading = false;
  final _controller = new TextEditingController();

  Future<void> _getTasks() async {
    setState(() {
      _isLoading = true;
    });
    final tasksResponse = await TasksService.getTasks();
    setState(() {
      _tasks = tasksResponse;
      _isLoading = false;
    });
  }

  void _addTask() async {
    if (_controller.text.length > 0) {
      final taskResponse = await TasksService.addTask(_controller.text);
      setState(() {
        _tasks.add(taskResponse);
      });
    }
  }

  void _deleteTask(String taskId) async {
    final taskDeleteSuccess = await TasksService.deleteTask(taskId);

    if (taskDeleteSuccess) {
      setState(() {
        _tasks.removeWhere((task) => task.id == taskId);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getTasks();
  }

  Widget _buildWidget(
    BuildContext context,
    Widget body,
  ) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Task Management'),
        ),
        child: body,
      );
    } else {
      return Scaffold(
        /* return CupertinoPageScaffold( */
        appBar: AppBar(
          title: Text('Task Management'),
        ),
        body: body,
      );
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: Text(title),
        brightness: Brightness.light,
      );
    } else {
      return AppBar(
        title: Text(title),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /* return _buildWidget( */
    /* context, */
    /* Center( */
    /* child: TasksGroup(), */
    /* ), */
    /* ); */
    return Scaffold(
      /* return CupertinoPageScaffold( */
      appBar: AppBar(
        title: Text('Task Management'),
        actions: <Widget>[
          if (!Platform.isIOS)
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  /* Scaffold.of(context).showBottomSheet( */
                  /* (context) => Container( */
                  context: context,
                  /* builder: (ctx) => Text( */
                  /* 'This is a modal', */
                  /* style: Theme.of(context).textTheme.headline5, */
                  /* ) */
                  builder: (ctx) => Wrap(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 7,
                            ),
                            child: Text(
                              'Add New Task',
                              textAlign: TextAlign.center,
                              style: Theme.of(ctx).textTheme.headline5,
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(ctx).viewInsets.bottom,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: TextField(
                                      controller: _controller,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: 'Insert a task...',
                                        contentPadding:
                                            EdgeInsets.only(left: 14),
                                        filled: true,
                                        fillColor: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _addTask();
                                    Navigator.of(ctx).pop();
                                  },
                                  icon: Icon(Icons.send),
                                  color: Colors.pink,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.pink,
              ),
            ),
          if (Platform.isIOS)
            CupertinoButton(
              child: Icon(CupertinoIcons.add),
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (ctx) => CupertinoActionSheet(
                    title: Text(
                      'Add New Task',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    actions: [
                      Container(
                        width: MediaQuery.of(ctx).size.width,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(ctx).viewInsets.bottom,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: CupertinoTextField(
                                    controller: _controller,
                                    placeholder: 'Insert a task...',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              CupertinoButton(
                                /* child: Icon(Icons.send), */
                                child:
                                    Icon(CupertinoIcons.arrow_up_circle_fill),
                                onPressed: () {
                                  Navigator.of(ctx).pop();

                                  _addTask();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
        ],
      ),
      /* appBar: _buildAppBar(context, 'Task Management'), */
      /* appBar: CupertinoNavigationBar(), */
      /* navigationBar: CupertinoNavigationBar( */
      /* middle: Text('Task Management'), */
      /* ), */
      body: Center(
        child: _isLoading
            ? LoadingSpinner()
            : TasksGroup(_tasks, _deleteTask, _getTasks),
      ),
    );
  }
}
