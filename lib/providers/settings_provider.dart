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

// FONT SIZE PROVIDER
final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  final service = ref.watch(localDataServiceProvider);
  return FontSizeNotifier(service);
});

class FontSizeNotifier extends StateNotifier<double> {
  final LocalDataService _service;
  FontSizeNotifier(this._service) : super(24.0) {
    state = _service.settingsBox.get('font_size', defaultValue: 24.0);
  }

  Future<void> setFontSize(double size) async {
    await _service.settingsBox.put('font_size', size);
    state = size;
  }
}

// FONT FAMILY PROVIDER (Arabic)
final fontFamilyProvider = StateNotifierProvider<FontFamilyNotifier, String>((ref) {
  final service = ref.watch(localDataServiceProvider);
  return FontFamilyNotifier(service);
});

class FontFamilyNotifier extends StateNotifier<String> {
  final LocalDataService _service;
  FontFamilyNotifier(this._service) : super('Amiri') {
    state = _service.settingsBox.get('font_family', defaultValue: 'Amiri');
  }

  Future<void> setFontFamily(String family) async {
    await _service.settingsBox.put('font_family', family);
    state = family;
  }
}

final sleepTimerSettingProvider = StateProvider<int?>((ref) => null);

// APP COLOR THEME PROVIDER
final appColorProvider = StateNotifierProvider<AppColorNotifier, Color>((ref) {
  final service = ref.watch(localDataServiceProvider);
  return AppColorNotifier(service);
});

class AppColorNotifier extends StateNotifier<Color> {
  final LocalDataService _service;
  AppColorNotifier(this._service) : super(const Color(0xFF2E7D32)) {
    final int? colorValue = _service.settingsBox.get('app_color');
    if (colorValue != null) {
      state = Color(colorValue);
    }
  }

  Future<void> setColor(Color color) async {
    await _service.settingsBox.put('app_color', color.value);
    state = color;
  }
}

// REMINDER PROVIDER
final reminderProvider = StateNotifierProvider<ReminderNotifier, bool>((ref) {
  final service = ref.watch(localDataServiceProvider);
  return ReminderNotifier(service);
});

class ReminderNotifier extends StateNotifier<bool> {
  final LocalDataService _service;
  ReminderNotifier(this._service) : super(false) {
    state = _service.settingsBox.get('reminders_enabled', defaultValue: false);
  }

  Future<void> toggleReminders() async {
    final newState = !state;
    await _service.settingsBox.put('reminders_enabled', newState);
    state = newState;
  }
}
