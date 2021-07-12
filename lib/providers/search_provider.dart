import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  String? _searchValue;

  String? get searchValue => _searchValue;

  changeSearchValue(String? value) {
    _searchValue = value;
    notifyListeners();
  }
}
