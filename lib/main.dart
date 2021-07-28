import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './features/tasks/tasks_screen.dart';
import './config/themes/dark_theme.dart';
import './config/stores/store.dart';

void main() {
  setupDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Let flutter be aware of providers
    // (Dependency Injection via context)
    return MaterialApp(
      title: 'Task Management',
      theme: DarkTheme.theme,
      /* theme: ThemeData.dark(), */
      home: TasksScreen(),
    );
  }
}
