import 'package:flutter/material.dart';

class SchemeProvider extends ChangeNotifier {

  String state = "";
  String category = "";

  void setState(String value) {
    state = value;
    notifyListeners();
  }

  void setCategory(String value) {
    category = value;
    notifyListeners();
  }

}