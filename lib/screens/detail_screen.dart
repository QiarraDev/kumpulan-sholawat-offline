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
  void initState() {
    super.initState();
    Future.microtask(() {
      final current = ref.read(currentSholawatProvider);
      if (current?.id != widget.sholawat.id) {
        ref.read(currentSholawatProvider.notifier).state = widget.sholawat;
        ref.read(audioPlayerServiceProvider).playSholawat(widget.sholawat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = ref.watch(isPlayingProvider).value ?? false;
    final position = ref.watch(positionProvider).value ?? Duration.zero;
    final duration = ref.watch(durationProvider).value ?? Duration.zero;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sholawat.title),
        actions: [
          IconButton(
            icon: Icon(
              ref.watch(favoritesProvider).contains(widget.sholawat.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggleFavorite(widget.sholawat.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              widget.sholawat.arabic,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular', // TODO: Add Arabic font
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.sholawat.latin,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.sholawat.translation,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 40),
            Slider(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(position)),
                Text(_formatDuration(duration)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 48,
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {
                    // TODO: Previous logic
                  },
                ),
                IconButton(
                  iconSize: 64,
                  icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                  onPressed: () {
                    if (isPlaying) {
                      ref.read(audioPlayerServiceProvider).pause();
                    } else {
                      ref.read(audioPlayerServiceProvider).resume();
                    }
                  },
                ),
                IconButton(
                  iconSize: 48,
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {
                    // TODO: Next logic
                  },
                ),
              ],
            ),
          ],
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
