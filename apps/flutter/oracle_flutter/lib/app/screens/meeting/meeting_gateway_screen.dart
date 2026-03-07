import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';

/// Mystical gateway screen: "인연을 믿으십니까?"
/// Appears when the user taps the meeting notification.
/// Once confirmed, meeting feature is permanently unlocked.
class MeetingGatewayScreen extends StatefulWidget {
  const MeetingGatewayScreen({super.key});

  @override
  State<MeetingGatewayScreen> createState() => _MeetingGatewayScreenState();
}

class _MeetingGatewayScreenState extends State<MeetingGatewayScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _scaleIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          // Starry particles background
          ..._buildStars(),
          // Main content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    // Glowing purple orb
                    AnimatedBuilder(
                      animation: _scaleIn,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleIn.value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            colors: [
                              Color(0xFFB388FF),
                              Color(0xFF7C4DFF),
                              Color(0xFF311B92),
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C4DFF).withValues(alpha: 0.6),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Main mystical text
                    FadeTransition(
                      opacity: _fadeIn,
                      child: Column(
                        children: [
                          const Text(
                            '인연을 믿으십니까?',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 2,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '사주와 관상이 이끄는 특별한 만남',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    // CTA button
                    FadeTransition(
                      opacity: _fadeIn,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _onConfirm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7C4DFF),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 8,
                                shadowColor:
                                    const Color(0xFF7C4DFF).withValues(alpha: 0.4),
                              ),
                              child: const Text(
                                '인연을 믿습니다',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              '아직은 아니에요',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirm() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.unlockMeeting();
    // Pop the gateway, then push meeting
    Navigator.of(context).pop();
    context.push('/meeting');
  }

  List<Widget> _buildStars() {
    // Simple decorative dots
    final stars = <Widget>[];
    final positions = [
      const Offset(0.1, 0.15),
      const Offset(0.85, 0.1),
      const Offset(0.2, 0.35),
      const Offset(0.75, 0.3),
      const Offset(0.5, 0.08),
      const Offset(0.15, 0.7),
      const Offset(0.9, 0.65),
      const Offset(0.4, 0.85),
      const Offset(0.65, 0.75),
      const Offset(0.3, 0.55),
    ];

    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final size = 2.0 + (i % 3);
      stars.add(
        Positioned(
          left: MediaQuery.of(context).size.width * pos.dx,
          top: MediaQuery.of(context).size.height * pos.dy,
          child: FadeTransition(
            opacity: _fadeIn,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3 + (i % 3) * 0.2),
              ),
            ),
          ),
        ),
      );
    }
    return stars;
  }
}
