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
            expandedHeight: 150.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Keutamaan Sholawat',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.green.shade900, Colors.green.shade600],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_stories,
                    size: 80,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildVerseSection(),
                const SizedBox(height: 24),
                _buildVirtueCard(
                  context,
                  'Mendapat Balasan 10 Kali Lipat',
                  'Barangsiapa yang bershalawat kepadaku sekali, maka Allah akan bershalawat kepadanya sepuluh kali.',
                  'HR. Muslim',
                  Icons.star,
                ),
                _buildVirtueCard(
                  context,
                  'Syafa\'at di Hari Kiamat',
                  'Orang yang paling berhak mendapatkan syafa’atku di hari kiamat adalah orang yang paling banyak bershalawat kepadaku.',
                  'HR. Tirmidzi',
                  Icons.favorite,
                ),
                _buildVirtueCard(
                  context,
                  'Doa Menjadi Mustajab',
                  'Doa itu terhenti di antara langit dan bumi, tidak akan naik hingga pembacanya bersholawat kepada Nabi SAW.',
                  'HR. Tirmidzi',
                  Icons.auto_awesome,
                ),
                _buildVirtueCard(
                  context,
                  'Penghapus Dosa & Derajat Naik',
                  'Allah akan menuliskan baginya sepuluh kebaikan, menghapuskan sepuluh keburukan, dan mengangkat baginya sepuluh derajat.',
                  'HR. Ahmad',
                  Icons.trending_up,
                ),
                const SizedBox(height: 40),
              ]),
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
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
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
          const SizedBox(height: 16),
          Text(
            '"Sesungguhnya Allah dan malaikat-malaikat-Nya bershalawat untuk Nabi. Wahai orang-orang yang beriman, bershalawatlah kalian untuk Nabi dan ucapkanlah salam penghormatan kepadanya."',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.green.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '(QS. Al-Ahzab: 56)',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVirtueCard(
      BuildContext context, String title, String desc, String source, IconData icon) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
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
                  const SizedBox(height: 8),
                  Text(
                    desc,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    source,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
