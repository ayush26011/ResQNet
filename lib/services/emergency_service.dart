/// Emergency service stub — will integrate with SMS/phone APIs in Phase 2.
library;

class EmergencyService {
  /// Sends an SOS alert with the given location and emergency type.
  /// Phase 2: Implement with url_launcher to dial 112/911, and
  /// telephony plugin to send SMS to emergency contacts.
  Future<bool> sendSOS({
    required String location,
    required String emergencyType,
    required List<String> contactNumbers,
  }) async {
    // Stub: simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Cancels an active SOS alert.
  Future<void> cancelSOS() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
