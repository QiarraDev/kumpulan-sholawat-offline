import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> with SingleTickerProviderStateMixin {
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
        HapticFeedback.vibrate(); 
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
            child: Text('Batal', style: TextStyle(color: Colors.green.shade700)),
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
            colors: [const Color(0xFF003322), Colors.black],
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
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Tasbih Digital',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
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
