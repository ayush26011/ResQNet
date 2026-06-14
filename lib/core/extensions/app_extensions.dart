/// Core utilities — string helpers, date formatters, validators.
library;

extension StringExtensions on String {
  /// Capitalizes the first letter of a string.
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Returns true if string is a valid phone number (basic check).
  bool get isValidPhone => RegExp(r'^\+?[0-9]{7,15}$').hasMatch(trim());
}

extension IterableExtensions<T> on Iterable<T> {
  /// Returns null if empty, otherwise the first element.
  T? get firstOrNull => isEmpty ? null : first;
}
