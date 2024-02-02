import 'package:flutter/material.dart';
import 'package:radio_app/common_ui/custom_icon.dart';

class FavoriteIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isFavorite;

  const FavoriteIcon({
    super.key,
    this.onTap,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: isFavorite
          ? const CustomIcon(icon: Icons.favorite)
          : const CustomIcon(icon: Icons.favorite_border_outlined),
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
    );
  }
}
