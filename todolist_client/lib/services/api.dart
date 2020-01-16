import 'dart:convert';

import 'package:http/http.dart';
import 'package:todolist_client/models/task.dart';

class ApiService {
  String get _baseUrl => "http://192.168.1.18:8080";

  //
  // ########## AUTH
  //

  Future signUp(String unsername, String password) async {}

  Future login(String username, String password) async {}

  //
  // ########## TASKS
  //

  Future addTask(Task task) async {
    final String url = _baseUrl + '/api/task';
    Map<String, String> header = {'Content-Type': 'application/json'};
    final Response response =
        await post(url, headers: header, body: jsonEncode(task.toMap()));
    print(response.statusCode);
  }

  Future deleteTask(Task task) async {
    final String url = _baseUrl + '/api/task/:${task.id}';
    Map<String, String> header = {'Content-Type': 'application/json'};
    final Response response = await delete(url, headers: header);
    print(response.statusCode);
  }

  Future updateTask(Task task) async {
    final String url = _baseUrl + '/api/task/:${task.id}';
    Map<String, String> header = {'Content-Type': 'application/json'};
    final Response response =
        await put(url, headers: header, body: jsonEncode(task.toMap()));
    print(response.statusCode);
  }
}
