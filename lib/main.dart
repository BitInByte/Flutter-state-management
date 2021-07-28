import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './features/tasks/tasks_screen.dart';
import './config/themes/dark_theme.dart';
import './features/tasks/blocs/task.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskCubit>(create: (_) => TaskCubit()),
        BlocProvider<TaskBloc>(create: (_) => TaskBloc()),
      ],
      child: MaterialApp(
        title: 'Task Management',
        theme: DarkTheme.theme,
        home: TasksScreen(),
      ),
    );
  }
}
