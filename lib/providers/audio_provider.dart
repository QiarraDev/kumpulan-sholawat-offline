import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sholawat.dart';
import '../services/audio_player_service.dart';

final audioPlayerServiceProvider = Provider((ref) => AudioPlayerService());

final currentIndexProvider = StreamProvider<int?>((ref) {
  final service = ref.watch(audioPlayerServiceProvider);
  return service.currentIndexStream;
});

final currentSholawatProvider = StateProvider<Sholawat?>((ref) {
  final indexAsync = ref.watch(currentIndexProvider);
  final service = ref.watch(audioPlayerServiceProvider);
  
  return indexAsync.when(
    data: (index) {
      if (index != null && index < service.currentPlaylist.length) {
        return service.currentPlaylist[index];
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

final isPlayingProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(audioPlayerServiceProvider);
  return service.playerStateStream.map((state) => state.playing);
});

final positionProvider = StreamProvider<Duration>((ref) {
  final service = ref.watch(audioPlayerServiceProvider);
  return service.positionStream;
});

final durationProvider = StreamProvider<Duration?>((ref) {
  final service = ref.watch(audioPlayerServiceProvider);
  return service.durationStream;
});

final sleepTimerProvider = StreamProvider<Duration?>((ref) {
  final service = ref.watch(audioPlayerServiceProvider);
  return service.sleepTimerStream;
});
