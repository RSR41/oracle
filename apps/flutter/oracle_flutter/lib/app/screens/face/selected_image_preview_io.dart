import 'dart:io';

import 'package:flutter/widgets.dart';

Widget buildSelectedImagePreview({
  required String imagePath,
  required BorderRadius borderRadius,
}) {
  return ClipRRect(
    borderRadius: borderRadius,
    child: Image.file(
      File(imagePath),
      key: const Key('face_selected_image_preview'),
      fit: BoxFit.cover,
    ),
  );
}
