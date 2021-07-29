import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../models/task.dart';
import '../store/tasks.dart';
import '../../shared/widgets/platform_refresh.dart';

class TasksGroup extends StatelessWidget {
  TasksGroup();

  Widget _buildContent(BuildContext ctx) {
    final tasksStore = ctx.read<TasksStore>();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        // Subscribe to the observable automatically
        // and re-render whenever the state changes
        child: Observer(
          builder: (_) {
            if (tasksStore.tasks.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: Platform.isIOS ? true : false,
                primary: Platform.isIOS ? false : true,
                itemCount: tasksStore.tasks.length,
                itemBuilder: (ctx, index) => TaskItem(
                  task: tasksStore.tasks[index],
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
    /* // -- Cubic way -- */
    /* final tasksSnapshot = context.read<TaskCubit>(); */
    /* final getTasks = () async { */
    /* return context.read<TaskBloc>().add( */
    /* TaskEvent(event: TaskEvents.getTasks), */
    /* ); */
    /* }; */
    final tasksStore = context.read<TasksStore>();

    if (tasksStore.tasks.length == 0) {
      return Text('No tasks added!');
    }

    if (Platform.isIOS) {
      return SafeArea(
        child: PlatformRefresh(
          _buildContent(context),
          tasksStore.getTasks,
        ),
      );
    } else {
      return PlatformRefresh(
        SafeArea(
          child: _buildContent(context),
        ),
        tasksStore.getTasks,
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
    final tasksStore = context.read<TasksStore>();

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
            tasksStore.deleteTask(task.id);
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
