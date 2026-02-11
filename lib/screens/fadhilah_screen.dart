import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FadhilahScreen extends StatelessWidget {
  const FadhilahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220.0,
            pinned: true,
            backgroundColor: Colors.green.shade900,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Keutamaan Sholawat',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green.shade800, Colors.green.shade900],
                  ),
                ),
                child: Center(
                  child: Opacity(
                    opacity: 0.15,
                    child: Icon(Icons.star_outline, size: 120, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVerseSection(),
                  const SizedBox(height: 30),
                  Text(
                    'Fadhilah Dari Hadits',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildVirtueCard(
                    context,
                    title: 'Balasan 10 Kali Lipat',
                    desc: 'Barangsiapa bershalawat kepadaku sekali, maka Allah akan bershalawat kepadanya sepuluh kali.',
                    source: 'HR. Muslim',
                    icon: Icons.auto_awesome,
                  ),
                  _buildVirtueCard(
                    context,
                    title: 'Syafaat Rasulullah',
                    desc: 'Orang yang paling berhak mendapatkan syafaatku di hari kiamat adalah orang yang paling banyak bershalawat kepadaku.',
                    source: 'HR. Tirmidzi',
                    icon: Icons.favorite,
                  ),
                  _buildVirtueCard(
                    context,
                    title: 'Doa Yang Terkabul',
                    desc: 'Setiap doa itu terhalang (untuk dikabulkan) sampai dibacakan sholawat atas Nabi shallallahu ‘alaihi wa sallam.',
                    source: 'HR. Tirmidzi',
                    icon: Icons.verified,
                  ),
                  _buildVirtueCard(
                    context,
                    title: 'Penghapus Kesedihan',
                    desc: 'Jika engkau melakukan itu (banyak bersholawat), maka kegelisahanmu akan dihilangkan dan dosamu akan diampuni.',
                    source: 'HR. Tirmidzi',
                    icon: Icons.sentiment_very_satisfied,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerseSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        children: [
          Text(
            'إِنَّ اللّٰهَ وَمَلٰٓئِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِيِّۗ يٰٓأَيُّهَا الَّذِيْنَ اٰمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.amiri(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.8,
              color: Colors.green.shade900,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '"Sesungguhnya Allah dan malaikat-malaikat-Nya bershalawat untuk Nabi. Wahai orang-orang yang beriman, bershalawatlah kalian untuk Nabi dan ucapkanlah salam penghormatan kepadanya."',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '(QS. Al-Ahzab: 56)',
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVirtueCard(BuildContext context, {required String title, required String desc, required String source, required IconData icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.green.shade700, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  source,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
