import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../../shared/widgets/platform_refresh.dart';

class TasksGroup extends StatelessWidget {
  final List<Task> _tasks;
  final Function _deleteTask;
  final Future<void> Function() _getTasks;
  TasksGroup(this._tasks, this._deleteTask, this._getTasks);

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListView.builder(
          shrinkWrap: Platform.isIOS ? true : false,
          /* scrollDirection: Axis.vertical, */
          primary: Platform.isIOS ? false : true,
          /* clipBehavior: Clip.antiAlias, */
          itemCount: _tasks.length,
          itemBuilder: (ctx, index) =>
              TaskItem(task: _tasks[index], onDeleteTask: _deleteTask),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_tasks.length == 0) {
      return Text('No tasks added!');
    }

    if (Platform.isIOS) {
      return SafeArea(child: PlatformRefresh(_buildContent(), _getTasks));
    } else {
      return PlatformRefresh(SafeArea(child: _buildContent()), _getTasks);
    }
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem({Key? key, required this.task, required this.onDeleteTask})
      : super(key: key);

  final Task task;
  final Function onDeleteTask;

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
            onDeleteTask(task.id);
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
