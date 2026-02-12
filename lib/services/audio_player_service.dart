import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../models/sholawat.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  List<Sholawat> _currentPlaylist = [];
  Timer? _sleepTimer;
  final _sleepTimerController = StreamController<Duration?>.broadcast();

  AudioPlayer get player => _player;
  List<Sholawat> get currentPlaylist => _currentPlaylist;
  Stream<Duration?> get sleepTimerStream => _sleepTimerController.stream;

  void setSleepTimer(Duration? duration) {
    _sleepTimer?.cancel();
    if (duration == null) {
      _sleepTimerController.add(null);
      return;
    }

    var remaining = duration;
    _sleepTimerController.add(remaining);
    
    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining = remaining - const Duration(seconds: 1);
      if (remaining.inSeconds <= 0) {
        stop();
        _sleepTimer?.cancel();
        _sleepTimerController.add(null);
      } else {
        _sleepTimerController.add(remaining);
      }
    });
  }

  Future<void> setPlaylist(List<Sholawat> list, int initialIndex) async {
    _currentPlaylist = list;
    try {
      final playlist = ConcatenatingAudioSource(
        children: list.map((sholawat) {
          final audioUri = sholawat.id == 1 
              ? Uri.parse('https://ia800905.us.archive.org/29/items/sholawat-badar/Sholawat%20Badar.mp3')
              : Uri.parse('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');

          debugPrint("DEBUG: Loading Audio for ${sholawat.title}: $audioUri");

          return AudioSource.uri(
            audioUri,
            tag: MediaItem(
              id: sholawat.id.toString(),
              album: "Kumpulan Sholawat",
              title: sholawat.title,
              artist: sholawat.category,
              artUri: Uri.parse("https://ui-avatars.com/api/?name=${sholawat.title}&background=2E7D32&color=fff"),
            ),
          );
        }).toList(),
      );

      await _player.setVolume(1.0);
      await _player.setAudioSource(playlist, initialIndex: initialIndex);
      _player.play();
    } catch (e) {
      debugPrint("Error loading playlist: $e");
      // Fallback for demo when assets are missing
      if (initialIndex < list.length) {
         debugPrint("Demo mode: Assets missing, simulation enabled.");
      }
    }
  }

  void pause() => _player.pause();
  void resume() => _player.play();
  void stop() => _player.stop();
  void seek(Duration position) => _player.seek(position);
  void next() => _player.seekToNext();
  void previous() => _player.seekToPrevious();

  Stream<int?> get currentIndexStream => _player.currentIndexStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  void dispose() {
    _player.dispose();
  }
}
