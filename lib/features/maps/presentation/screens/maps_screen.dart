import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/neumorphic_card.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../../services/location_service.dart';

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
  LatLng? _currentLocation;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: 1.0,
    );
    _panelAnim = CurvedAnimation(parent: _panelController, curve: Curves.easeInOut);
    _initLocation();
  }

  void _initLocation() async {
    final service = LocationService();
    await service.requestPermission();
    final pos = await service.getCurrentPosition() ?? await service.getLastKnownPosition();
    if (pos != null) {
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(pos.latitude, pos.longitude);
        });
      }
    }
  }

  void _moveToCurrentLocation() async {
    final service = LocationService();
    final pos = await service.getCurrentPosition() ?? await service.getLastKnownPosition();
    if (pos != null) {
      final latLng = LatLng(pos.latitude, pos.longitude);
      if (mounted) {
        setState(() {
          _currentLocation = latLng;
        });
      }
      _mapController.move(latLng, 14.0);
    }
  }

  @override
  void dispose() {
    _panelController.dispose();
    _mapController.dispose();
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
                    child: _buildRealMap(isDark),
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
                  onTap: _moveToCurrentLocation,
                  backgroundColor: AppColors.deepMint,
                  iconColor: Colors.white,
                  tooltip: 'My Location',
                ),
                const SizedBox(height: 12),
                AnimatedIconButton(
                  icon: Icons.zoom_in_rounded,
                  onTap: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 1.0,
                    );
                  },
                  tooltip: 'Zoom In',
                ),
                const SizedBox(height: 10),
                AnimatedIconButton(
                  icon: Icons.zoom_out_rounded,
                  onTap: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 1.0,
                    );
                  },
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

  Widget _buildRealMap(bool isDark) {
    final center = _currentLocation ?? const LatLng(LocationService.fallbackLatitude, LocationService.fallbackLongitude);
    final markers = _buildResourceMarkers(center);

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 13.0,
            minZoom: 3.0,
            maxZoom: 18.0,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.powderBlue.withOpacity(0.5),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.resqnet',
              errorTileCallback: (tile, error, stackTrace) {
                // Silently handle tile load errors to prevent crashes and console spam
                // Especially useful for offline-first mode before tiles are cached
              },
            ),
            MarkerLayer(
              markers: [
                if (_currentLocation != null)
                  Marker(
                    point: _currentLocation!,
                    width: 44,
                    height: 44,
                    child: _buildCurrentLocationMarker(),
                  ),
                ...markers,
              ],
            ),
          ],
        ),
        // Center crosshair overlay matching layout placeholder
        Center(
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.deepMint,
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Offline Mode Label
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

  Widget _buildCurrentLocationMarker() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.deepMint.withOpacity(0.2),
      ),
      child: Center(
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.deepMint,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepMint.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkerWidget({required IconData icon, required Color color, required String label}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  List<Marker> _buildResourceMarkers(LatLng center) {
    final allMarkers = [
      _MapMarkerOffset(latOffset: 0.005, lonOffset: -0.005, icon: Icons.local_hospital_rounded, color: AppColors.emergencyRed, label: 'City Hospital', category: 1),
      _MapMarkerOffset(latOffset: 0.003, lonOffset: 0.006, icon: Icons.local_fire_department_rounded, color: AppColors.warningAmber, label: 'Fire Station', category: 4),
      _MapMarkerOffset(latOffset: -0.006, lonOffset: -0.002, icon: Icons.home_rounded, color: AppColors.deepBlue, label: 'Safe Shelter', category: 2),
      _MapMarkerOffset(latOffset: -0.003, lonOffset: 0.004, icon: Icons.local_police_rounded, color: AppColors.deepMint, label: 'Police HQ', category: 3),
    ];

    final filtered = allMarkers.where((m) {
      if (_selectedFilter == 0) return true;
      return m.category == _selectedFilter;
    });

    return filtered.map((m) {
      return Marker(
        point: LatLng(center.latitude + m.latOffset, center.longitude + m.lonOffset),
        width: 60,
        height: 60,
        child: _buildMarkerWidget(
          icon: m.icon,
          color: m.color,
          label: m.label,
        ),
      );
    }).toList();
  }
}

class _MapMarkerOffset {
  final double latOffset;
  final double lonOffset;
  final IconData icon;
  final Color color;
  final String label;
  final int category;
  const _MapMarkerOffset({
    required this.latOffset,
    required this.lonOffset,
    required this.icon,
    required this.color,
    required this.label,
    required this.category,
  });
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

