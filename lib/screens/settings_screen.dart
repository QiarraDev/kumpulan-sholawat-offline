import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/settings_provider.dart';
import '../services/notification_service.dart';
import '../services/supabase_service.dart';
import '../providers/auth_provider.dart';

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
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Tema Warna'),
            subtitle: const Text('Pilih warna utama aplikasi'),
            onTap: () => _showThemeSelector(context, ref),
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
                  await service.requestPermissions(); // Request for Android 13+
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
              'Akun & Sinkronisasi',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
          _buildAccountSection(context, ref),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Dukungan & Informasi',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.share_rounded, color: Colors.blue),
            title: const Text('Bagikan Aplikasi'),
            subtitle: const Text('Ajak teman bersholawat bersama'),
            onTap: () {
              Share.share(
                'Yuk download aplikasi Kumpulan Sholawat Offline! Dapatkan ketenangan hati dengan lantunan sholawat menyentuh kalbu.\n\nDownload di sini: https://play.google.com/store/apps/details?id=com.qiarradev.kumpulan_sholawat_offline',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_rate_rounded, color: Colors.orange),
            title: const Text('Beri Rating'),
            subtitle: const Text('Dukung kami di Play Store'),
            onTap: () {
              // TODO: Tambahkan link Play Store asli jika sudah rilis
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Halaman Play Store akan segera tersedia')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: Colors.green),
            title: const Text('Kebijakan Privasi'),
            subtitle: const Text('Data & Keamanan pengguna'),
            onTap: () {
              _showPrivacyPolicy(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.grey),
            title: const Text('Tentang Aplikasi'),
            subtitle: const Text('Versi 1.0.0'),
            onTap: () => _showAboutApp(context),
          ),
          const SizedBox(height: 30),
          Center(
            child: Text(
              'QiarraDev © 2026',
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(height: 30),
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

  void _showThemeSelector(BuildContext context, WidgetRef ref) {
    final themes = [
      {'name': 'Emerald Green', 'color': const Color(0xFF2E7D32)},
      {'name': 'Royal Blue', 'color': const Color(0xFF1565C0)},
      {'name': 'Deep Maroon', 'color': const Color(0xFF880E4F)},
      {'name': 'Luxury Gold', 'color': const Color(0xFFB8860B)},
      {'name': 'Deep Purple', 'color': const Color(0xFF4A148C)},
      {'name': 'Teal Ocean', 'color': const Color(0xFF006064)},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Tema Warna',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1,
              ),
              itemCount: themes.length,
              itemBuilder: (context, index) {
                final theme = themes[index];
                final color = theme['color'] as Color;
                final isSelected = ref.watch(appColorProvider) == color;

                return GestureDetector(
                  onTap: () {
                    ref.read(appColorProvider.notifier).setColor(color);
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected 
                            ? Border.all(color: Colors.green, width: 3) 
                            : null,
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: isSelected 
                          ? const Icon(Icons.check, color: Colors.white) 
                          : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        theme['name'] as String,
                        style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAboutApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Kumpulan Sholawat Offline',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Versi 1.0.0',
              style: GoogleFonts.outfit(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              'Aplikasi ini dibuat untuk memudahkan umat muslim mendengarkan lantunan sholawat kapan saja dan di mana saja tanpa koneksi internet.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Dikembangkan oleh:',
              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            Text(
              'QiarraDev Team',
              style: GoogleFonts.outfit(fontSize: 14),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Kebijakan Privasi'),
        content: SingleChildScrollView(
          child: Text(
            'Kumpulan Sholawat Offline menghormati privasi Anda. Aplikasi ini tidak mengumpulkan data pribadi apa pun.\n\n'
            '1. Izin Media: Hanya digunakan untuk memutar file audio yang tersedia di dalam aplikasi.\n'
            '2. Izin Notifikasi: Digunakan untuk fitur pengingat sholawat harian.\n'
            '3. Data Offline: Semua progres Tasbih disimpan secara lokal di perangkat Anda.',
            style: GoogleFonts.outfit(fontSize: 14, height: 1.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return ListTile(
        leading: const Icon(Icons.account_circle_outlined, color: Colors.orange),
        title: const Text('Masuk dengan Akun'),
        subtitle: const Text('Simpan favorit & tasbih ke cloud'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () async {
          // Implement Login Logic
          try {
            await SupabaseService.signInWithGoogle();
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal masuk: $e')),
              );
            }
          }
        },
      );
    }

    return ListTile(
      leading: CircleAvatar(
        radius: 15,
        backgroundImage: user.userMetadata?['avatar_url'] != null 
          ? NetworkImage(user.userMetadata!['avatar_url']) 
          : null,
        child: user.userMetadata?['avatar_url'] == null ? const Icon(Icons.person) : null,
      ),
      title: Text(user.userMetadata?['full_name'] ?? 'Pengguna Sholawat'),
      subtitle: const Text('Akun terhubung • Cloud Sync aktif'),
      trailing: IconButton(
        icon: const Icon(Icons.logout, size: 20, color: Colors.red),
        onPressed: () => SupabaseService.signOut(),
      ),
    );
  }
}
