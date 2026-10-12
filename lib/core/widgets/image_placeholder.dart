import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 35,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}

class BrokenImagePlaceholder extends StatelessWidget {
  const BrokenImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade100,
      child: Center(
        child: Icon(Icons.broken_image, size: 35, color: Colors.red.shade400),
      ),
    );
  }
}
