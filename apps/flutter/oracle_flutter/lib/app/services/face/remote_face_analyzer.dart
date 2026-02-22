import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:oracle_flutter/app/services/ai/ai_service.dart';
import 'package:oracle_flutter/app/services/face/face_analyzer.dart';

class RemoteFaceAnalyzer implements FaceAnalyzer {
  RemoteFaceAnalyzer(this._aiService, {this.sajuContext});

  final AiService _aiService;
  final String? sajuContext;

  @override
  Future<FaceReadingResult> analyze(String imagePath) async {
    final bytes = await XFile(imagePath).readAsBytes();
    final base64Image = base64Encode(bytes);
    final mimeType = _guessMimeType(imagePath);

    final result = await _aiService.getFaceReading(
      features: {
        // When vision is available, these can remain lightweight hints.
        'faceShape': 'unknown',
      },
      imageBase64: base64Image,
      mimeType: mimeType,
      sajuContext: sajuContext,
    );

    final details = result.details;
    final featuresKo = <String, String>{};
    final featuresEn = <String, String>{};
    for (final d in details) {
      featuresKo[d.category] = d.content;
      featuresEn[d.category] = d.content;
    }
    // Fallback keys if the model returns non-part categories.
    if (featuresKo.isEmpty) {
      featuresKo.addAll({
        '이마': '리더십과 결단력이 균형적으로 나타납니다.',
        '눈': '관찰력과 공감 능력이 강한 흐름입니다.',
        '코': '재물과 실행력 측면에서 안정성을 보입니다.',
        '입': '표현력과 대인 소통에서 강점을 보입니다.',
        '턱': '지속력과 마무리 힘이 좋은 편입니다.',
      });
      featuresEn.addAll(featuresKo);
    }

    final rated = details.where((d) => d.rating != null).toList();
    final avgRating = rated.isEmpty
        ? 75
        : ((rated.map((d) => d.rating!).fold<int>(0, (a, b) => a + b) /
                    rated.length) *
                20)
            .round();

    return FaceReadingResult(
      overview:
          '${result.summary}\n\n${details.map((d) => '- ${d.category}: ${d.content}').join('\n')}',
      overviewKo:
          '${result.summary}\n\n${details.map((d) => '- ${d.category}: ${d.content}').join('\n')}',
      features: featuresEn,
      featuresKo: featuresKo,
      advice: result.caution ?? '',
      adviceKo: result.caution ?? '',
      compatibilityScore: avgRating.clamp(0, 100).toInt(),
    );
  }

  String _guessMimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
