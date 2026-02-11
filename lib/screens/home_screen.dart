import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sholawat_provider.dart';
import '../providers/audio_provider.dart';
import '../models/sholawat.dart';
import 'detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sholawatAsync = ref.watch(sholawatListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kumpulan Sholawat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: sholawatAsync.when(
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final sholawat = list[index];
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.music_note),
              ),
              title: Text(sholawat.title),
              subtitle: Text(sholawat.category),
              trailing: IconButton(
                icon: Icon(
                  ref.watch(favoritesProvider).contains(sholawat.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(sholawat.id);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(sholawat: sholawat),
                  ),
                );
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }
}

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSholawat = ref.watch(currentSholawatProvider);
    if (currentSholawat == null) return const SizedBox.shrink();

    final isPlaying = ref.watch(isPlayingProvider).value ?? false;

    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: ListTile(
        title: Text(currentSholawat.title),
        subtitle: const Text('Playing...'),
        trailing: IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            if (isPlaying) {
              ref.read(audioPlayerServiceProvider).pause();
            } else {
              ref.read(audioPlayerServiceProvider).resume();
            }
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(sholawat: currentSholawat),
            ),
          );
        },
      ),
    );
  }
}
