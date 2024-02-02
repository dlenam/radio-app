import 'package:flutter/material.dart';

class Theme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color standardBackgroundColor;

  Theme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.standardBackgroundColor,
  });
}

final appTheme = Theme(
  primaryColor: const Color.fromARGB(255, 172, 4, 32),
  secondaryColor: const Color.fromARGB(255, 112, 233, 247),
  standardBackgroundColor: Color.fromARGB(255, 255, 246, 221),
);
