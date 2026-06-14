import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/neumorphic_card.dart';

import '../../../../shared/widgets/animated_button.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../domain/sos_provider.dart';

class SOSScreen extends ConsumerStatefulWidget {
  const SOSScreen({super.key});

  @override
  ConsumerState<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends ConsumerState<SOSScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulse;
  late Animation<double> _glow;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glow = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    HapticFeedback.heavyImpact();
    ref.read(sosProvider.notifier).startCountdown();
    int seconds = 5;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      ref.read(sosProvider.notifier).updateCountdown(seconds);
      if (seconds <= 0) {
        timer.cancel();
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    ref.read(sosProvider.notifier).cancelCountdown();
  }

  void _cancelSOS() {
    HapticFeedback.mediumImpact();
    ref.read(sosProvider.notifier).cancelSOS();
  }

  @override
  Widget build(BuildContext context) {
    final sos = ref.watch(sosProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: sos.isActive
          ? (isDark
              ? AppColors.darkBackground
              : const Color(0xFFFFF0F0))
          : (isDark ? AppColors.darkBackground : AppColors.warmCream),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _SOSHeader(isDark: isDark, isActive: sos.isActive),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SOSButtonSection(
                  sos: sos,
                  isDark: isDark,
                  pulse: _pulse,
                  glow: _glow,
                  onPressSOS: sos.isActive
                      ? null
                      : (sos.isCountingDown ? _cancelCountdown : _startCountdown),
                  onCancelSOS: _cancelSOS,
                ),
                const SizedBox(height: AppConstants.spaceXL),
                if (!sos.isActive) ...[
                  _EmergencyTypeSelector(isDark: isDark),
                  const SizedBox(height: AppConstants.spaceXL),
                ],
                _LocationCard(isDark: isDark, locationText: sos.locationText),
                const SizedBox(height: AppConstants.spaceXL),
                _EmergencyContactsCard(isDark: isDark),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SOSHeader extends StatelessWidget {
  final bool isDark;
  final bool isActive;
  const _SOSHeader({required this.isDark, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppConstants.horizontalPadding,
        MediaQuery.of(context).padding.top + 16,
        AppConstants.horizontalPadding,
        AppConstants.spaceXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.emergencyRedLight
                      : (isDark ? AppColors.darkCard : AppColors.white),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? AppColors.neuDarkMode.withOpacity(0.7)
                          : AppColors.neuDark.withOpacity(0.3),
                      offset: const Offset(3, 3),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: isDark
                          ? AppColors.neuLightDarkMode.withOpacity(0.3)
                          : AppColors.neuLight,
                      offset: const Offset(-3, -3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: isActive
                      ? AppColors.emergencyRed
                      : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                isActive ? '🚨 SOS Active' : 'Emergency SOS',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: isActive
                      ? AppColors.emergencyRed
                      : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary),
                ),
              ),
              if (isActive) ...[
                const SizedBox(width: 10),
                const PulsingDot(color: AppColors.emergencyRed, size: 10),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isActive
                ? 'Emergency services have been notified'
                : 'Press and hold to send emergency alert',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isActive
                  ? AppColors.emergencyRed
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SOSButtonSection extends StatelessWidget {
  final SOSState sos;
  final bool isDark;
  final Animation<double> pulse;
  final Animation<double> glow;
  final VoidCallback? onPressSOS;
  final VoidCallback onCancelSOS;

  const _SOSButtonSection({
    required this.sos,
    required this.isDark,
    required this.pulse,
    required this.glow,
    required this.onPressSOS,
    required this.onCancelSOS,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Glow rings
          AnimatedBuilder(
            animation: glow,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring
                  if (sos.isActive || sos.isCountingDown)
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.emergencyRed
                              .withOpacity(glow.value * 0.3),
                          width: 2,
                        ),
                      ),
                    ),
                  // Middle ring
                  if (sos.isActive || sos.isCountingDown)
                    Container(
                      width: 185,
                      height: 185,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.emergencyRed
                              .withOpacity(glow.value * 0.5),
                          width: 2,
                        ),
                      ),
                    ),
                  child!,
                ],
              );
            },
            child: AnimatedBuilder(
              animation: pulse,
              builder: (context, child) => Transform.scale(
                scale: (sos.isActive || sos.isCountingDown)
                    ? pulse.value
                    : 1.0,
                child: child,
              ),
              child: _SOSButton(
                sos: sos,
                onPress: onPressSOS ?? () {},
                onCancel: onCancelSOS,
              ),
            ),
          ),
          const SizedBox(height: 28),
          if (sos.isActive)
            AnimatedPrimaryButton(
              label: 'Cancel SOS',
              onTap: onCancelSOS,
              backgroundColor: isDark
                  ? AppColors.darkCard
                  : AppColors.white,
              foregroundColor: AppColors.emergencyRed,
              icon: Icons.cancel_rounded,
            )
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: const Duration(seconds: 2), color: AppColors.emergencyRedLight),
        ],
      ),
    );
  }
}

class _SOSButton extends StatefulWidget {
  final SOSState sos;
  final VoidCallback onPress;
  final VoidCallback onCancel;

