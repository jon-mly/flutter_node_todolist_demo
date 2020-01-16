import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:todolist_client/models/task.dart';

class TasksProvider extends ChangeNotifier {
  IO.Socket _socket;

  List<Task> _tasks;
  List<Task> get tasks => _tasks;

  //
  // ########## LIFECYCLE
  //

  void prepare() {
    if (kIsWeb)
      _socket = IO.io("http://192.168.1.18:8080", <String, dynamic>{
        'transports': ['websocket'],
      });
    else
      _socket = IO.io("http://192.168.1.18:8080");

    _socket.on('connect', _onConnect);
    _socket.on('disconnect', _onDisconnect);

    _socket.on('tasks', _onTasks);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //
  // ########## ACTIONS
  //

  Future addTask(String title) async {
    if (title == null || title.isEmpty) return;
    // TODO: add task
  }

  Future toggleTaskState(Task task) async {
    task.done = !task.done;
    // TODO: upload task
  }

  Future deleteTask(Task task) async {
    // TODO: delete task
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
    print("Received tasks :\n" + tasksResponse);
    try {
      // The JSON string to parse may not contain quotes around keys and string values.
      // This, it is needed to encode the string before decoding it so that quotes are
      // added and the content parsable.
      if (!tasksResponse is String) tasksResponse = json.encode(tasksResponse);
      final List<Map<String, dynamic>> tasksMap = json.decode(tasksResponse);
      _tasks = tasksMap.map((map) => Task.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {}
  }
}
