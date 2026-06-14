import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier(ref);
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier(this.ref) : super(false) {
    _loadTheme();
  }

  final Ref ref;

  void _loadTheme() {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      state = prefs.getBool('isDarkMode') ?? false;
    } catch (_) {
      state = false;
    }
  }

  void toggleTheme() {
    state = !state;
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      prefs.setBool('isDarkMode', state);
    } catch (_) {}
  }
}

final currentTabProvider = StateProvider<int>((ref) => 0);

final userNameProvider = StateProvider<String>((ref) => 'Ayush');
final userStatusProvider = StateProvider<String>((ref) => 'Safe');
