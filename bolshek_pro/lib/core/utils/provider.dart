import 'package:bolshek_pro/core/models/auth_response.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  AuthResponse? _authResponse;

  AuthResponse? get authResponse => _authResponse;

  void setAuthData(AuthResponse response) {
    _authResponse = response;
    notifyListeners();
    // Обновление виджетов, которые слушают провайдер
    print(authResponse?.token);
  }

  void clearAuthData() {
    _authResponse = null;
    notifyListeners();
  }
}
