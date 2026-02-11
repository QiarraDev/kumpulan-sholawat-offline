import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sholawat.dart';
import '../providers/audio_provider.dart';
import '../providers/sholawat_provider.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final Sholawat sholawat;
  const DetailScreen({super.key, required this.sholawat});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Watch current sholawat so UI updates when song changes in playlist
    final currentSholawat = ref.watch(currentSholawatProvider) ?? widget.sholawat;
    final isPlaying = ref.watch(isPlayingProvider).value ?? false;
    final position = ref.watch(positionProvider).value ?? Duration.zero;
    final duration = ref.watch(durationProvider).value ?? Duration.zero;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade800,
              Theme.of(context).scaffoldBackgroundColor,
            ],
            stops: const [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Sedang Diputar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: const Icon(Icons.music_note, size: 100, color: Colors.white),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        currentSholawat.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentSholawat.category,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // ARABIC TEXT
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              currentSholawat.arabic,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                              ),
                            ),
                            const Divider(height: 32),
                            Text(
                              currentSholawat.latin,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              currentSholawat.translation,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 32,
                          icon: const Icon(Icons.repeat),
                          onPressed: () {
                            // TODO: Add loop mode toggle
                          },
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.skip_previous),
                          onPressed: () {
                            ref.read(audioPlayerServiceProvider).previous();
                          },
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            if (isPlaying) {
                              ref.read(audioPlayerServiceProvider).pause();
                            } else {
                              ref.read(audioPlayerServiceProvider).resume();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.skip_next),
                          onPressed: () {
                            ref.read(audioPlayerServiceProvider).next();
                          },
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          iconSize: 32,
                          icon: const Icon(Icons.shuffle),
                          onPressed: () {
                            // TODO: Add shuffle mode toggle
                          },
                        ),
                      ],
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitsMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitsMinutes:$twoDigitsSeconds";
  }
}
