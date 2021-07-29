import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import './features/tasks/tasks_screen.dart';
import './config/themes/dark_theme.dart';
import './features/tasks/store/tasks.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => TasksStore(),
        ),
      ],
      child: MaterialApp(
        title: 'Task Management',
        theme: DarkTheme.theme,
        home: TasksScreen(),
      ),
    );
  }
}
