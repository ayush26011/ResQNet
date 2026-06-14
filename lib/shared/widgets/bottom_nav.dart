import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = [
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.emergency_rounded, label: 'SOS'),
      _NavItem(icon: Icons.medical_services_rounded, label: 'First Aid'),
      _NavItem(icon: Icons.map_rounded, label: 'Maps'),
      _NavItem(icon: Icons.person_rounded, label: 'Profile'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusXXL),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.neuDarkMode.withOpacity(0.9)
                : AppColors.neuDark.withOpacity(0.35),
            offset: const Offset(8, 8),
            blurRadius: 24,
          ),
          BoxShadow(
            color: isDark
                ? AppColors.neuLightDarkMode.withOpacity(0.3)
                : AppColors.neuLight.withOpacity(0.9),
            offset: const Offset(-8, -8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((e) {
          final index = e.key;
          final item = e.value;
          final isSelected = index == currentIndex;
          final isSOS = index == 1;

          if (isSOS) {
            return _SOSNavItem(
              isSelected: isSelected,
              onTap: () => onTap(index),
            );
          }

          return _NavItemWidget(
            item: item,
            isSelected: isSelected,
            isDark: isDark,
            onTap: () => onTap(index),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _NavItemWidget extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.mintGreen.withOpacity(isDark ? 0.2 : 1.0)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 22,
              color: isSelected
                  ? AppColors.deepMint
                  : (isDark ? AppColors.darkTextSecondary : AppColors.textTertiary),
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: AppTextStyles.navLabel.copyWith(
                color: isSelected
                    ? AppColors.deepMint
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textTertiary),
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SOSNavItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _SOSNavItem({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF5A5F), Color(0xFFFF8C94)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.emergencyRed
                      .withOpacity(isSelected ? 0.55 : 0.35),
                  blurRadius: isSelected ? 20 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.emergency_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'SOS',
            style: AppTextStyles.navLabel.copyWith(
              color: AppColors.emergencyRed,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
