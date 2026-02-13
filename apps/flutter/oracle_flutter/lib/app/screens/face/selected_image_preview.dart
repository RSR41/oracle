import 'package:flutter/widgets.dart';

import 'selected_image_preview_io.dart'
    if (dart.library.html) 'selected_image_preview_web.dart' as impl;

Widget buildSelectedImagePreview({
  required String imagePath,
  required BorderRadius borderRadius,
}) {
  return impl.buildSelectedImagePreview(
    imagePath: imagePath,
    borderRadius: borderRadius,
  );
}
