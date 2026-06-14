import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(0),
        const SizedBox(width: 4),
        _buildDot(150),
        const SizedBox(width: 4),
        _buildDot(300),
      ],
    );
  }

  Widget _buildDot(int delayMs) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.deepMint,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(0.6, 0.6),
          end: const Offset(1.2, 1.2),
          duration: 600.ms,
          delay: delayMs.ms,
          curve: Curves.easeInOut,
        )
        .fade(
          begin: 0.4,
          end: 1.0,
          duration: 600.ms,
          delay: delayMs.ms,
          curve: Curves.easeInOut,
        );
  }
}
