import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/database_service.dart';
import '../../../services/location_service.dart';
import '../../../shared/models/emergency_log.dart';

enum EmergencyType { medical, fire, flood, crime, earthquake, other }

class SOSState {
  final bool isActive;
  final EmergencyType? selectedType;
  final String? locationText;
  final bool isCountingDown;
  final int countdownSeconds;
  final String? generatedMessage;

  const SOSState({
    this.isActive = false,
    this.selectedType,
    this.locationText = 'Fetching location...',
    this.isCountingDown = false,
    this.countdownSeconds = 5,
    this.generatedMessage,
  });

  SOSState copyWith({
    bool? isActive,
    EmergencyType? selectedType,
    String? locationText,
    bool? isCountingDown,
    int? countdownSeconds,
    String? generatedMessage,
  }) {
    return SOSState(
      isActive: isActive ?? this.isActive,
      selectedType: selectedType ?? this.selectedType,
      locationText: locationText ?? this.locationText,
      isCountingDown: isCountingDown ?? this.isCountingDown,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      generatedMessage: generatedMessage ?? this.generatedMessage,
    );
  }
}

class SOSNotifier extends StateNotifier<SOSState> {
  SOSNotifier() : super(const SOSState());
  final LocationService _locationService = LocationService();

  void selectType(EmergencyType type) {
    state = state.copyWith(selectedType: type);
  }

  Future<void> activateSOS() async {
    // Fetch live coordinates and address string
    final locationStr = await _locationService.getCurrentLocationString();
    
    final position = await _locationService.getCurrentPosition() ??
        await _locationService.getLastKnownPosition();
    
    final double lat = position?.latitude ?? LocationService.fallbackLatitude;
    final double lon = position?.longitude ?? LocationService.fallbackLongitude;

    final typeString = state.selectedType != null
        ? state.selectedType!.name.toUpperCase()
        : 'GENERAL';

    final timestamp = DateTime.now();
    final message = '🚨 EMERGENCY SOS ALERT 🚨\n'
        'Type: $typeString\n'
        'Location: $locationStr\n'
        'Coordinates: ${lat.toStringAsFixed(6)}, ${lon.toStringAsFixed(6)}\n'
        'Time: ${timestamp.toLocal()}\n'
        'Please send help immediately!';

    // Save to local SQLite database
    final log = EmergencyLog(
      emergencyType: typeString,
      latitude: lat,
      longitude: lon,
      message: message,
      timestamp: timestamp,
      status: 'Active',
    );

    try {
      await DatabaseService.instance.insertLog(log);
    } catch (_) {}

    state = state.copyWith(
      isActive: true,
      isCountingDown: false,
      locationText: locationStr,
      generatedMessage: message,
    );
  }

  void cancelSOS() {
    state = state.copyWith(isActive: false, isCountingDown: false, generatedMessage: null);
  }

  void startCountdown() {
    state = state.copyWith(isCountingDown: true, countdownSeconds: 5);
  }

  void updateCountdown(int seconds) {
    state = state.copyWith(countdownSeconds: seconds);
    if (seconds <= 0) activateSOS();
  }

  void cancelCountdown() {
    state = state.copyWith(isCountingDown: false, countdownSeconds: 5);
  }
}

final sosProvider = StateNotifierProvider<SOSNotifier, SOSState>((ref) {
  return SOSNotifier();
});
