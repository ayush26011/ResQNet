import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/neumorphic_card.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/animated_button.dart';
import '../../core/widgets/shared_widgets.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> with SingleTickerProviderStateMixin {
  bool _showPanel = true;
  int _selectedFilter = 0;
  late AnimationController _panelController;
  late Animation<double> _panelAnim;

  final _filters = ['All', 'Hospitals', 'Shelters', 'Police', 'Fire'];

  @override
  void initState() {
    super.initState();
    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: 1.0,
    );
    _panelAnim = CurvedAnimation(parent: _panelController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _panelController.dispose();
    super.dispose();
  }

  void _togglePanel() {
    setState(() => _showPanel = !_showPanel);
    if (_showPanel) {
      _panelController.forward();
    } else {
      _panelController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.warmCream,
      body: Stack(
        children: [
          // Map Container
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 70),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCard
                        : AppColors.powderBlue.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? AppColors.neuDarkMode.withOpacity(0.8)
                            : AppColors.neuDark.withOpacity(0.3),
                        offset: const Offset(8, 8),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                    child: _MapPlaceholder(isDark: isDark),
                  ),
                ),
              ),
              SizedBox(height: _showPanel ? 280 : 100),
            ],
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _MapsHeader(isDark: isDark),
          ),

          // Floating Controls
          Positioned(
            right: 30,
            top: size.height * 0.35,
            child: Column(
              children: [
                AnimatedIconButton(
                  icon: Icons.my_location_rounded,
                  onTap: () {},
                  backgroundColor: AppColors.deepMint,
                  iconColor: Colors.white,
                  tooltip: 'My Location',
                ),
                const SizedBox(height: 12),
                AnimatedIconButton(
                  icon: Icons.zoom_in_rounded,
                  onTap: () {},
                  tooltip: 'Zoom In',
                ),
                const SizedBox(height: 10),
                AnimatedIconButton(
                  icon: Icons.zoom_out_rounded,
                  onTap: () {},
                  tooltip: 'Zoom Out',
                ),
                const SizedBox(height: 12),
                AnimatedIconButton(
                  icon: Icons.layers_rounded,
                  onTap: () {},
                  tooltip: 'Layers',
                ),
              ],
            ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2, end: 0),
          ),

          // Filter chips
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).padding.top + 70,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ChipSelector(
                options: _filters,
                selectedIndex: _selectedFilter,
                onSelected: (i) => setState(() => _selectedFilter = i),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.1),

          // Bottom Panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: SizeTransition(
              sizeFactor: _panelAnim,
              axisAlignment: -1,
              child: _ShelterPanel(isDark: isDark),
            ),
          ),

          // Panel toggle
          Positioned(
            right: 20,
            bottom: 95,
            child: GestureDetector(
              onTap: _togglePanel,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.mintGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepMint.withOpacity(0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  _showPanel
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_up_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapsHeader extends StatelessWidget {
  final bool isDark;
  const _MapsHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? AppColors.darkBackground : AppColors.warmCream,
      padding: EdgeInsets.fromLTRB(
        AppConstants.horizontalPadding,
        MediaQuery.of(context).padding.top + 16,
        AppConstants.horizontalPadding,
        12,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Offline Maps',
                style: AppTextStyles.displaySmall.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              Text(
                'Safe zones & emergency points',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          const Spacer(),
          AnimatedIconButton(
            icon: Icons.download_rounded,
            onTap: () {},
            tooltip: 'Download offline',
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final bool isDark;
  const _MapPlaceholder({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Grid lines simulating map
        CustomPaint(
          painter: _MapGridPainter(isDark: isDark),
          child: Container(),
        ),
        // Location markers
        ..._buildMarkers(isDark),
        // Center crosshair
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.deepMint,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepMint.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),
              Container(
                width: 2,
                height: 20,
                color: AppColors.deepMint.withOpacity(0.5),
              ),
            ],
          ),
        ),
        // Overlay text
        Positioned(
          top: 20,
          left: 20,
          child: GlassCard(
            borderRadius: 12,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_rounded, size: 14, color: AppColors.deepAqua),
                const SizedBox(width: 6),
                Text(
                  'Offline Mode',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMarkers(bool isDark) {
    final markers = [
      _MapMarker(left: 0.25, top: 0.35, icon: Icons.local_hospital_rounded, color: AppColors.emergencyRed, label: 'Hospital'),
      _MapMarker(left: 0.65, top: 0.25, icon: Icons.local_fire_department_rounded, color: AppColors.warningAmber, label: 'Fire'),
      _MapMarker(left: 0.45, top: 0.65, icon: Icons.shield_rounded, color: AppColors.deepBlue, label: 'Shelter'),
      _MapMarker(left: 0.75, top: 0.55, icon: Icons.local_police_rounded, color: AppColors.deepMint, label: 'Police'),
    ];

    return markers.map((m) => Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) => Positioned(
          left: constraints.maxWidth * m.left,
          top: constraints.maxHeight * m.top,
          child: _buildMarkerWidget(m, isDark),
        ),
      ),
    )).toList();
  }

  Widget _buildMarkerWidget(_MapMarker m, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: m.color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: m.color.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(m.icon, color: Colors.white, size: 18),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            m.label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _MapMarker {
  final double left;
  final double top;
  final IconData icon;
  final Color color;
  final String label;
  const _MapMarker({
    required this.left,
    required this.top,
    required this.icon,
    required this.color,
    required this.label,
  });
}

class _MapGridPainter extends CustomPainter {
  final bool isDark;
  const _MapGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : AppColors.deepBlue).withOpacity(0.06)
      ..strokeWidth = 1;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Road-like lines
    final roadPaint = Paint()
      ..color = (isDark ? Colors.white : AppColors.deepBlue).withOpacity(0.12)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.4), roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), roadPaint);
    canvas.drawLine(
        Offset(0, size.height * 0.7), Offset(size.width * 0.7, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ShelterPanel extends StatelessWidget {
  final bool isDark;
  const _ShelterPanel({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final shelters = [
      _Shelter('Community Hall', 'Shelter', 0.3, Icons.home_rounded, AppColors.deepMint),
      _Shelter('City Hospital', 'Medical', 0.8, Icons.local_hospital_rounded, AppColors.emergencyRed),
      _Shelter('Schools Area', 'Evacuation', 1.4, Icons.school_rounded, AppColors.deepBlue),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Nearby Safe Zones',
              style: AppTextStyles.headlineMedium.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: shelters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) => _ShelterCard(
                shelter: shelters[index],
                isDark: isDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Shelter {
  final String name;
  final String type;
  final double km;
  final IconData icon;
  final Color color;
  const _Shelter(this.name, this.type, this.km, this.icon, this.color);
}

class _ShelterCard extends StatelessWidget {
  final _Shelter shelter;
  final bool isDark;
  const _ShelterCard({required this.shelter, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: AppConstants.radiusLG,
      padding: const EdgeInsets.all(AppConstants.paddingMD),
      onTap: () {},
      child: SizedBox(
        width: 155,
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
                    color: shelter.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(shelter.icon, color: shelter.color, size: 18),
                ),
                const Spacer(),
                Text(
                  '${shelter.km} km',
                  style: AppTextStyles.captionText.copyWith(
                    color: AppColors.deepMint,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shelter.name,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                StatusBadge(
                  label: shelter.type,
                  color: shelter.color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
