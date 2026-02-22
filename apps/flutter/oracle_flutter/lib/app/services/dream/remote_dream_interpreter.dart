import 'package:oracle_flutter/app/services/ai/ai_service.dart';
import 'package:oracle_flutter/app/services/dream/dream_interpreter.dart';

class RemoteDreamInterpreter implements DreamInterpreter {
  RemoteDreamInterpreter(this._aiService, {this.sajuContext});

  final AiService _aiService;
  final String? sajuContext;

  @override
  Future<DreamResult> interpret(String dreamContent) async {
    final aiResult = await _aiService.getDreamMeaning(
      dreamDescription: dreamContent,
      sajuContext: sajuContext,
    );

    final keywords = aiResult.details.map((d) => d.category).take(5).toList();
    final rated = aiResult.details.where((d) => d.rating != null).toList();
    final score = rated.isEmpty
        ? 75
        : ((rated.map((d) => d.rating!).fold<int>(0, (a, b) => a + b) /
                    rated.length) *
                20)
            .round();

    return DreamResult(
      summary: aiResult.summary,
      details: aiResult.details.map((d) => '${d.category}: ${d.content}').join('\n\n'),
      keywords: keywords.isEmpty ? ['해석', '통찰'] : keywords,
      advice: aiResult.caution ?? '오늘의 흐름에 맞춰 차분히 행동하세요.',
      luckScore: score.clamp(0, 100).toInt(),
    );
  }
}
