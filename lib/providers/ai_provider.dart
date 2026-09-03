import 'package:flutter/material.dart';

class AIProvider extends ChangeNotifier {

  bool loading = false;

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

}