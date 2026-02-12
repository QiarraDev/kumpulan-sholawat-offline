import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  int _totalCount = 0;
  int _targetIndex = 0;
  final List<int> _targets = [33, 99, 100, 1000];

  void _incrementCounter() {
    setState(() {
      _counter++;
      _totalCount++;
      if (_counter >= _targets[_targetIndex]) {
        _counter = 0;
        HapticFeedback.vibrate(); // Heavier vibration on target reached
        _showFinishedDialog();
      } else {
        HapticFeedback.mediumImpact(); 
      }
    });
  }

  void _showFinishedDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alhamdulillah, target ${_targets[_targetIndex]} selesai!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade800,
      ),
    );
  }

  void _resetCounter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Tasbih?'),
        content: const Text('Semua hitungan akan kembali ke nol.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _counter = 0;
                _totalCount = 0;
              });
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade900, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Tasbih Digital',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
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
                    'TOTAL: $_totalCount',
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green.shade700, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$_counter',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        child: ActionChip(
                          label: Text('/ ${_targets[_targetIndex]}'),
                          backgroundColor: Colors.green.shade900.withOpacity(0.5),
                          labelStyle: GoogleFonts.outfit(
                            color: Colors.green.shade400,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          onPressed: () {
                            setState(() {
                              _targetIndex = (_targetIndex + 1) % _targets.length;
                              _counter = 0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // TAP AREA
              GestureDetector(
                onTap: _incrementCounter,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 60,
                        color: Colors.green.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'KETUK DI MANA SAJA',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'UNTUK MENGHITUNG',
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
