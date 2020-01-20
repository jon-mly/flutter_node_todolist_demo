import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:todolist_client/models/task.dart';
import 'package:todolist_client/services/api.dart';
import 'package:todolist_client/services/shared_preferences.dart';

class TasksProvider extends ChangeNotifier {
  IO.Socket _socket;

  final ApiService _apiService = ApiService();

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  String _currentToken;

  //
  // ########## LIFECYCLE
  //

  void prepare() async {
    _currentToken = await SharedPreferencesService.token;

    if (kIsWeb)
      _socket = IO.io("http://192.168.1.18:8079", <String, dynamic>{
        'transports': ['websocket'],
      });
    else
      _socket = IO.io("http://192.168.1.18:8079");

    _socket.on('connect', _onConnect);
    _socket.on('disconnect', _onDisconnect);

    _socket.on('tasks', _onTasks);
  }

  @override
  void dispose() {
    _socket.destroy();
    super.dispose();
  }

  //
  // ########## ACTIONS
  //

  Future addTask(String title) async {
    if (title == null || title.isEmpty) return;
    final Task task = Task(
        title: title,
        creatorId: "None for now",
        date: DateTime.now(),
        done: false);
    await _apiService.addTask(task, _currentToken);
  }

  Future toggleTaskState(Task task) async {
    task.done = !task.done;
    await _apiService.updateTask(task, _currentToken);
  }

  Future deleteTask(Task task) async {
    await _apiService.deleteTask(task, _currentToken);
  }

  //
  // ########## SOCKET EVENTS
  //

  void _onConnect(dynamic object) {
    print("Socket ${_socket.id} connected");
  }

  void _onDisconnect(dynamic object) {
    print("Socket ${_socket.id} disconnected");
  }

  void _onTasks(dynamic tasksResponse) {
    print("Received tasks : " + tasksResponse);
    try {
      // The JSON string to parse may not contain quotes around keys and string values.
      // This, it is needed to encode the string before decoding it so that quotes are
      // added and the content parsable.
      if (!(tasksResponse is String))
        tasksResponse = json.encode(tasksResponse);
      final List<dynamic> tasksMap = json.decode(tasksResponse);
      _tasks = tasksMap.map((map) => Task.fromMap(map)).toList();
      print(_tasks);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
