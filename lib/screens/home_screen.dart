import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/sholawat_provider.dart';
import '../providers/audio_provider.dart';
import '../models/sholawat.dart';
import 'detail_screen.dart';
import 'settings_screen.dart';
import 'fadhilah_screen.dart';
import 'doa_sebelum_screen.dart';
import 'tasbih_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _searchQuery = '';
  bool _showOnlyFavorites = false;
  String _selectedCategory = 'Semua';
  List<String>? _filterByHajatTitles;

  final List<String> _categories = ['Semua', 'Populer', 'Klasik'];
  final ScrollController _hajatScrollController = ScrollController();

  @override
  void dispose() {
    _hajatScrollController.dispose();
    super.dispose();
  }

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
                final matchesHajat = _filterByHajatTitles == null || 
                                     _filterByHajatTitles!.contains(s.title);
                return matchesSearch && matchesFavorite && matchesCategory && matchesHajat;
              }).toList();

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 260.0,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.green.shade900,
                    iconTheme: const IconThemeData(color: Colors.white),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: const Color(0xFF003322), // Dark green matching the banner
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/banner_calligraphy.png',
                              fit: BoxFit.contain, // Shows the whole frame/bingkai
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.0, 0.2, 0.8, 1.0],
                                  colors: [
                                    Colors.black.withOpacity(0.4),
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.4),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      _buildAppBarIcon(
                        icon: _showOnlyFavorites ? Icons.favorite : Icons.favorite_border,
                        color: _showOnlyFavorites ? Colors.red : Colors.white,
                        onPressed: () {
                          setState(() {
                            _showOnlyFavorites = !_showOnlyFavorites;
                          });
                        },
                      ),
                      _buildAppBarIcon(
                        icon: Icons.settings,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsScreen()),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDailyQuote(),
                          const SizedBox(height: 20),
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
                                      setState(() {
                                        _selectedCategory = cat;
                                        _filterByHajatTitles = null;
                                      });
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TasbihScreen()),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.green.shade900, Colors.green.shade700],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tasbih Digital',
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Hitung dzikir & sholawat Anda',
                                          style: GoogleFonts.outfit(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  title: 'Doa & Adab',
                                  subtitle: 'Niat sholawat',
                                  icon: Icons.auto_stories,
                                  colors: [Colors.green.shade800, Colors.green.shade600],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const DoaSebelumScreen()),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoCard(
                                  title: 'Keutamaan',
                                  subtitle: 'Fadhilah',
                                  icon: Icons.star_rounded,
                                  colors: [Colors.green.shade800, Colors.green.shade600],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const FadhilahScreen()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Berdasarkan Hajat',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_rounded, color: Colors.green.shade600, size: 24),
                                onPressed: () {
                                  _hajatScrollController.animateTo(
                                    _hajatScrollController.offset + 200,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            controller: _hajatScrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildCollectionCard(
                                  title: 'Penenang Hati',
                                  icon: Icons.spa_rounded,
                                  color: Colors.teal.shade600,
                                  onTap: () => _filterByHajat(['Sholawat Tibbil Qulub', 'Sholawat Nariyah', 'Roqqota Aina (Assalamu Alayka)']),
                                ),
                                _buildCollectionCard(
                                  title: 'Pelancar Rezeki',
                                  icon: Icons.account_balance_wallet_rounded,
                                  color: Colors.blue.shade600,
                                  onTap: () => _filterByHajat(['Sholawat Jibril']),
                                ),
                                _buildCollectionCard(
                                  title: 'Keselamatan',
                                  icon: Icons.shield_rounded,
                                  color: Colors.red.shade600,
                                  onTap: () => _filterByHajat(['Sholawat Munjiyat']),
                                ),
                                _buildCollectionCard(
                                  title: 'Hajat Mendesak',
                                  icon: Icons.bolt_rounded,
                                  color: Colors.purple.shade600,
                                  onTap: () => _filterByHajat(['Sholawat Badar', 'Sholawat Ibrahimiyah']),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade300, size: 14),
                                const SizedBox(width: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daftar Sholawat',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          Text(
                            '${filteredList.length} Item',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.grey.shade500,
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

  Widget _buildAppBarIcon({required IconData icon, Color? color, required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: color ?? Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCollectionCard({required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filterByHajat(List<String> titles) {
    setState(() {
      _selectedCategory = 'Semua';
      _searchQuery = '';
      _filterByHajatTitles = titles;
    });
    
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Koleksi sholawat sudah difilter.'),
        backgroundColor: Colors.green.shade800,
        action: SnackBarAction(
          label: 'RESET', 
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _filterByHajatTitles = null;
            });
          }
        ),
      ),
    );
  }

  Widget _buildDailyQuote() {
    final quotes = [
      "Barangsiapa bersholawat kepadaku satu kali, niscaya Allah bersholawat kepadanya sepuluh kali. (HR. Muslim)",
      "Orang yang paling pelit adalah orang yang ketika namaku disebut di sisinya, ia tidak bersholawat kepadaku. (HR. Tirmidzi)",
      "Hiasilah majelis-majelis kalian dengan bersholawat kepadaku. (HR. Ad-Dailami)",
      "Perbanyaklah sholawat kepadaku pada hari Jumat. (HR. Al-Baihaqi)",
      "Doa itu terhalang hingga dibacakan sholawat untuk Nabi SAW. (HR. Thabrani)",
    ];
    // Pick quote based on date to keep it consistent for the day
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final quote = quotes[dayOfYear % quotes.length];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.format_quote_rounded, color: Colors.green.shade700, size: 28),
              const SizedBox(width: 8),
              Text(
                'Quote Hari Ini',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            quote,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.green.shade900,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                color: Colors.white.withOpacity(0.9),
                fontSize: 11,
              ),
            ),
          ],
        ),
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
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 75,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Theme.of(context).cardColor,
            Colors.green.shade50.withOpacity(0.5),
          ],
        ),
      ),
      child: Center(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade600, Colors.green.shade800],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.music_note_rounded, color: Colors.white),
          ),
          title: Text(
            currentSholawat.title,
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            currentSholawat.category,
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.green.shade700),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded),
                iconSize: 42,
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
                icon: const Icon(Icons.close_rounded, size: 20),
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
      ),
    );
  }
}
