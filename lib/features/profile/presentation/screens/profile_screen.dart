import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/neumorphic_card.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/models/emergency_contact.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsOn = true;
  bool _locationOn = true;
  String _language = 'English';
  int _selectedLanguage = 0;

  final _languages = ['English', 'हिंदी', 'தமிழ்', 'বাংলা', 'मराठी'];

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final userName = ref.watch(userNameProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.warmCream,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _ProfileHeader(isDark: isDark, userName: userName),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Settings sections
                _SectionTitle('Preferences', isDark),
                const SizedBox(height: AppConstants.spaceSM),
                NeumorphicCard(
                  padding: const EdgeInsets.all(AppConstants.paddingMD),
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.notifications_rounded,
                        iconColor: AppColors.deepBlue,
                        iconBg: AppColors.powderBlue,
                        title: 'Push Notifications',
                        subtitle: 'Emergency alerts & updates',
                        isDark: isDark,
                        trailing: Switch.adaptive(
                          value: _notificationsOn,
                          onChanged: (v) => setState(() => _notificationsOn = v),
                          activeColor: AppColors.deepMint,
                        ),
                      ),
                      AppDivider(margin: const EdgeInsets.symmetric(vertical: 4)),
                      _SettingsTile(
                        icon: Icons.location_on_rounded,
                        iconColor: AppColors.deepAqua,
                        iconBg: AppColors.lightAqua,
                        title: 'Location Sharing',
                        subtitle: 'Share location in emergencies',
                        isDark: isDark,
                        trailing: Switch.adaptive(
                          value: _locationOn,
                          onChanged: (v) => setState(() => _locationOn = v),
                          activeColor: AppColors.deepMint,
                        ),
                      ),
                      AppDivider(margin: const EdgeInsets.symmetric(vertical: 4)),
                      _SettingsTile(
                        icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        iconColor: AppColors.warningAmber,
                        iconBg: AppColors.warningAmberLight,
                        title: 'Dark Mode',
                        subtitle: isDark ? 'Currently dark' : 'Currently light',
                        isDark: isDark,
                        trailing: Switch.adaptive(
                          value: isDark,
                          onChanged: (_) =>
                              ref.read(themeProvider.notifier).toggleTheme(),
                          activeColor: AppColors.deepMint,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: AppConstants.spaceXL),
                _SectionTitle('Language', isDark),
                const SizedBox(height: AppConstants.spaceSM),
                _LanguagePicker(
                  languages: _languages,
                  selectedIndex: _selectedLanguage,
                  isDark: isDark,
                  onSelect: (i) => setState(() {
                    _selectedLanguage = i;
                    _language = _languages[i];
                  }),
                ).animate().fadeIn(delay: 380.ms),

                const SizedBox(height: AppConstants.spaceXL),
                _SectionTitle('Emergency Contacts', isDark),
                const SizedBox(height: AppConstants.spaceSM),
                _EmergencyContactManager(isDark: isDark)
                    .animate()
                    .fadeIn(delay: 450.ms),

                const SizedBox(height: AppConstants.spaceXL),
                _SectionTitle('About ResQNet', isDark),
                const SizedBox(height: AppConstants.spaceSM),
                NeumorphicCard(
                  padding: const EdgeInsets.all(AppConstants.paddingMD),
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.info_rounded,
                        iconColor: AppColors.deepMint,
                        iconBg: AppColors.mintGreen,
                        title: 'Version 1.0.0',
                        subtitle: 'Build 2026.06',
                        isDark: isDark,
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      AppDivider(margin: const EdgeInsets.symmetric(vertical: 4)),
                      _SettingsTile(
                        icon: Icons.privacy_tip_rounded,
                        iconColor: AppColors.deepBlue,
                        iconBg: AppColors.powderBlue,
                        title: 'Privacy Policy',
                        subtitle: 'How we protect your data',
                        isDark: isDark,
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      AppDivider(margin: const EdgeInsets.symmetric(vertical: 4)),
                      _SettingsTile(
                        icon: Icons.star_rounded,
                        iconColor: AppColors.warningAmber,
                        iconBg: AppColors.warningAmberLight,
                        title: 'Rate ResQNet',
                        subtitle: 'Help us improve',
                        isDark: isDark,
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 500.ms),

                const SizedBox(height: AppConstants.spaceXXL),
                Center(
                  child: AnimatedPrimaryButton(
                    label: 'Sign Out',
                    onTap: () {},
                    backgroundColor: isDark
                        ? AppColors.darkCard
                        : AppColors.softBeige,
                    foregroundColor: AppColors.textSecondary,
                    icon: Icons.logout_rounded,
                  ),
                ).animate().fadeIn(delay: 550.ms),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final bool isDark;
  final String userName;
  const _ProfileHeader({required this.isDark, required this.userName});

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
        children: [
          Text(
            'Profile',
            style: AppTextStyles.displaySmall.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: AppConstants.spaceXXL),
          // Avatar card
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingXL),
            decoration: BoxDecoration(
              gradient: isDark
                  ? LinearGradient(
                      colors: [AppColors.darkCard, AppColors.darkCardElevated],
                    )
                  : AppColors.heroGradient,
              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? AppColors.neuDarkMode.withOpacity(0.8)
                      : AppColors.deepMint.withOpacity(0.25),
                  offset: const Offset(0, 12),
                  blurRadius: 32,
                ),
              ],
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.deepMint, AppColors.deepAqua],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.deepMint.withOpacity(0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          userName.isNotEmpty
                              ? userName[0].toUpperCase()
                              : 'A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.successGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'ResQNet Member',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      StatusBadge(
                        label: '✅ Verified Safe',
                        color: AppColors.successGreen,
                      ),
                    ],
                  ),
                ),
                AnimatedIconButton(
                  icon: Icons.edit_rounded,
                  onTap: () {},
                  size: 40,
                  iconSize: 18,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionTitle(this.title, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.headlineMedium.copyWith(
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool isDark;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.isDark,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDark ? iconColor.withOpacity(0.15) : iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  final List<String> languages;
  final int selectedIndex;
  final bool isDark;
  final ValueChanged<int> onSelect;

  const _LanguagePicker({
    required this.languages,
    required this.selectedIndex,
    required this.isDark,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(AppConstants.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Language',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: languages.asMap().entries.map((e) {
              final isSelected = e.key == selectedIndex;
              return GestureDetector(
                onTap: () => onSelect(e.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.deepMint
                        : (isDark
                            ? AppColors.darkCardElevated
                            : AppColors.surfaceLight),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.deepMint.withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    e.value,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected
                          ? AppColors.white
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _EmergencyContactManager extends ConsumerWidget {
  final bool isDark;
  const _EmergencyContactManager({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(emergencyContactsProvider);

    return NeumorphicCard(
      padding: const EdgeInsets.all(AppConstants.paddingMD),
      child: Column(
        children: [
          ...contacts.map(
            (c) => _ContactRow(
              contact: c,
              isDark: isDark,
              onDelete: () {
                if (c.id != null) {
                  ref.read(emergencyContactsProvider.notifier).removeContact(c.id!);
                }
              },
            ),
          ),
          if (contacts.isNotEmpty)
            AppDivider(margin: const EdgeInsets.symmetric(vertical: 8)),
          GestureDetector(
            onTap: () => _addContact(context, ref),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: AppColors.deepMint,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add Emergency Contact',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.deepMint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addContact(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedRelation = 'Family';
    final relations = ['Family', 'Friend', 'Doctor', 'Other'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text('Add Contact'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Contact Name',
                        hintText: 'Enter name',
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter phone number',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedRelation,
                      decoration: InputDecoration(
                        labelText: 'Relationship',
                        prefixIcon: const Icon(Icons.people_outline_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      items: relations.map((r) {
                        return DropdownMenuItem(
                          value: r,
                          child: Text(r),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            selectedRelation = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepMint,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final name = nameController.text.trim();
                    final phone = phoneController.text.trim();
                    if (name.isNotEmpty && phone.isNotEmpty) {
                      ref.read(emergencyContactsProvider.notifier).addContact(
                            EmergencyContact(
                              name: name,
                              phone: phone,
                              relation: selectedRelation,
                              priority: 1,
                              createdAt: DateTime.now(),
                            ),
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ContactRow extends StatelessWidget {
  final EmergencyContact contact;
  final bool isDark;
  final VoidCallback onDelete;
  const _ContactRow({
    required this.contact,
    required this.isDark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.mintGreen.withOpacity(isDark ? 0.2 : 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                contact.name.isNotEmpty ? contact.name[0] : 'C',
                style: TextStyle(
                  color: AppColors.deepMint,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                Text(contact.phone, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          StatusBadge(label: contact.relation, color: AppColors.deepMint),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.remove_circle_outline_rounded,
              color: AppColors.emergencyRed.withOpacity(0.7),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
