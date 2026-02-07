import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SVG string for error fallback image.
/// Decoded from React `ImageWithFallback.tsx` base64.
const String _kErrorSvgString = '''
<svg width="88" height="88" xmlns="http://www.w3.org/2000/svg" stroke="#000" stroke-linejoin="round" opacity=".3" fill="none" stroke-width="3.7">
  <rect x="16" y="16" width="56" height="56" rx="6"/>
  <path d="m16 58 16-18 32 32"/>
  <circle cx="53" cy="35" r="7"/>
</svg>
''';

/// A widget that displays an image from a network source,
/// falling back to a specific SVG error placeholder if loading fails.
///
/// Port of `src/app/components/figma/ImageWithFallback.tsx`.
class ImageWithFallback extends StatelessWidget {
  final String src;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final String? semanticLabel; // alt text

  const ImageWithFallback({
    super.key,
    required this.src,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    // If src is empty, show fallback immediately
    if (src.isEmpty) {
      return _buildFallback(context);
    }

    final image = Image.network(
      src,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallback(context);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoading(context);
      },
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  Widget _buildFallback(BuildContext context) {
    // React style: bg-gray-100 (approx Colors.grey[100])
    // Centered SVG.
    final fallback = Container(
      width: width,
      height: height,
      color:
          Colors.grey[100], // or Theme.of(context).colorScheme.surfaceVariant
      alignment: Alignment.center,
      child: SizedBox(
        width: 88, // SVG width
        height: 88, // SVG height
        child: SvgPicture.string(_kErrorSvgString, fit: BoxFit.contain),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: fallback);
    }
    return fallback;
  }

  Widget _buildLoading(BuildContext context) {
    final loading = Container(
      width: width,
      height: height,
      color: Colors.grey[50], // lighter placeholder
      alignment: Alignment.center,
      // Optional: child: CircularProgressIndicator(),
    );
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: loading);
    }
    return loading;
  }
}
