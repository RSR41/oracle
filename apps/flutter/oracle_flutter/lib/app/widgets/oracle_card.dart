import 'package:flutter/material.dart';

/// A card component mimicking React `OracleCard.tsx`.
/// Supports title, description, icon, badge, and optional click action with scale animation.
class OracleCard extends StatefulWidget {
  final String title;
  final String? description;
  final Widget? icon;
  final String? badge;
  final Color? accentColor; // Default: Primary
  final VoidCallback? onTap;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const OracleCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.badge,
    this.accentColor,
    this.onTap,
    this.child,
    this.padding = const EdgeInsets.all(20.0), // p-5 approx
    this.margin,
  });

  @override
  State<OracleCard> createState() => _OracleCardState();
}

class _OracleCardState extends State<OracleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Animation for Scale (whileTap: 0.98)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // Fast response
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isClickable = widget.onTap != null;

    // Accent Color Default: Primary
    final effectiveAccentColor =
        widget.accentColor ?? colorScheme.primaryContainer;
    // React default is 'bg-primary', but logic says `accentColor` props.
    // If icon is present, we wrap it in a container with accentColor.

    final cardContent = Container(
      width: double.infinity,
      padding: widget.padding,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? colorScheme.surface, // bg-card
        borderRadius: BorderRadius.circular(16.0), // rounded-2xl approx
        border: Border.all(
          color: theme.dividerColor.withValues(
            alpha: 0.1,
          ), // border-border approx
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // shadow-sm
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Section
              if (widget.icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(10.0), // p-2.5
                  decoration: BoxDecoration(
                    color: effectiveAccentColor,
                    borderRadius: BorderRadius.circular(12.0), // rounded-xl
                  ),
                  child: IconTheme(
                    data: IconThemeData(
                      color: effectiveAccentColor.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                      size: 24,
                    ),
                    child: widget.icon!,
                  ),
                ),
                const SizedBox(width: 12), // gap-3
              ],

              // Text Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600, // font-semibold
                          ),
                        ),
                        if (widget.badge != null) ...[
                          const SizedBox(width: 8), // gap-2
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                100,
                              ), // rounded-full
                            ),
                            child: Text(
                              widget.badge!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                                fontSize:
                                    10, // text-xs ~ 12, but scale down slightly
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (widget.description != null) ...[
                      const SizedBox(height: 4), // mt-1
                      Text(
                        widget.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(
                            alpha: 0.7,
                          ), // muted-foreground
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Chevron for onClick
              if (isClickable) ...[
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: theme.disabledColor, // text-muted-foreground
                ),
              ],
            ],
          ),
          if (widget.child != null) ...[
            // Logic: React puts children below the header row
            // But React source wrapper is `Component` -> `div.flex...header` -> `children`.
            // So children are effectively below header.
            if (widget.child != null) widget.child!,
          ],
        ],
      ),
    );

    if (isClickable) {
      return GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(scale: _scaleAnimation, child: cardContent),
      );
    }

    return cardContent;
  }
}
