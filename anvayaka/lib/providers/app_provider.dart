// lib/providers/app_provider.dart
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  bool _isThekedar = true;

  bool get isThekedar => _isThekedar;

  void toggleRole() {
    _isThekedar = !_isThekedar;
    notifyListeners();
  }
}