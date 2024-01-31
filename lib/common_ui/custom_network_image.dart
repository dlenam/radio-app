import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double radius;

  final Widget? onMissingOrErrorWidget;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.radius = 20,
    this.onMissingOrErrorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius), // Image border
      child: imageUrl.contains('https')
          ? Image.network(
              imageUrl,
              loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress == null
                      ? child
                      : const CircularProgressIndicator(),
              errorBuilder: (context, child, loadingProgress) =>
                  onMissingOrErrorWidget ?? const _MissingImageIcon(),
              fit: BoxFit.cover,
            )
          : onMissingOrErrorWidget ?? const _MissingImageIcon(),
    );
  }
}

class _MissingImageIcon extends StatelessWidget {
  const _MissingImageIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.error_outline,
      color: Colors.black,
      size: 50,
    );
  }
}
