import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final double? fixedDefaultImageWidth;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.radius = 20,
    this.fixedDefaultImageWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        imageUrl,
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null ? child : const CircularProgressIndicator(),
        errorBuilder: (context, child, loadingProgress) => SvgPicture.asset(
          'assets/image-broken.svg',
          width: fixedDefaultImageWidth ?? double.infinity,
        ),
      ),
    );
  }
}
