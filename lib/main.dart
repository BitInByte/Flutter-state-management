import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './features/tasks/tasks_screen.dart';

import './config/themes/dark_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      theme: DarkTheme.theme,
      home: TasksScreen(),
    );
  }
}
