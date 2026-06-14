import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SuggestedPromptChips extends StatelessWidget {
  final ValueChanged<String> onTapPrompt;
  final bool isDark;

  static const List<String> prompts = [
    'CPR kaise kare?',
    'Snake bite ho jaye to kya karu?',
    'Flood me safe kaise rahu?',
    'Emergency bag me kya hona chahiye?',
    'Mujhe panic ho raha hai kya karu?',
    'Bina internet raste kaise dhoondhu?',
    'Explain earthquake safety in Hinglish',
  ];

  const SuggestedPromptChips({
    super.key,
    required this.onTapPrompt,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: prompts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final prompt = prompts[index];
          return GestureDetector(
            onTap: () => onTapPrompt(prompt),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.neuLightDarkMode.withOpacity(0.3)
                      : AppColors.divider,
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? AppColors.neuDarkMode.withOpacity(0.4)
                        : AppColors.neuDark.withOpacity(0.15),
                    offset: const Offset(2, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  prompt,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
