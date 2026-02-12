import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoaSebelumScreen extends StatelessWidget {
  const DoaSebelumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: Colors.green.shade900,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Doa & Adab',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green.shade800, Colors.green.shade900],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.menu_book_rounded, size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 60), // Memberikan ruang untuk title di bawah icon
                  ],
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
                  _buildSectionTitle(context, 'Niat Sebelum Bersholawat'),
                  const SizedBox(height: 15),
                  _buildDoaCard(
                    context,
                    arabic: 'اللَّهُمَّ إِنِّي نَوَيْتُ بِهَذِهِ الصَّلَاةِ عَلَى النَّبِيِّ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ امْتِثَالًا لِأمرِكَ وَتَصْدِيقًا لِنَبِيِّكَ وَمَحَبَّةً فِيهِ وَشَوْقًا إِلَيْهِ وَتَعْظِيمًا لِقَدْرِهِ',
                    latin: 'Allahumma inni nawaitu bihadzihis-shalati \'alan-nabiyyi shallallahu \'alaihi wa sallama imtitsalan li amrika wa tashdiqan linabiyyika wa mahabbatan fihi wa syauqan ilaihi wa ta\'dziman liqadrihi.',
                    translation: 'Ya Allah, sesungguhnya aku niat bershalawat kepada Nabi SAW untuk mematuhi perintah-Mu, membenarkan Nabi-Mu, didasari rasa cinta dan rindu kepadanya, serta mengagungkan kedudukannya.',
                  ),
                  const SizedBox(height: 30),
                  _buildSectionTitle(context, 'Doa Setelah Bersholawat'),
                  const SizedBox(height: 15),
                  _buildDoaCard(
                    context,
                    arabic: 'اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلَاةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ',
                    latin: 'Allahumma rabba hadzihid-da\'watit-tammah, was-shalatil-qa\'imah, ati Muhammadan Al-Wasilata wal-Fadhilah, wab\'atshu maqamam-mahmudanil-ladzi wa\'adtah.',
                    translation: 'Ya Allah, Tuhan pemilik seruan yang sempurna ini dan shalat yang tegak, berikanlah kepada Nabi Muhammad Al-Wasilah (derajat di surga) dan Al-Fadhilah (keutamaan), dan tempatkanlah beliau pada kedudukan terpuji (Al-Maqam Al-Mahmud) yang telah Engkau janjikan.',
                  ),
                  const SizedBox(height: 30),
                  _buildSectionTitle(context, 'Adab Bersholawat'),
                  const SizedBox(height: 15),
                  _buildAdabItem(context, '1', 'Menghadirkan Hati', 'Rasakan kehadiran baginda Nabi Muhammad SAW dalam hati saat membaca.'),
                  _buildAdabItem(context, '2', 'Suci dari Hadats', 'Sangat diutamakan dalam keadaan berwudhu.'),
                  _buildAdabItem(context, '3', 'Penuh Tawadhu', 'Membaca dengan penuh rasa rendah hati dan rasa hormat.'),
                  _buildAdabItem(context, '4', 'Khusyuk & Tartil', 'Membaca dengan suara yang santun dan tidak terburu-buru.'),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.green.shade300 : Colors.green.shade900,
      ),
    );
  }

  Widget _buildDoaCard(BuildContext context, {required String arabic, required String latin, required String translation}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.green.shade100),
      ),
      child: Column(
        children: [
          Text(
            arabic,
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(
              fontSize: 22,
              height: 1.8,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.green.shade300 : Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            latin,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white.withOpacity(0.8) : Colors.green.shade800,
            ),
          ),
          const Divider(height: 30),
          Text(
            translation,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: isDark ? Colors.white.withOpacity(0.6) : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdabItem(BuildContext context, String number, String title, String desc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isDark ? Colors.green.shade400 : Colors.green.shade700,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: isDark ? Colors.black : Colors.white, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.outfit(
                    fontSize: 14, 
                    color: isDark ? Colors.white.withOpacity(0.6) : Colors.grey.shade600,
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
