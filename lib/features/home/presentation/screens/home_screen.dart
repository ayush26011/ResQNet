import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/neumorphic_card.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../ai_assistant/presentation/screens/ai_assistant_screen.dart';
import '../../../ai_assistant/domain/ai_assistant_provider.dart';
import '../../../ai_assistant/data/local_model_manager.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userName = ref.watch(userNameProvider);
    final userStatus = ref.watch(userStatusProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.warmCream,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _HomeHeader(isDark: isDark, userName: userName),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 4),
                _StatusWidget(isDark: isDark, status: userStatus),
                const SizedBox(height: AppConstants.spaceXL),
                _QuickActionsGrid(isDark: isDark),
                const SizedBox(height: AppConstants.spaceXL),
                _AiAssistantCard(isDark: isDark),
                const SizedBox(height: AppConstants.spaceXL),
                SectionHeader(
                  title: 'Nearby Help',
                  subtitle: 'Resources around you',
                  trailing: TextButton(
                    onPressed: () {},
                    child: Text(
                      'View all',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.deepMint,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spaceMD),
                _NearbyHelpList(isDark: isDark),
                const SizedBox(height: AppConstants.spaceXL),
                _EmergencyTipCard(isDark: isDark),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final bool isDark;
  final String userName;
  const _HomeHeader({required this.isDark, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppConstants.horizontalPadding,
        MediaQuery.of(context).padding.top + 16,
        AppConstants.horizontalPadding,
        AppConstants.spaceXXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning,',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    userName,
                    style: AppTextStyles.displaySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              AnimatedIconButton(
                icon: Icons.notifications_rounded,
                tooltip: 'Notifications',
                onTap: () {},
              ),
              const SizedBox(width: 12),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.mintGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepMint.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),

          const SizedBox(height: AppConstants.spaceXXL),

          // Welcome card
          _WelcomeHeroCard(isDark: isDark)
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}

class _WelcomeHeroCard extends StatelessWidget {
  final bool isDark;
  const _WelcomeHeroCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkCard,
                  AppColors.darkCardElevated,
                ],
              )
            : AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.neuDarkMode.withOpacity(0.8)
                : AppColors.deepMint.withOpacity(0.3),
            offset: const Offset(0, 12),
            blurRadius: 32,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Organic blob shape
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const PulsingDot(color: AppColors.successGreen, size: 10),
                    const SizedBox(width: 8),
                    Text(
                      'All Systems Operational',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stay Safe,\nStay Connected.',
                      style: AppTextStyles.displaySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Emergency network is active near you',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusWidget extends StatelessWidget {
  final bool isDark;
  final String status;
  const _StatusWidget({required this.isDark, required this.status});

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(AppConstants.paddingLG),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.successGreenLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: AppColors.successGreen,
              size: 26,
            ),
          ),
          const SizedBox(width: AppConstants.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Status',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'You are $status',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(
            label: status,
            color: AppColors.successGreen,
            icon: Icons.check_circle_outline_rounded,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 450.ms).slideY(begin: 0.1, end: 0);
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final bool isDark;
  const _QuickActionsGrid({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.emergency_rounded,
        label: 'SOS Alert',
        color: AppColors.emergencyRed,
        bgColor: AppColors.emergencyRedLight,
      ),
      _QuickAction(
        icon: Icons.medical_services_rounded,
        label: 'First Aid',
        color: AppColors.deepBlue,
        bgColor: AppColors.powderBlue,
      ),
      _QuickAction(
        icon: Icons.location_on_rounded,
        label: 'My Location',
        color: AppColors.deepAqua,
        bgColor: AppColors.lightAqua,
      ),
      _QuickAction(
        icon: Icons.call_rounded,
        label: 'Call Help',
        color: AppColors.deepMint,
        bgColor: AppColors.mintGreen,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Quick Actions',
          subtitle: 'Fast access to emergency tools',
        ),
        const SizedBox(height: AppConstants.spaceMD),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppConstants.spaceMD,
          crossAxisSpacing: AppConstants.spaceMD,
          childAspectRatio: 1.5,
          children: actions.asMap().entries.map((e) {
            return _QuickActionCard(
              action: e.value,
              isDark: isDark,
              delay: Duration(milliseconds: 400 + e.key * 80),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;
  final bool isDark;
  final Duration delay;
  const _QuickActionCard({
    required this.action,
    required this.isDark,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: AppConstants.radiusLG,
      padding: const EdgeInsets.all(AppConstants.paddingLG),
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? action.color.withOpacity(0.15)
                  : action.bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(action.icon, color: action.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              action.label,
              style: AppTextStyles.headlineSmall.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay, duration: 400.ms)
        .slideY(begin: 0.15, end: 0);
  }
}

class _NearbyHelpList extends StatelessWidget {
  final bool isDark;
  const _NearbyHelpList({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NearbyItem(
        name: 'City Hospital',
        type: 'Hospital',
        distance: '0.8 km',
        icon: Icons.local_hospital_rounded,
        color: AppColors.emergencyRed,
      ),
      _NearbyItem(
        name: 'Fire Station No. 4',
        type: 'Fire Station',
        distance: '1.2 km',
        icon: Icons.local_fire_department_rounded,
        color: AppColors.warningAmber,
      ),
      _NearbyItem(
        name: 'Police HQ',
        type: 'Police Station',
        distance: '2.1 km',
        icon: Icons.local_police_rounded,
        color: AppColors.deepBlue,
      ),
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) => _NearbyCard(
          item: items[index],
          isDark: isDark,
          delay: Duration(milliseconds: 600 + index * 100),
        ),
      ),
    );
  }
}

class _NearbyItem {
  final String name;
  final String type;
  final String distance;
  final IconData icon;
  final Color color;
  const _NearbyItem({
    required this.name,
    required this.type,
    required this.distance,
    required this.icon,
    required this.color,
  });
}

class _NearbyCard extends StatelessWidget {
  final _NearbyItem item;
  final bool isDark;
  final Duration delay;
  const _NearbyCard({
    required this.item,
    required this.isDark,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: AppConstants.radiusLG,
      padding: const EdgeInsets.all(AppConstants.paddingMD),
      onTap: () {},
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: item.color, size: 18),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mintGreen.withOpacity(isDark ? 0.2 : 1.0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.distance,
                    style: AppTextStyles.captionText.copyWith(
                      color: AppColors.deepMint,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.type,
                  style: AppTextStyles.captionText,
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delay, duration: 400.ms)
        .slideX(begin: 0.15, end: 0);
  }
}

class _EmergencyTipCard extends StatelessWidget {
  final bool isDark;
  const _EmergencyTipCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [AppColors.darkCard, AppColors.darkCardElevated],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.powderBlue, AppColors.lightAqua],
              ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.neuDarkMode.withOpacity(0.7)
                : AppColors.deepBlue.withOpacity(0.2),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  label: 'Daily Tip',
                  color: AppColors.deepBlue,
                ),
                const SizedBox(height: 10),
                Text(
                  'During a fire, stay low to avoid smoke inhalation and crawl to the nearest exit.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Learn more →',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.deepBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: AppColors.deepBlue,
              size: 28,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 800.ms, duration: 450.ms)
        .slideY(begin: 0.1, end: 0);
  }
}

