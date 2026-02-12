import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'screens/home_screen.dart';
import 'providers/sholawat_provider.dart';
import 'providers/settings_provider.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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

    return MaterialApp(
      title: 'Kumpulan Sholawat Offline',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF004D40),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.dark,
          surface: const Color(0xFF001A11),
          background: const Color(0xFF001A11),
          primary: const Color(0xFF43A047),
          secondary: const Color(0xFF81C784),
        ),
        scaffoldBackgroundColor: const Color(0xFF00120B),
      ),
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}
