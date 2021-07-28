import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './features/tasks/tasks_screen.dart';
import './config/themes/dark_theme.dart';
import './config/dependencies/store.dart';
import './config/dependencies/constants.dart';

void main() {
  // Dependency injection
  StoreDependencies.setupDependencies();
  ConstantDependencies.setupDependencies();
  runApp(MyApp());
}

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
