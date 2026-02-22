import 'package:flutter/material.dart';

import '../../../../../core/platform/image_preview.dart';

class CreateListingImagePicker extends StatelessWidget {
  const CreateListingImagePicker({
    required this.label,
    required this.noImageLabel,
    required this.hasImage,
    required this.onPick,
    super.key,
    this.imagePath,
  });

  final String label;
  final String noImageLabel;
  final bool hasImage;
  final String? imagePath;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onPick,
          icon: const Icon(Icons.image),
          label: Text(hasImage ? label : noImageLabel),
        ),
        if (imagePath != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: buildImagePreview(imagePath!),
          ),
      ],
    );
  }
}
