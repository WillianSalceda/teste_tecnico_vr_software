import 'dart:io';

import 'package:flutter/material.dart';

Widget buildImagePreview(String path, {double? height, double? width}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.file(
      File(path),
      height: height ?? 120,
      width: width ?? double.infinity,
      fit: BoxFit.cover,
    ),
  );
}
