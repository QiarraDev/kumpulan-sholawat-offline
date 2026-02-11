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
            expandedHeight: 200.0,
            pinned: true,
            backgroundColor: Colors.green.shade900,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Doa & Adab', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green.shade800, Colors.green.shade900],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.menu_book, size: 80, color: Colors.white.withOpacity(0.2)),
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
                  _buildSectionTitle('Niat Sebelum Bersholawat'),
                  const SizedBox(height: 15),
                  _buildDoaCard(
                    context,
                    arabic: 'اللَّهُمَّ إِنِّي نَوَيْتُ بِهَذِهِ الصَّلَاةِ عَلَى النَّبِيِّ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ امْتِثَالًا لِأمرِكَ وَتَصْدِيقًا لِنَبِيِّكَ وَمَحَبَّةً فِيهِ وَشَوْقًا إِلَيْهِ وَتَعْظِيمًا لِقَدْرِهِ',
                    latin: 'Allahumma inni nawaitu bihadzihis-shalati \'alan-nabiyyi shallallahu \'alaihi wa sallama imtitsalan li amrika wa tashdiqan linabiyyika wa mahabbatan fihi wa syauqan ilaihi wa ta\'dziman liqadrihi.',
                    translation: 'Ya Allah, sesungguhnya aku niat bershalawat kepada Nabi SAW untuk mematuhi perintah-Mu, membenarkan Nabi-Mu, didasari rasa cinta dan rindu kepadanya, serta mengagungkan kedudukannya.',
                  ),
                  const SizedBox(height: 30),
                  _buildSectionTitle('Adab Bersholawat'),
                  const SizedBox(height: 15),
                  _buildAdabItem('1', 'Menghadirkan Hati', 'Rasakan kehadiran baginda Nabi Muhammad SAW dalam hati saat membaca.'),
                  _buildAdabItem('2', 'Suci dari Hadats', 'Sangat diutamakan dalam keadaan berwudhu.'),
                  _buildAdabItem('3', 'Penuh Tawadhu', 'Membaca dengan penuh rasa rendah hati dan rasa hormat.'),
                  _buildAdabItem('4', 'Mantra Suara', 'Membaca dengan suara yang santun dan tartil.'),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.green.shade900,
      ),
    );
  }

  Widget _buildDoaCard(BuildContext context, {required String arabic, required String latin, required String translation}) {
    return Container(
      padding: const EdgeInsets.all(20),
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
            arabic,
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(
              fontSize: 22,
              height: 1.8,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            latin,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.green.shade800,
            ),
          ),
          const Divider(height: 30),
          Text(
            translation,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdabItem(String number, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  desc,
                  style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
