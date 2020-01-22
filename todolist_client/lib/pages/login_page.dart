import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_client/pages/tasks_page.dart';
import 'package:todolist_client/providers/auth_provider.dart';
import 'package:todolist_client/providers/tasks_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //
  // ########## ACTIONS
  //

  Future _login() async {
    Provider.of<AuthProvider>(context, listen: false)
        .login(_usernameController.text, _passwordController.text)
        .then((bool connected) {
      print(connected);
      if (connected) _navigateToTasks();
    });
  }

  Future _signup() async {
    Provider.of<AuthProvider>(context, listen: false)
        .signup(_usernameController.text, _passwordController.text)
        .then((bool connected) {
      print(connected);
      if (connected) _navigateToTasks();
    });
  }

  void _navigateToTasks() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<TasksProvider>(
              create: (_) => TasksProvider(),
              child: TasksPage(),
            )));
  }

  //
  // ########## UI
  //

  Widget _buildButtonsRow() {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: RaisedButton(
            child: Text("Login"),
            onPressed: _login,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
        ),
        Flexible(
          flex: 1,
          child: RaisedButton(
            child: Text("Signup"),
            onPressed: _signup,
          ),
        )
      ],
    );
  }

  Widget _buildPage() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(hintText: "Username"),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(hintText: "Password"),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
          ),
          _buildButtonsRow()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In Page"),
      ),
      body: _buildPage(),
    );
  }
}
