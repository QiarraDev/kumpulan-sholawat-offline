import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_data_service.dart';
import 'sholawat_provider.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final service = ref.watch(localDataServiceProvider);
  return ThemeModeNotifier(service);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final LocalDataService _service;

  ThemeModeNotifier(this._service) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final bool? isDark = _service.settingsBox.get('dark_mode');
    if (isDark == null) {
      state = ThemeMode.system;
    } else {
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    final bool isCurrentlyDark = state == ThemeMode.dark;
    await _service.settingsBox.put('dark_mode', !isCurrentlyDark);
    state = !isCurrentlyDark ? ThemeMode.dark : ThemeMode.light;
  }
}

final sleepTimerProvider = StateProvider<int?>((ref) => null);
