import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_1/core/theme/app_colors.dart';

class FaceReadingScreen extends ConsumerStatefulWidget {
  const FaceReadingScreen({super.key});

  @override
  ConsumerState<FaceReadingScreen> createState() => _FaceReadingScreenState();
}

class _FaceReadingScreenState extends ConsumerState<FaceReadingScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;
  bool _hasResult = false;
  XFile? _image;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = image;
        _hasResult = false;
      });
    }
  }

  Future<void> _analyze() async {
    if (_image == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    // Simulate AI duration
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _hasResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Reading')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Preview Area
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: _image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.face_retouching_natural,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('Upload a photo to start analysis'),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilledButton.icon(
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Camera'),
                            ),
                            const SizedBox(width: 16),
                            OutlinedButton.icon(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Gallery'),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Stack(
                      // TODO: Display image with FileImage(_image!.path) - skipped for now to avoid IO import issues in snippet
                      alignment: Alignment.center,
                      children: [
                        const Center(
                            child: Icon(Icons.image,
                                size: 100, color: Colors.grey)),
                        // In real implementation: Image.file(File(_image!.path), fit: BoxFit.cover)
                        if (_isAnalyzing)
                          Container(
                            color: Colors.black54,
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                          ),
                      ],
                    ),
            ),

            const SizedBox(height: 24),

            if (_image != null && !_hasResult && !_isAnalyzing)
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _analyze,
                  child: const Text('Start Analysis'),
                ),
              ),

            if (_hasResult) ...[
              Card(
                color: AppColors.surface,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'Noble Leader Face',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Your forehead suggests strong leadership qualities and intelligence. The bridge of your nose indicates good fortune in mid-life.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _image = null;
                    _hasResult = false;
                  });
                },
                child: const Text('Analyze Another Photo'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
