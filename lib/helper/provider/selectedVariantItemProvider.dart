import 'package:flutter/material.dart';

class SelectedVariantItemProvider extends ChangeNotifier {
  //Variant current selected index provider
  int selectedIndex = 0;

  getSelectedIndex() {
    return selectedIndex;
  }

  setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
