import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sholawat_provider.dart';
import '../providers/audio_provider.dart';
import '../models/sholawat.dart';
import 'detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _searchQuery = '';
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final sholawatAsync = ref.watch(sholawatListProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Sholawat Offline'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.green.shade700, Colors.green.shade400],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_showOnlyFavorites ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  setState(() {
                    _showOnlyFavorites = !_showOnlyFavorites;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBar(
                hintText: 'Cari sholawat...',
                leading: const Icon(Icons.search),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),
          sholawatAsync.when(
            data: (list) {
              final filteredList = list.where((item) {
                final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase());
                final matchesFavorite = !_showOnlyFavorites || favorites.contains(item.id);
                return matchesSearch && matchesFavorite;
              }).toList();

              if (filteredList.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('Tidak ada sholawat ditemukan')),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final sholawat = filteredList[index];
                    final isFav = favorites.contains(sholawat.id);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.music_note, color: Colors.green.shade700),
                        ),
                        title: Text(
                          sholawat.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(sholawat.category),
                        trailing: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            ref.read(favoritesProvider.notifier).toggleFavorite(sholawat.id);
                          },
                        ),
                        onTap: () {
                          ref.read(audioPlayerServiceProvider).setPlaylist(filteredList, index);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(sholawat: sholawat),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: filteredList.length,
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $err')),
            ),
          ),
        ],
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
