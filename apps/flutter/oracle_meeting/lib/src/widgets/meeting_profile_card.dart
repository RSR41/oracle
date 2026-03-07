import 'package:flutter/material.dart';
import '../models/meeting_user.dart';
import '../theme/meeting_theme.dart';
import 'compatibility_badge.dart';

/// Premium profile card for recommendation view
class MeetingProfileCard extends StatelessWidget {
  final MeetingUser user;
  final int compatibilityScore;
  final VoidCallback onLike;
  final VoidCallback onPass;
  final VoidCallback? onTap;

  const MeetingProfileCard({
    super.key,
    required this.user,
    required this.compatibilityScore,
    required this.onLike,
    required this.onPass,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: MeetingTheme.profileCardDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              // Profile image area with gradient overlay
              _buildPhotoArea(),
              // Info area
              _buildInfoArea(),
              // Action buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: MeetingTheme.cardGradient,
      ),
      child: Stack(
        children: [
          // Background with avatar initial
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4), width: 3),
                  ),
                  child: Center(
                    child: Text(
                      user.nickname.isNotEmpty ? user.nickname[0] : '?',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Name + Age + Gender
                Text(
                  '${user.nickname}, ${user.displayAge}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (user.regionName != null) ...[
                      Icon(Icons.location_on_outlined,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.85)),
                      const SizedBox(width: 4),
                      Text(
                        user.regionName!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (user.occupation != null)
                      Text(
                        user.occupation!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Compatibility badge (top-right)
          Positioned(
            top: 16,
            right: 16,
            child: CompatibilityBadge(score: compatibilityScore, size: 60),
          ),
          // Gender badge (top-left)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Text(
                user.gender == 'F' ? '👩 여성' : '👨 남성',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: MeetingTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Introduction
          if (user.introduction != null) ...[
            Text(
              user.introduction!,
              style: MeetingTheme.bodyLarge.copyWith(height: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
          ],
          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (user.height != null)
                _buildTag('📏 ${user.height}cm'),
              ...?user.activityTags?.map((t) => _buildTag(t)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: MeetingTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: MeetingTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: MeetingTheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pass button
          ElevatedButton(
            onPressed: onPass,
            style: MeetingTheme.passButtonStyle,
            child: const Icon(Icons.close_rounded, size: 28),
          ),
          // Like button (larger)
          ElevatedButton(
            onPressed: onLike,
            style: MeetingTheme.likeButtonStyle,
            child: const Icon(Icons.favorite_rounded, size: 32),
          ),
        ],
      ),
    );
  }
}
