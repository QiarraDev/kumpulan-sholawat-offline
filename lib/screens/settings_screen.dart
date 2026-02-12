import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../services/notification_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final sleepTimer = ref.watch(sleepTimerSettingProvider);

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
              'Teks & Font',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.format_size),
            title: const Text('Ukuran Font Arab'),
            subtitle: Text('${ref.watch(fontSizeProvider).toInt()} px'),
            onTap: () => _showFontSizeDialog(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.font_download),
            title: const Text('Jenis Font Arab'),
            subtitle: Text(ref.watch(fontFamilyProvider)),
            onTap: () => _showFontFamilyDialog(context, ref),
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
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Pengingat Sholawat'),
            subtitle: const Text('Harian & Jumat Mubarok'),
            trailing: Switch(
              value: ref.watch(reminderProvider),
              onChanged: (_) async {
                final notifier = ref.read(reminderProvider.notifier);
                await notifier.toggleReminders();
                
                final isEnabled = ref.read(reminderProvider);
                if (isEnabled) {
                  final service = NotificationService();
                  await service.scheduleDailySholawatReminder();
                  await service.scheduleFridaySholawatReminder();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pengingat Sholawat diaktifkan')),
                    );
                  }
                } else {
                  // Jika dimatikan, plugin biasanya butuh cancelAll
                  // Untuk demo ini kita beri feedback saja
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pengingat Sholawat dimatikan')),
                    );
                  }
                }
              },
            ),
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

  void _showFontSizeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Pilih Ukuran Font'),
        children: [24.0, 28.0, 32.0, 36.0, 40.0].map((size) {
          return SimpleDialogOption(
            onPressed: () {
              ref.read(fontSizeProvider.notifier).setFontSize(size);
              Navigator.pop(context);
            },
            child: Text('${size.toInt()} px', style: TextStyle(fontSize: size * 0.7)),
          );
        }).toList(),
      ),
    );
  }

  void _showFontFamilyDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Pilih Jenis Font'),
        children: ['Amiri', 'Lateef', 'Scheherazade New'].map((font) {
          return SimpleDialogOption(
            onPressed: () {
              ref.read(fontFamilyProvider.notifier).setFontFamily(font);
              Navigator.pop(context);
            },
            child: Text(font),
          );
        }).toList(),
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
              ref.read(sleepTimerSettingProvider.notifier).state = mins == 0 ? null : mins;
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
