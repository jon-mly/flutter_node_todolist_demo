import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_client/pages/login_page.dart';
import 'package:todolist_client/providers/auth_provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider<AuthProvider>(
        create: (_) => AuthProvider(),
        child: LoginPage(),
      ),
    );
  }
}
