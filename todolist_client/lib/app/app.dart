import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_client/pages/tasks_page.dart';
import 'package:todolist_client/providers/app_provider.dart';
import 'package:todolist_client/providers/auth_provider.dart';
import 'package:todolist_client/providers/tasks_provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppProvider>(
          create: (_) => AppProvider(),
        ),
        Provider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: ChangeNotifierProvider<TasksProvider>(
          create: (_) => TasksProvider(),
          child: TasksPage(),
        ),
      ),
    );
  }
}
