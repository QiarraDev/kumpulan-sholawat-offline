import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/splash_screen.dart';
import 'providers/sholawat_provider.dart';
import 'providers/settings_provider.dart';
import 'services/notification_service.dart';
import 'services/ad_service.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Supabase
  await SupabaseService.init();

  await AdService.init();
  await initializeDateFormatting('id_ID', null);
  
  await NotificationService().init();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.qiarradev.kumpulan_sholawat_offline.channel.audio',
    androidNotificationChannelName: 'Audio Playback',
    androidNotificationOngoing: true,
  );

  final container = ProviderContainer();
  final dataService = container.read(localDataServiceProvider);
  await dataService.init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final primaryColor = ref.watch(appColorProvider);

    return MaterialApp(
      title: 'Kumpulan Sholawat Offline',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
          primary: primaryColor,
          secondary: Color.lerp(primaryColor, Colors.black, 0.2),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          surface: const Color(0xFF001A11),
          background: const Color(0xFF001A11),
          primary: Color.lerp(primaryColor, Colors.white, 0.2)!,
          secondary: Color.lerp(primaryColor, Colors.white, 0.5)!,
        ),
        scaffoldBackgroundColor: const Color(0xFF00120B),
      ),
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
