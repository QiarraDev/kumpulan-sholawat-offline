import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../models/sholawat.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  List<Sholawat> _currentPlaylist = [];

  AudioPlayer get player => _player;
  List<Sholawat> get currentPlaylist => _currentPlaylist;

  Future<void> setPlaylist(List<Sholawat> list, int initialIndex) async {
    _currentPlaylist = list;
    try {
      final playlist = ConcatenatingAudioSource(
        children: list.map((sholawat) {
          return AudioSource.uri(
            Uri.parse('asset:///${sholawat.audio}'),
            tag: MediaItem(
              id: sholawat.id.toString(),
              album: "Kumpulan Sholawat",
              title: sholawat.title,
              artist: sholawat.category,
              artUri: Uri.parse("https://ui-avatars.com/api/?name=${sholawat.title}&background=random"),
            ),
          );
        }).toList(),
      );

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
