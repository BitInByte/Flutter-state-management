import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import './features/tasks/tasks_screen.dart';
import './features/tasks/providers/task_provider.dart';
import './config/themes/dark_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Let flutter be aware of providers
    // (Dependency Injection via context)
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(),
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
