import 'package:flutter/material.dart';

Widget buildSelectedImagePreview({
  required String imagePath,
  required BorderRadius borderRadius,
}) {
  return ClipRRect(
    borderRadius: borderRadius,
    child: Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported_outlined, size: 40),
          SizedBox(height: 8),
          Text(
            '이미지는 선택되었지만 웹 미리보기는 지원되지 않습니다.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
