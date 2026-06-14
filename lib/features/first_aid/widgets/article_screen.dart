import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../data/first_aid_data.dart';

class ArticleScreen extends StatelessWidget {
  final FirstAidArticle article;
  final String categoryEmoji;

  const ArticleScreen({
    super.key,
    required this.article,
    required this.categoryEmoji,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.warmCream,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.warmCream,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? AppColors.neuDarkMode.withOpacity(0.7)
                            : AppColors.neuDark.withOpacity(0.3),
                        offset: const Offset(2, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                margin: const EdgeInsets.fromLTRB(20, 80, 20, 10),
                padding: const EdgeInsets.all(AppConstants.paddingXL),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? LinearGradient(
                          colors: [
                            AppColors.darkCard,
                            AppColors.darkCardElevated
                          ],
                        )
                      : AppColors.heroGradient,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusXL),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StatusBadge(
                            label: article.difficulty,
                            color: article.difficulty == 'Critical'
                                ? AppColors.emergencyRed
                                : article.difficulty == 'High'
                                    ? AppColors.warningAmber
                                    : AppColors.deepMint,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            article.title,
                            style: AppTextStyles.headlineLarge.copyWith(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            article.duration,
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      article.emoji,
                      style: const TextStyle(fontSize: 52),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.horizontalPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Summary
                Text(
                  article.summary,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    height: 1.7,
                  ),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: AppConstants.spaceXXL),

                // Steps
                Text(
                  'Step-by-Step Guide',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: AppConstants.spaceMD),
                ...article.steps.asMap().entries.map(
                      (e) => _StepCard(
                        stepNumber: e.key + 1,
                        step: e.value,
                        isDark: isDark,
                        delay: Duration(milliseconds: 350 + e.key * 80),
                      ),
                    ),

                const SizedBox(height: AppConstants.spaceXXL),

                // Warnings
                if (article.warnings.isNotEmpty) ...[
                  Text(
                    '⚠️ Important Warnings',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.warningAmber,
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: AppConstants.spaceMD),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingXL),
                    decoration: BoxDecoration(
                      color: AppColors.warningAmber.withOpacity(0.08),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusLG),
                      border: Border.all(
                        color: AppColors.warningAmber.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: article.warnings
                          .map(
                            (w) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    color: AppColors.warningAmber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      w,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.textPrimary,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ).animate().fadeIn(delay: 550.ms),
                ],

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int stepNumber;
  final String step;
  final bool isDark;
  final Duration delay;

  const _StepCard({
    required this.stepNumber,
    required this.step,
    required this.isDark,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 14, top: 2),
            decoration: BoxDecoration(
              gradient: AppColors.mintGradient,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepMint.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppConstants.paddingMD),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? AppColors.neuDarkMode.withOpacity(0.7)
                        : AppColors.neuDark.withOpacity(0.25),
                    offset: const Offset(3, 3),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: isDark
                        ? AppColors.neuLightDarkMode.withOpacity(0.3)
                        : AppColors.neuLight,
                    offset: const Offset(-3, -3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text(
                step,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay, duration: 350.ms).slideX(begin: -0.1, end: 0);
  }
}
