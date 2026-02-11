import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../models/sholawat.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Future<void> playSholawat(Sholawat sholawat) async {
    try {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse('asset:///${sholawat.audio}'),
          tag: MediaItem(
            id: sholawat.id.toString(),
            album: "Kumpulan Sholawat",
            title: sholawat.title,
            artUri: Uri.parse("https://example.com/logo.png"), // Placeholder
          ),
        ),
      );
      _player.play();
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void pause() => _player.pause();
  void resume() => _player.play();
  void stop() => _player.stop();
  void seek(Duration position) => _player.seek(position);

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  void dispose() {
    _player.dispose();
  }
}
