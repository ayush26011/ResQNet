import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool isPressed;
  final bool isDarkMode;
  final VoidCallback? onTap;
  final double elevation;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
    this.backgroundColor,
    this.isPressed = false,
    this.isDarkMode = false,
    this.onTap,
    this.elevation = 8,
  });


  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode || Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.warmCream);

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isPressed
            ? []
            : [
                BoxShadow(
                  color: isDark
                      ? AppColors.neuDarkMode.withOpacity(0.9)
                      : AppColors.neuDark.withOpacity(0.45),
                  offset: Offset(elevation * 0.75, elevation * 0.75),
                  blurRadius: elevation * 2.2,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: isDark
                      ? AppColors.neuLightDarkMode.withOpacity(0.4)
                      : AppColors.neuLight.withOpacity(0.95),
                  offset: Offset(-elevation * 0.75, -elevation * 0.75),
                  blurRadius: elevation * 2.2,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}

class NeumorphicContainer extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final double elevation;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
    this.backgroundColor,
    this.onTap,
    this.elevation = 8,
  });

  @override
  State<NeumorphicContainer> createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: NeumorphicCard(
        borderRadius: widget.borderRadius,
        padding: widget.padding,
        backgroundColor: widget.backgroundColor,
        isPressed: _isPressed,
        onTap: null,
        elevation: widget.elevation,
        child: widget.child,
      ),
    );
  }
}
