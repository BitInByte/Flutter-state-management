import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/task.dart';
import '../../shared/widgets/platform_refresh.dart';
import '../blocs/task.dart';

class TasksGroup extends StatelessWidget {
  TasksGroup();

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        // Consume and rebuild when notifyListeners is
        // triggered.
        /* child: BlocBuilder<TaskCubit, List<Task>>( */
        child: BlocBuilder<TaskBloc, List<Task>>(
          builder: (_, tasksSnapshot) {
            print(tasksSnapshot);
            if (tasksSnapshot.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: Platform.isIOS ? true : false,
                primary: Platform.isIOS ? false : true,
                itemCount: tasksSnapshot.length,
                itemBuilder: (ctx, index) => TaskItem(
                  /* task: tasksSnapshot.tasks[index], */
                  task: tasksSnapshot[index],
                ),
              );
            }
            return Center();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only read, doesn't rebuild
    // -- Cubic way --
    final tasksSnapshot = context.read<TaskCubit>();
    final getTasks = () async {
      return context.read<TaskBloc>().add(
            TaskEvent(event: TaskEvents.getTasks),
          );
    };

    if (tasksSnapshot.tasks.length == 0) {
      return Text('No tasks added!');
    }

    if (Platform.isIOS) {
      return SafeArea(
        child: PlatformRefresh(
          _buildContent(),
          // -- Cubic way --
          /* tasksSnapshot.getTasks, */
          // -- Bloc way --
          getTasks,
        ),
      );
    } else {
      return PlatformRefresh(
        SafeArea(
          child: _buildContent(),
        ),
        // -- Cubic way --
        /* tasksSnapshot.getTasks, */
        // -- Bloc way --
        getTasks,
      );
    }
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem({Key? key, required this.task}) : super(key: key);

  final Task task;

  Future<bool?> _showDialog(BuildContext ctx) {
    final navigator = Navigator.of(ctx);
    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: ctx,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('You sure you want to remove the task?'),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.lightGreen,
                ),
              ),
              onPressed: () {
                navigator.pop(true);
              },
            ),
            CupertinoButton(
              child: Text(
                'No',
                style: TextStyle(
                  color: Theme.of(ctx).errorColor,
                ),
              ),
              onPressed: () {
                navigator.pop(false);
              },
            ),
          ],
        ),
      );
    } else {
      return showDialog(
        context: ctx,
        builder: (ctx) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('You sure you want to remove the task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                navigator.pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                navigator.pop(false);
              },
              child: const Text('No'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only read, doesn't rebuild
    // -- Cubic way --
    final tasksSnapshot = context.read<TaskCubit>();

    return Container(
      color: Colors.white,
      child: Dismissible(
        key: ValueKey(task.task),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
        ),
        confirmDismiss: (direction) async {
          final isDismissible = await _showDialog(context);
          if (isDismissible != null && isDismissible) {
            // -- Cubic way --
            /* tasksSnapshot.deleteTask(task.id); */
            // -- Bloc way --
            context.read<TaskBloc>().add(
                  TaskEvent(
                    event: TaskEvents.deleteTask,
                    payload: {'taskId': task.id},
                  ),
                );
          }
        },
        child: Column(
          children: [
            ListTile(
              title: Text(
                task.task,
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Text(
                DateFormat.yMMMMEEEEd().format(task.timestamp),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            const Divider(
              height: 0.0,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
