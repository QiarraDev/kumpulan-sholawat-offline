import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../services/local_data_service.dart';
import '../providers/sholawat_provider.dart';
import '../providers/settings_provider.dart';

class TasbihScreen extends ConsumerStatefulWidget {
  const TasbihScreen({super.key});

  @override
  ConsumerState<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends ConsumerState<TasbihScreen> with SingleTickerProviderStateMixin {
  int _counter = 0;
  int _totalCount = 0;
  int _targetIndex = 0;
  final List<int> _targets = [33, 99, 100, 1000];
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.95,
      upperBound: 1.05,
    );
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('tasbih_counter') ?? 0;
      _totalCount = prefs.getInt('tasbih_total') ?? 0;
      _targetIndex = prefs.getInt('tasbih_target_index') ?? 0;
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbih_counter', _counter);
    await prefs.setInt('tasbih_total', _totalCount);
    await prefs.setInt('tasbih_target_index', _targetIndex);

    // Record daily stats in Hive
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final tasbihBox = ref.read(localDataServiceProvider).tasbihBox;
    final currentDaily = tasbihBox.get(today, defaultValue: 0) ?? 0;
    await tasbihBox.put(today, currentDaily + 1);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    _pulseController.forward(from: 0.95).then((_) => _pulseController.reverse());
    setState(() {
      _counter++;
      _totalCount++;
      if (_counter >= _targets[_targetIndex]) {
        _counter = 0;
        HapticFeedback.heavyImpact(); 
        _showFinishedDialog();
      } else {
        HapticFeedback.lightImpact(); 
      }
      _saveProgress();
    });
  }

  void _showStats() {
    final tasbihBox = ref.read(localDataServiceProvider).tasbihBox;
    final List<MapEntry<String, int>> last7Days = [];
    
    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final count = tasbihBox.get(dateStr, defaultValue: 0) ?? 0;
      last7Days.add(MapEntry(DateFormat('EEE, dd MMM', 'id_ID').format(date), count));
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistik Dzikir',
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Aktivitas 7 hari terakhir',
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ...last7Days.map((entry) {
              final maxVal = last7Days.map((e) => e.value).reduce((a, b) => a > b ? a : b);
              final progress = maxVal > 0 ? entry.value / maxVal : 0.0;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(
                        entry.key,
                        style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress.clamp(0.05, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.green.shade700, Colors.green.shade400],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${entry.value}',
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showFinishedDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alhamdulillah, target ${_targets[_targetIndex]} selesai!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _resetCounter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Tasbih?'),
        content: const Text('Semua hitungan akan kembali ke nol.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF2E7D32))),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _counter = 0;
                _totalCount = 0;
              });
              _saveProgress();
              Navigator.pop(context);
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF003322), 
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Tasbih Digital',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.bar_chart_rounded, color: Colors.white),
                      onPressed: _showStats,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      onPressed: _resetCounter,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // COUNTER DISPLAY
              Column(
                children: [
                  Text(
                    'TOTAL HITUNGAN: $_totalCount',
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 14,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ScaleTransition(
                    scale: _pulseController,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.green.shade400.withOpacity(0.3), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.shade400.withOpacity(0.1),
                                blurRadius: 40,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.green.shade900.withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: Text(
                            '$_counter',
                            key: ValueKey<int>(_counter),
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 100,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _targetIndex = (_targetIndex + 1) % _targets.length;
                                _counter = 0;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade900.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.green.shade400.withOpacity(0.3)),
                              ),
                              child: Text(
                                '/ ${_targets[_targetIndex]}',
                                style: GoogleFonts.outfit(
                                  color: Colors.green.shade300,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // TAP AREA
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: GestureDetector(
                  onTap: _incrementCounter,
                  child: Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fingerprint_rounded,
                          size: 70,
                          color: Colors.green.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'SENTUH UNTUK DZIKIR',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
