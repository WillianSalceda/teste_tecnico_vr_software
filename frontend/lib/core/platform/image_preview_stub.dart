import 'package:flutter/material.dart';

Widget buildImagePreview(String path, {double? height, double? width}) {
  return SizedBox(
    height: height ?? 120,
    width: width ?? double.infinity,
    child: const Center(
      child: Icon(Icons.image, size: 48),
    ),
  );
}
