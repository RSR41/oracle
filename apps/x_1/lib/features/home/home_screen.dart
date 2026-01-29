import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x_1/router/app_router.dart';
import 'package:x_1/core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push(AppRoute.history.path),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoute.settings.path),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Today's Fortune Card
            Card(
              color: AppColors.primary,
              child: InkWell(
                onTap: () => context.push(AppRoute.input.path),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        '?”® Today\'s Fortune',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => context.push(AppRoute.input.path),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                        ),
                        icon: const Icon(Icons.visibility),
                        label: const Text('View Fortune'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Feature Grid
            Text('Services', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _FeatureCard(
                  icon: Icons.calendar_month,
                  label: 'Manseok',
                  onTap: () => context.push(AppRoute.fortune.path),
                ),
                _FeatureCard(
                  icon: Icons.favorite,
                  label: 'Compatibility',
                  onTap: () => context.push(AppRoute.compatibility.path),
                  color: Colors.pink[100],
                  iconColor: Colors.pink,
                ),
                _FeatureCard(
                  icon: Icons.face,
                  label: 'Face Reading',
                  onTap: () => context.push(AppRoute.face.path),
                  color: Colors.blue[100],
                  iconColor: Colors.blue,
                ),
                _FeatureCard(
                  icon: Icons.style,
                  label: 'Tarot',
                  onTap: () => context.push(AppRoute.tarot.path),
                  color: Colors.purple[100],
                  iconColor: Colors.purple,
                ),
                _FeatureCard(
                  icon: Icons.cloud,
                  label: 'Dream',
                  onTap: () => context.push(AppRoute.dream.path),
                  color: Colors.indigo[100],
                  iconColor: Colors.indigo,
                ),
                // Placeholder for future features
                _FeatureCard(
                  icon: Icons.more_horiz,
                  label: 'More',
                  onTap: () {},
                  color: Colors.grey[200],
                  iconColor: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;

  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: color == null
            ? BorderSide(color: Colors.grey[300]!)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: iconColor ?? AppColors.primary),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