  const _SOSButton({
    required this.sos,
    required this.onPress,
    required this.onCancel,
  });

  @override
  State<_SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<_SOSButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.sos.isActive;
    final isCountingDown = widget.sos.isCountingDown;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPress();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isActive || isCountingDown
              ? AppColors.emergencyGradient
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF5A5F), Color(0xFFFF8C94)],
                ),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: AppColors.emergencyRed.withOpacity(
                      isActive ? 0.7 : 0.4,
                    ),
                    offset: const Offset(0, 12),
                    blurRadius: isActive ? 40 : 24,
                    spreadRadius: isActive ? 4 : 0,
                  ),
                  BoxShadow(
                    color: AppColors.emergencyRed.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isCountingDown) ...[
              Text(
                '${widget.sos.countdownSeconds}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
              const Text(
                'tap to cancel',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ] else if (isActive) ...[
              const Icon(Icons.emergency_rounded, color: Colors.white, size: 40),
              const SizedBox(height: 6),
              const Text(
                'SOS ACTIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ] else ...[
              const Icon(Icons.emergency_rounded, color: Colors.white, size: 40),
              const SizedBox(height: 6),
              const Text(
                'SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                ),
              ),
              const Text(
                'Tap to Alert',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmergencyTypeSelector extends ConsumerWidget {
  final bool isDark;
  const _EmergencyTypeSelector({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(sosProvider).selectedType;

    final types = [
      _EmType(EmergencyType.medical, Icons.medical_services_rounded, 'Medical', AppColors.emergencyRed),
      _EmType(EmergencyType.fire, Icons.local_fire_department_rounded, 'Fire', AppColors.warningAmber),
      _EmType(EmergencyType.flood, Icons.water_rounded, 'Flood', AppColors.deepBlue),
      _EmType(EmergencyType.crime, Icons.local_police_rounded, 'Crime', AppColors.deepMint),
      _EmType(EmergencyType.earthquake, Icons.terrain_rounded, 'Quake', AppColors.deepAqua),
      _EmType(EmergencyType.other, Icons.help_rounded, 'Other', AppColors.textSecondary),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Type',
          style: AppTextStyles.headlineMedium.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Select the type of emergency',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: AppConstants.spaceMD),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: types.map((t) {
            final isSelected = selected == t.type;
            return GestureDetector(
              onTap: () => ref.read(sosProvider.notifier).selectType(t.type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? t.color.withOpacity(0.12)
                      : (isDark ? AppColors.darkCard : AppColors.white),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                  border: Border.all(
                    color: isSelected ? t.color : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? AppColors.neuDarkMode.withOpacity(0.7)
                          : AppColors.neuDark.withOpacity(0.3),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(t.icon, color: t.color, size: 26),
                    const SizedBox(height: 6),
                    Text(
                      t.label,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? t.color
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary),
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _EmType {
  final EmergencyType type;
  final IconData icon;
  final String label;
  final Color color;
  const _EmType(this.type, this.icon, this.label, this.color);
}

class _LocationCard extends StatelessWidget {
  final bool isDark;
  final String? locationText;
  const _LocationCard({required this.isDark, this.locationText});

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.lightAqua.withOpacity(isDark ? 0.2 : 1.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.deepAqua,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Location',
                      style: AppTextStyles.bodySmall,
                    ),
                    Text(
                      'Live GPS Tracking',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const PulsingDot(color: AppColors.deepAqua, size: 10),
            ],
          ),
          const SizedBox(height: AppConstants.spaceMD),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCardElevated
                  : AppColors.lightAqua.withOpacity(0.3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.my_location_rounded,
                  color: AppColors.deepAqua,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    locationText ?? 'Fetching location...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontFamily: 'monospace',
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '📍 New Delhi, India · Accurate to 5m',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _EmergencyContactsCard extends StatelessWidget {
  final bool isDark;
  const _EmergencyContactsCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final contacts = [
      _Contact('Mom', '📱', '+91 98765 43210', AppColors.deepMint),
      _Contact('Dad', '📱', '+91 91234 56789', AppColors.deepBlue),
      _Contact('Dr. Sharma', '🏥', '+91 88888 12345', AppColors.emergencyRed),
    ];

    return NeumorphicCard(
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Emergency Contacts',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.contacts_rounded,
                color: AppColors.deepMint,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spaceMD),
          ...contacts.map((c) => _ContactTile(contact: c, isDark: isDark)),
        ],
      ),
    );
  }
}

class _Contact {
  final String name;
  final String emoji;
  final String phone;
  final Color color;
  const _Contact(this.name, this.emoji, this.phone, this.color);
}

class _ContactTile extends StatelessWidget {
  final _Contact contact;
  final bool isDark;
  const _ContactTile({required this.contact, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: contact.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(contact.emoji, style: const TextStyle(fontSize: 20)),
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
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
                Text(contact.phone, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          AnimatedIconButton(
            icon: Icons.call_rounded,
            onTap: () {},
            backgroundColor: contact.color.withOpacity(0.12),
            iconColor: contact.color,
            size: 38,
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}
