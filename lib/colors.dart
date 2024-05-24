import 'package:flutter/material.dart';

class AppColors {
  static const Color brightOrange = Color(0xFFFFA500); // Bright Orange
  static const Color facebookBlue = Color(0xFF1877F2); // Facebook Blue
  static const Color grey = Color(0xFFC0C0C0); // Grey

  static const Map<int, Color> _brightOrangeMap = {
    50: Color.fromRGBO(255, 165, 0, .1),
    100: Color.fromRGBO(255, 165, 0, .2),
    200: Color.fromRGBO(255, 165, 0, .3),
    300: Color.fromRGBO(255, 165, 0, .4),
    400: Color.fromRGBO(255, 165, 0, .5),
    500: Color.fromRGBO(255, 165, 0, .6),
    600: Color.fromRGBO(255, 165, 0, .7),
    700: Color.fromRGBO(255, 165, 0, .8),
    800: Color.fromRGBO(255, 165, 0, .9),
    900: Color.fromRGBO(255, 165, 0, 1),
  };

  static const Map<int, Color> _facebookBlueMap = {
    50: Color.fromRGBO(24, 119, 242, .1),
    100: Color.fromRGBO(24, 119, 242, .2),
    200: Color.fromRGBO(24, 119, 242, .3),
    300: Color.fromRGBO(24, 119, 242, .4),
    400: Color.fromRGBO(24, 119, 242, .5),
    500: Color.fromRGBO(24, 119, 242, .6),
    600: Color.fromRGBO(24, 119, 242, .7),
    700: Color.fromRGBO(24, 119, 242, .8),
    800: Color.fromRGBO(24, 119, 242, .9),
    900: Color.fromRGBO(24, 119, 242, 1),
  };

  static const MaterialColor brightOrangeMaterial =
      MaterialColor(0xFFFFA500, _brightOrangeMap);

  static const MaterialColor facebookBlueMaterial =
      MaterialColor(0xFF1877F2, _facebookBlueMap);
}
