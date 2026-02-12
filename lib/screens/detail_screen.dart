import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/sholawat.dart';
import '../providers/audio_provider.dart';
import '../providers/settings_provider.dart' show fontSizeProvider, fontFamilyProvider, reminderProvider, sleepTimerSettingProvider;
import '../providers/sholawat_provider.dart';
import 'doa_sebelum_screen.dart';
import '../services/download_service.dart';
import 'package:share_plus/share_plus.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final Sholawat sholawat;

  const DetailScreen({super.key, required this.sholawat});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAutoScroll = false;
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch current sholawat so UI updates when song changes in playlist
    final currentSholawat = ref.watch(currentSholawatProvider) ?? widget.sholawat;
    final isPlaying = ref.watch(isPlayingProvider).value ?? false;
    final position = ref.watch(positionProvider).value ?? Duration.zero;
    final duration = ref.watch(durationProvider).value ?? Duration.zero;

    // AUTO SCROLL LOGIC
    if (_isAutoScroll && duration.inMilliseconds > 0 && isPlaying) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final maxScroll = _scrollController.position.maxScrollExtent;
          final targetPosition = (position.inMilliseconds / duration.inMilliseconds) * maxScroll;
          _scrollController.animateTo(
            targetPosition,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
          );
        }
      });
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade900,
              Theme.of(context).scaffoldBackgroundColor,
            ],
            stops: const [0.0, 0.5],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Column(
                      children: [
                        Text(
                          'SEDANG DIPUTAR',
                          style: GoogleFonts.outfit(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          currentSholawat.category,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        ref.watch(favoritesProvider).contains(currentSholawat.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        ref.read(favoritesProvider.notifier).toggleFavorite(currentSholawat.id);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/sholawat_cover.png'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentSholawat.arabic,
                                style: GoogleFonts.amiri(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                currentSholawat.title,
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        currentSholawat.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 48),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DoaSebelumScreen()),
                          );
                        },
                        icon: Icon(Icons.auto_stories, color: Theme.of(context).brightness == Brightness.dark ? Colors.green.shade300 : Colors.green),
                        label: Text(
                          'BACA NIAT & ADAB',
                          style: GoogleFonts.outfit(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.green.shade300 : Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.green.shade50,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // ARABIC TEXT
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              currentSholawat.arabic,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.getFont(
                                ref.watch(fontFamilyProvider),
                                fontSize: ref.watch(fontSizeProvider),
                                fontWeight: FontWeight.bold,
                                height: 1.8,
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.green.shade300 
                                    : Colors.green.shade800,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Divider(),
                            ),
                            Text(
                              currentSholawat.latin,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white.withOpacity(0.8) 
                                    : Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              currentSholawat.translation,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white.withOpacity(0.6) 
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              // PLAYER CONTROLS
              Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                        activeTrackColor: Colors.green.shade700,
                        inactiveTrackColor: Colors.green.shade100,
                        thumbColor: Colors.green.shade700,
                      ),
                      child: Slider(
                        value: position.inMilliseconds.toDouble(),
                        max: duration.inMilliseconds.toDouble() > 0
                            ? duration.inMilliseconds.toDouble()
                            : 1,
                        onChanged: (value) {
                          ref.read(audioPlayerServiceProvider).seek(
                                Duration(milliseconds: value.toInt()),
                              );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(position), style: const TextStyle(fontSize: 12)),
                          Text(_formatDuration(duration), style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.auto_stories_outlined,
                            size: 28,
                            color: _isAutoScroll ? Colors.green.shade700 : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isAutoScroll = !_isAutoScroll;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_previous, size: 36),
                          onPressed: () => ref.read(audioPlayerServiceProvider).previous(),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isPlaying) {
                              ref.read(audioPlayerServiceProvider).pause();
                            } else {
                              ref.read(audioPlayerServiceProvider).resume();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, size: 36),
                          onPressed: () => ref.read(audioPlayerServiceProvider).next(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.shuffle, size: 28),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSmallActionButton(
                          icon: Icons.bedtime_outlined,
                          label: 'Timer',
                          onTap: () => _showSleepTimerSheet(context, ref),
                        ),
                        const SizedBox(width: 40),
                        _buildSmallActionButton(
                          icon: Icons.file_download_outlined,
                          label: 'Simpan',
                          onTap: () async {
                            final result = await DownloadService.downloadAudio(
                              currentSholawat.audio,
                              "${currentSholawat.title.replaceAll(' ', '_')}.mp3",
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result ?? "Gagal mengunduh"),
                                  backgroundColor: result?.contains("Saved") == true 
                                      ? Colors.green.shade800 
                                      : Colors.red.shade800,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 40),
                        _buildSmallActionButton(
                          icon: Icons.share_outlined,
                          label: 'Bagikan',
                          onTap: () {
                            final text = """
📖 *${currentSholawat.title}*

${currentSholawat.arabic}

_(${currentSholawat.latin})_

*"${currentSholawat.translation}"*

---
Diambil dari aplikasi *Kumpulan Sholawat Offline*
""";
                            Share.share(text);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // TIMER STATUS
                    Consumer(
                      builder: (context, ref, child) {
                        final sleepTimer = ref.watch(sleepTimerProvider).value;
                        if (sleepTimer == null) return const SizedBox.shrink();
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Berhenti dalam: ${_formatDuration(sleepTimer)}',
                            style: GoogleFonts.outfit(
                              color: Colors.green.shade800,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSleepTimerSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Timer Tidur',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Audio akan berhenti otomatis setelah:',
                style: GoogleFonts.outfit(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _timerOption(context, ref, 'OFF', null),
                  _timerOption(context, ref, '15 Menit', const Duration(minutes: 15)),
                  _timerOption(context, ref, '30 Menit', const Duration(minutes: 30)),
                  _timerOption(context, ref, '60 Menit', const Duration(minutes: 60)),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _timerOption(BuildContext context, WidgetRef ref, String label, Duration? duration) {
    return InkWell(
      onTap: () {
        ref.read(audioPlayerServiceProvider).setSleepTimer(duration);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green.shade100),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitsMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitsMinutes:$twoDigitsSeconds";
  }

  Widget _buildSmallActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.green.shade800, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.green.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
