import 'package:flutter/material.dart';
import 'package:radio_app/theme.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final Color? customColor;

  const CustomIcon({
    super.key,
    required this.icon,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 30,
      color: customColor ?? primaryColor,
    );
  }
}
