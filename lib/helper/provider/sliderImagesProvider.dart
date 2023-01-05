import 'package:flutter/material.dart';

class SliderImagesProvider extends ChangeNotifier {
  int currentSliderImageIndex = 0;

  setSliderCurrentIndexImage(int index) {
    currentSliderImageIndex = index;
    notifyListeners();
  }
}
