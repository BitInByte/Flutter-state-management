import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './widgets/tasks_group.dart';
import '../shared/widgets/platform_loading_spinner.dart';
import './blocs/task.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  var _isLoading = false;
  final _controller = new TextEditingController();

  Future<void> _getTasks() async {
    setState(() {
      _isLoading = true;
    });
    // Only read, doesn't rebuild
    // -- Cubic way --
    await context.read<TaskCubit>().getTasks();
    // -- Bloc way --
    context.read<TaskBloc>().add(
          TaskEvent(event: TaskEvents.getTasks),
        );
    setState(() {
      _isLoading = false;
    });
  }

  void _addTask() async {
    final task = _controller.text;
    if (task.length > 0) {
      // Only read, doesn't rebuild
      // -- Cubit way --
      /* await context.read<TaskCubit>().addTask(task); */
      // -- Bloc way --
      context.read<TaskBloc>().add(
            TaskEvent(
              event: TaskEvents.addTask,
              payload: {'task': task},
            ),
          );
      _controller.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
        actions: <Widget>[
          if (!Platform.isIOS)
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
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
                color: Colors.white,
              ),
            ),
          if (Platform.isIOS)
            CupertinoButton(
              child: Icon(
                CupertinoIcons.add,
                color: Colors.white,
              ),
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
                                child: Icon(
                                  CupertinoIcons.arrow_up_circle_fill,
                                  color: Colors.pink,
                                ),
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
      body: Center(
        child: _isLoading ? LoadingSpinner() : TasksGroup(),
      ),
    );
  }
}
