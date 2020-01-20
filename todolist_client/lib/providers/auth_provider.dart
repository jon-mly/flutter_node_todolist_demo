import 'package:flutter/foundation.dart';
import 'package:todolist_client/models/user.dart';
import 'package:todolist_client/services/api.dart';
import 'package:todolist_client/services/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  //
  // ########## ACTIONS
  //

  Future<bool> signup(String username, String password) async {
    return await _apiService
        .signUp(username, password)
        .then(_handleAuthResponse);
  }

  Future<bool> login(String username, String password) async {
    return await _apiService
        .login(username, password)
        .then(_handleAuthResponse);
  }

  bool _handleAuthResponse(User user) {
    if (user == null) return false;
    SharedPreferencesService.username = user.username;
    SharedPreferencesService.token = user.token;
    return true;
  }
}
