import 'package:flutter/material.dart';

import '../models/admin.dart';

class AdminProvider extends ChangeNotifier {
  late Admin _admin;

  Admin get admin => _admin;

  void setAdmin(Admin admin) {
    _admin = admin;
    notifyListeners();
  }
}
