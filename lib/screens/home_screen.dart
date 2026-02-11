import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/sholawat_provider.dart';
import '../providers/audio_provider.dart';
import '../models/sholawat.dart';
import 'detail_screen.dart';
import 'settings_screen.dart';
import 'fadhilah_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _searchQuery = '';
  bool _showOnlyFavorites = false;
  String _selectedCategory = 'Semua';

  final List<String> _categories = ['Semua', 'Populer', 'Klasik'];

  @override
  Widget build(BuildContext context) {
    final sholawatAsync = ref.watch(sholawatListProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      body: Stack(
        children: [
          sholawatAsync.when(
            data: (list) {
              final filteredList = list.where((s) {
                final matchesSearch = s.title.toLowerCase().contains(_searchQuery.toLowerCase());
                final matchesFavorite = !_showOnlyFavorites || favorites.contains(s.id);
                final matchesCategory = _selectedCategory == 'Semua' || 
                                       s.category.toLowerCase() == _selectedCategory.toLowerCase();
                return matchesSearch && matchesFavorite && matchesCategory;
              }).toList();

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 180.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Sholawat Offline',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.green.shade900, Colors.green.shade400],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -20,
                              top: -20,
                              child: Icon(Icons.music_note, 
                                size: 150, 
                                color: Colors.white.withOpacity(0.1)
                              ),
                            ),
                          ],
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
                        icon: const Icon(Icons.info_outline),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FadhilahScreen()),
                          );
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            onChanged: (value) => setState(() => _searchQuery = value),
                            decoration: InputDecoration(
                              hintText: 'Cari Sholawat...',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _categories.map((cat) {
                                final isSelected = _selectedCategory == cat;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: FilterChip(
                                    selected: isSelected,
                                    label: Text(cat),
                                    onSelected: (val) {
                                      setState(() => _selectedCategory = cat);
                                    },
                                    selectedColor: Colors.green.shade700,
                                    checkmarkColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: isSelected ? Colors.white : null,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (filteredList.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: Text('Tidak ada sholawat ditemukan')),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final sholawat = filteredList[index];
                          final isFav = favorites.contains(sholawat.id);

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 0,
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/sholawat_cover.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      sholawat.arabic.split(' ').first,
                                      style: GoogleFonts.amiri(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                sholawat.title,
                                style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                sholawat.category,
                                style: GoogleFonts.outfit(fontSize: 12),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? Colors.red : Colors.grey,
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
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
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
      margin: const EdgeInsets.all(12),
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.green.shade700,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.music_note, color: Colors.white),
        ),
        title: Text(
          currentSholawat.title,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          currentSholawat.category,
          style: GoogleFonts.outfit(fontSize: 11),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
              iconSize: 30,
              color: Colors.green.shade700,
              onPressed: () {
                if (isPlaying) {
                  ref.read(audioPlayerServiceProvider).pause();
                } else {
                  ref.read(audioPlayerServiceProvider).resume();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                ref.read(audioPlayerServiceProvider).stop();
                ref.read(currentSholawatProvider.notifier).state = null;
              },
            ),
          ],
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