class _AiAssistantCard extends ConsumerWidget {
  final bool isDark;
  const _AiAssistantCard({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(modelStatusProvider);
    
    String badgeText = 'Configure';
    Color badgeColor = AppColors.warningAmber;
    if (status == ModelStatus.ready) {
      badgeText = 'Ready';
      badgeColor = AppColors.successGreen;
    } else if (status == ModelStatus.loading) {
      badgeText = 'Loading';
      badgeColor = AppColors.warningAmber;
    } else if (status == ModelStatus.importing) {
      badgeText = 'Importing';
      badgeColor = AppColors.warningAmber;
    } else if (status == ModelStatus.loadFailed) {
      badgeText = 'Failed';
      badgeColor = AppColors.emergencyRed;
    } else if (status == ModelStatus.invalid) {
      badgeText = 'Invalid';
      badgeColor = AppColors.emergencyRed;
    } else if (status == ModelStatus.missing) {
      badgeText = 'Model Missing';
      badgeColor = AppColors.emergencyRed;
    }

    return NeumorphicContainer(
      borderRadius: AppConstants.radiusXL,
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AiAssistantScreen(),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.powderBlue.withOpacity(isDark ? 0.2 : 0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: AppColors.deepBlue,
              size: 28,
            ),
          ),
          const SizedBox(width: AppConstants.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Offline AI Assistant',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Ask emergency questions completely offline',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.deepBlue,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 450.ms).slideY(begin: 0.1, end: 0);
  }
}
