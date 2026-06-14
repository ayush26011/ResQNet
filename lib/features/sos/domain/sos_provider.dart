import 'package:flutter_riverpod/flutter_riverpod.dart';

enum EmergencyType { medical, fire, flood, crime, earthquake, other }

class SOSState {
  final bool isActive;
  final EmergencyType? selectedType;
  final String? locationText;
  final bool isCountingDown;
  final int countdownSeconds;

  const SOSState({
    this.isActive = false,
    this.selectedType,
    this.locationText = '37.7749° N, 122.4194° W',
    this.isCountingDown = false,
    this.countdownSeconds = 5,
  });

  SOSState copyWith({
    bool? isActive,
    EmergencyType? selectedType,
    String? locationText,
    bool? isCountingDown,
    int? countdownSeconds,
  }) {
    return SOSState(
      isActive: isActive ?? this.isActive,
      selectedType: selectedType ?? this.selectedType,
      locationText: locationText ?? this.locationText,
      isCountingDown: isCountingDown ?? this.isCountingDown,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
    );
  }
}

class SOSNotifier extends StateNotifier<SOSState> {
  SOSNotifier() : super(const SOSState());

  void selectType(EmergencyType type) {
    state = state.copyWith(selectedType: type);
  }

  void activateSOS() {
    state = state.copyWith(isActive: true, isCountingDown: false);
  }

  void cancelSOS() {
    state = state.copyWith(isActive: false, isCountingDown: false);
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
