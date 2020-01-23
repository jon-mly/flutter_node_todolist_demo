import 'dart:convert';

import 'package:http/http.dart';
import 'package:todolist_client/models/task.dart';
import 'package:todolist_client/models/user.dart';

class ApiService {
  final _host = "/192.168.1.16";
  String get _baseUrl => "http://$_host:8079";

  //
  // ########## AUTH
  //

  Future<User> signUp(String username, String password) async {
    final String url = _baseUrl + "/api/auth/signup";
    Map<String, String> header = {'Content-Type': 'application/json'};
    Map<String, String> body = {"username": username, "password": password};
    final Response response =
        await post(url, headers: header, body: jsonEncode(body));
    print(response.statusCode);
    final dynamic decoded = jsonDecode(response.body);
    if (response.statusCode != 201) {
      print(decoded);
      return null;
    }
    return User.fromMap(decoded);
  }

  Future<User> login(String username, String password) async {
    final String url = _baseUrl + "/api/auth/login";
    print(url);
    Map<String, String> header = {'Content-Type': 'application/json'};
    Map<String, String> body = {"username": username, "password": password};
    final Response response =
        await post(url, headers: header, body: jsonEncode(body));
    print(response.statusCode);
    final dynamic decoded = jsonDecode(response.body);
    if (response.statusCode != 200) {
      print(decoded);
      return null;
    }
    return User.fromMap(decoded);
  }

  Future<bool> verifyTokenValidity(String token) async {
    final String url = _baseUrl + "/api/verify";
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token"
    };
    final Response response = await get(url, headers: header);
    print(response.body);
    print(response.statusCode);
    return response.statusCode == 200;
  }

  //
  // ########## TASKS
  //

  Future addTask(Task task, String token) async {
    final String url = _baseUrl + '/api/task';
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token"
    };
    final Response response =
        await post(url, headers: header, body: jsonEncode(task.toMap()));
    print(response.statusCode);
    if (response.statusCode != 201) print(jsonDecode(response.body));
  }

  Future deleteTask(Task task, String token) async {
    final String url = _baseUrl + '/api/task/${task.id}';
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token"
    };
    final Response response = await delete(url, headers: header);
    print(response.statusCode);
    if (response.statusCode != 200) print(jsonDecode(response.body));
  }

  Future updateTask(Task task, String token) async {
    final String url = _baseUrl + '/api/task/${task.id}';
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token"
    };
    final Response response =
        await put(url, headers: header, body: jsonEncode(task.toMap()));
    print(response.statusCode);
    if (response.statusCode != 200) print(jsonDecode(response.body));
  }
}
