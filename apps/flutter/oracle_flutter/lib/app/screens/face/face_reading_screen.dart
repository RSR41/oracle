import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/services/face/face_analyzer.dart';
import 'package:oracle_flutter/app/screens/face/selected_image_preview.dart';

class FaceReadingScreen extends StatefulWidget {
  const FaceReadingScreen({
    super.key,
    this.onPickImage,
    this.analyzer,
  });

  final Future<XFile?> Function(ImageSource source)? onPickImage;
  final FaceAnalyzer? analyzer;

  @override
  State<FaceReadingScreen> createState() => _FaceReadingScreenState();
}

class _FaceReadingScreenState extends State<FaceReadingScreen> {
  final _picker = ImagePicker();
  final FaceAnalyzer _defaultAnalyzer = MockFaceAnalyzer();
  String? _imagePath;
  bool _isAnalyzing = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await (widget.onPickImage != null
          ? widget.onPickImage!(source)
          : _picker.pickImage(
              source: source,
              maxWidth: 1024,
              maxHeight: 1024,
              imageQuality: 80,
            ));

      if (image != null) {
        setState(() => _imagePath = image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('이미지를 선택할 수 없습니다: $e')));
      }
    }
  }

  Future<void> _analyze() async {
    if (_imagePath == null) return;

    setState(() => _isAnalyzing = true);

    try {
      final result = await (widget.analyzer ?? _defaultAnalyzer).analyze(
        _imagePath!,
      );
      if (mounted) {
        context.push(
          '/face-result',
          extra: {'imagePath': _imagePath, 'result': result},
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('분석 중 오류가 발생했습니다: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: Text(appState.t('face.title')), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.caramel.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.face, size: 48, color: AppColors.primary),
                  const SizedBox(height: 12),
                  Text(
                    appState.t('face.title'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appState.t('face.upload'),
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Image Preview
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.2),
                ),
              ),
              child: _imagePath != null
                  ? buildSelectedImagePreview(
                      imagePath: _imagePath!,
                      borderRadius: BorderRadius.circular(16),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 48,
                            color: theme.disabledColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            appState.t('face.selectImage'),
                            style: TextStyle(color: theme.disabledColor),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 24),

            // Pick Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: Text(appState.t('face.camera')),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: Text(appState.t('face.gallery')),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Analyze Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const Key('face_analyze_button'),
                onPressed: _imagePath == null || _isAnalyzing ? null : _analyze,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isAnalyzing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('분석 중...'),
                        ],
                      )
                    : Text(appState.t('face.analyze')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
