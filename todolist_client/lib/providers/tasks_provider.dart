import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:todolist_client/models/task.dart';
import 'package:todolist_client/services/api.dart';
import 'package:todolist_client/services/shared_preferences.dart';

class TasksProvider extends ChangeNotifier {
  final _host = "192.168.1.16";

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
    _openSocket();
  }

  @override
  void dispose() {
    _closeSocket();
    super.dispose();
  }

  //
  // ########## SOCKET LIFECYCLE
  //

  void _openSocket() {
    if (_socket != null) _closeSocket();

    if (kIsWeb)
      _socket = IO.io("http://$_host:8079", <String, dynamic>{
        'transports': ['websocket'],
        'forceNew': true
      });
    else
      _socket =
          IO.io("http://$_host:8079", <String, dynamic>{'forceNew': true});

    _socket.on('connect', _onConnect);
    _socket.on('disconnect', _onDisconnect);

    _socket.on('auth', _onAuthResponse);
    _socket.on('tasks', _onTasks);
    _socket.on('error', _onError);
  }

  void _closeSocket() {
    if (_socket == null) return;

    _socket.disconnect();
    _socket.close();
    _socket.destroy();
    _socket = null;
  }

  //
  // ########## ACTIONS
  //

  Future _authenticate() async {
    _socket.emit('auth', json.encode({'token': _currentToken}));
  }

  Future addTask(String title) async {
    if (title == null || title.isEmpty) return;
    final Task task = Task(title: title, date: DateTime.now(), done: false);
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
    _authenticate();
  }

  void _onAuthResponse(dynamic object) {
    print(object);
  }

  void _onDisconnect(dynamic object) {
    print("Socket ${_socket.id} disconnected");
  }

  void _onTasks(dynamic tasksResponse) {
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

  void _onError(dynamic errorResponse) {
    print(errorResponse);
  }
}
