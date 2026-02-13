import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oracle_flutter/app/screens/face/face_reading_screen.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('이미지 선택 직후 썸네일 표시 및 분석 버튼 활성화', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: MaterialApp(
          home: FaceReadingScreen(
            onPickImage: (_) async => XFile('/tmp/selected_face.jpg'),
          ),
        ),
      ),
    );

    final initialAnalyzeButton = tester.widget<FilledButton>(
      find.byKey(const Key('face_analyze_button')),
    );
    expect(initialAnalyzeButton.onPressed, isNull);

    await tester.tap(find.byIcon(Icons.photo_library));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('face_selected_image_preview')), findsOneWidget);

    final enabledAnalyzeButton = tester.widget<FilledButton>(
      find.byKey(const Key('face_analyze_button')),
    );
    expect(enabledAnalyzeButton.onPressed, isNotNull);
  });
}
