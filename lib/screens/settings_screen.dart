import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final sleepTimer = ref.watch(sleepTimerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tampilan',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Mode Malam'),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (_) {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Audio',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Sleep Timer'),
            subtitle: Text(sleepTimer == null ? 'Off' : '$sleepTimer menit'),
            onTap: () => _showSleepTimerDialog(context, ref),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Lainnya',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang Aplikasi'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Sholawat Offline',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.music_note, color: Colors.green, size: 48),
                children: [
                  const Text('Aplikasi Sholawat Offline gratis untuk umat muslim.'),
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Kebijakan Privasi'),
            onTap: () {
              // TODO
            },
          ),
        ],
      ),
    );
  }

  void _showSleepTimerDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Pilih Waktu (menit)'),
        children: [0, 10, 20, 30, 60].map((mins) {
          return SimpleDialogOption(
            onPressed: () {
              ref.read(sleepTimerProvider.notifier).state = mins == 0 ? null : mins;
              Navigator.pop(context);
              if (mins > 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sleep timer diatur ke $mins menit')),
                );
              }
            },
            child: Text(mins == 0 ? 'Matikan' : '$mins menit'),
          );
        }).toList(),
      ),
    );
  }
}
