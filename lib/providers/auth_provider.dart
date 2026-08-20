import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _loading = false;
  String _error = '';

  User? get user => _user;
  bool get loading => _loading;
  String get error => _error;
  bool get isAuthenticated => _user != null;

  // Initialize - load user from storage
  Future<void> init() async {
    _loading = true;
    _error = '';
    notifyListeners();
    try {
      _user = await AuthService.getCurrentUser();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = '';
    notifyListeners();

    final result = await AuthService.login(email, password);
    if (result['success'] == true) {
      _user = result['user'];
      _loading = false;
      notifyListeners();
      return true;
    } else {
      _error = result['message'] ?? 'Login failed';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register(
      String name, String email, String password, String role) async {
    _loading = true;
    _error = '';
    notifyListeners();

    final result = await AuthService.register(name, email, password, role);
    _loading = false;
    if (result['success'] == true) {
      notifyListeners();
      return true;
    } else {
      _error = result['message'] ?? 'Registration failed';
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    notifyListeners();
  }
}
