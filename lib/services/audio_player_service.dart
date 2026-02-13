import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../models/sholawat.dart';
import 'download_service.dart';

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

  AudioPlayerService() {
    _initListeners();
  }

  void _initListeners() {
    _player.durationStream.listen((d) => debugPrint("DEBUG: Duration: $d"));
    _player.positionStream.listen((p) => debugPrint("DEBUG: Position: ${p.inSeconds}s"));
    _player.playerStateStream.listen((s) => debugPrint("DEBUG: State: $s"));
    
    // Download sholawat yang sedang diputar saja agar tidak berat
    _player.currentIndexStream.listen((index) {
      if (index != null && index < _currentPlaylist.length) {
        final sholawat = _currentPlaylist[index];
        final fileName = sholawat.audio.split('/').last;
        if (sholawat.url != null && sholawat.url!.isNotEmpty) {
           DownloadService.downloadFromUrl(sholawat.url!, fileName);
        }
      }
    });
  }

  Future<void> setPlaylist(List<Sholawat> list, int initialIndex) async {
    _currentPlaylist = list;
    try {
      debugPrint("DEBUG: Preparing playlist...");
      
      final List<AudioSource> sources = [];

      for (var sholawat in list) {
        final fileName = sholawat.audio.split('/').last;
        final localPath = await DownloadService.getLocalPath(fileName);
        final localFile = File(localPath);
        
        if (await localFile.exists()) {
          debugPrint("DEBUG: [PLAYER] LOCAL: $localPath");
          sources.add(
            AudioSource.file(localPath, tag: _createMediaItem(sholawat)),
          );
        } else if (sholawat.url != null && sholawat.url!.isNotEmpty) {
          debugPrint("DEBUG: [PLAYER] REMOTE: ${sholawat.url}");
          sources.add(
            AudioSource.uri(Uri.parse(sholawat.url!), tag: _createMediaItem(sholawat)),
          );
          // Download dipindah ke listener currentIndexStream agar tidak menumpuk
        } else {
          final assetPath = sholawat.audio.startsWith('assets/') 
              ? sholawat.audio 
              : "assets/audio/${sholawat.audio}";
          debugPrint("DEBUG: [PLAYER] ASSET: $assetPath");
          sources.add(
            AudioSource.uri(Uri.parse('asset:///$assetPath'), tag: _createMediaItem(sholawat)),
          );
        }
      }

      if (sources.isEmpty) return;

      final playlist = ConcatenatingAudioSource(children: sources);

      await _player.stop();
      await _player.setVolume(1.0);
      await _player.setAudioSource(playlist, initialIndex: initialIndex);
      _player.play();
      
    } catch (e) {
      debugPrint("DEBUG: CRITICAL ERROR in setPlaylist: $e");
    }
  }

  MediaItem _createMediaItem(Sholawat sholawat) {
    return MediaItem(
      id: sholawat.id.toString(),
      album: "Kumpulan Sholawat",
      title: sholawat.title,
      artist: sholawat.category,
      artUri: Uri.parse("https://ui-avatars.com/api/?name=${sholawat.title}&background=2E7D32&color=fff"),
    );
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
