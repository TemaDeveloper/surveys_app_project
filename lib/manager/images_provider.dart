import 'package:flutter/material.dart';

class ImageProviderModel with ChangeNotifier {
  Map<String, String> _imageUrls = {};

  Map<String, String> get imageUrls => _imageUrls;

  void setImageUrls(Map<String, String> urls) {
    _imageUrls = urls;
    notifyListeners();
  }
}
