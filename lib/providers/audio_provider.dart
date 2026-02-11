import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sholawat.dart';
import '../services/audio_player_service.dart';

final audioPlayerServiceProvider = Provider((ref) => AudioPlayerService());

final currentSholawatProvider = StateProvider<Sholawat?>((ref) => null);

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
