import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/sholawat_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/audio_provider.dart';
import '../models/sholawat.dart';
import 'detail_screen.dart';
import 'settings_screen.dart';
import 'fadhilah_screen.dart';
import 'doa_sebelum_screen.dart';
import 'tasbih_screen.dart';
import '../services/download_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showOnlyFavorites = false;
  String _selectedCategory = 'Semua';
  List<String>? _filterByHajatTitles;
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
                final isFavorited = favorites.contains(s.id);
                final matchesFavorite = _selectedCategory == 'Favorit' ? isFavorited : true;
                final matchesCategory = (_selectedCategory == 'Semua' || _selectedCategory == 'Favorit') || 
                                       s.category.toLowerCase() == _selectedCategory.toLowerCase();
                final matchesHajat = _filterByHajatTitles == null || 
                                     _filterByHajatTitles!.contains(s.title);
                final matchesSearch = true; // Search bar removed
                return matchesFavorite && matchesCategory && matchesHajat && matchesSearch;
              }).toList();

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 280.0,
                    floating: false,
                    pinned: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    iconTheme: const IconThemeData(color: Colors.white),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background: Blurred to fill everything
                          Image.asset(
                            'assets/images/banner_calligraphy.png',
                            fit: BoxFit.cover,
                          ),
                          // Dark overlay for readability
                          Container(
                            color: Colors.black.withOpacity(0.3),
                          ),
                          // Blur effect
                          ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ),
                          // Foreground: Sharp image with contained frame
                          Center(
                            child: Image.asset(
                              'assets/images/banner_calligraphy.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDailyQuote(),
                          const SizedBox(height: 16),
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
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey.shade800,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: Icon(Icons.arrow_back_rounded, color: Colors.green.shade600, size: 24),
                                    onPressed: () {
                                      final newOffset = _hajatScrollController.offset - 200;
                                      _hajatScrollController.animateTo(
                                        newOffset < 0 ? 0 : newOffset,
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: Icon(Icons.arrow_forward_rounded, color: Colors.green.shade600, size: 24),
                                    onPressed: () {
                                      final maxScroll = _hajatScrollController.position.maxScrollExtent;
                                      final newOffset = _hajatScrollController.offset + 200;
                                      _hajatScrollController.animateTo(
                                        newOffset > maxScroll ? maxScroll : newOffset,
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                ],
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
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey.shade800,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              if (filteredList.isNotEmpty) {
                                ref.read(audioPlayerServiceProvider).setPlaylist(filteredList, 0);
                                ref.read(currentSholawatProvider.notifier).state = filteredList[0];
                              }
                            },
                            icon: const Icon(Icons.play_circle_fill, size: 20),
                            label: Text(
                              'Putar Semua',
                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).brightness == Brightness.dark 
                                      ? Colors.white 
                                      : Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                sholawat.category,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Theme.of(context).brightness == Brightness.dark 
                                      ? Colors.green.shade300 
                                      : Colors.green.shade700,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FutureBuilder<bool>(
                                    future: DownloadService.isDownloaded(sholawat.audio.split('/').last),
                                    builder: (context, snapshot) {
                                      final isDownloaded = snapshot.data ?? false;
                                      return Icon(
                                        isDownloaded ? Icons.check_circle : Icons.cloud_download_outlined,
                                        size: 20,
                                        color: isDownloaded ? Colors.green : Colors.grey,
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    icon: Icon(
                                      isFav ? Icons.favorite : Icons.favorite_border,
                                      color: isFav ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () {
                                      ref.read(favoritesProvider.notifier).toggleFavorite(sholawat.id);
                                    },
                                  ),
                                ],
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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.green.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.green.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.format_quote_rounded, color: isDark ? Colors.green.shade400 : Colors.green.shade700, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'Quote Hari Ini',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.green.shade300 : Colors.green.shade800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            quote,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white.withOpacity(0.9) : Colors.green.shade900,
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
