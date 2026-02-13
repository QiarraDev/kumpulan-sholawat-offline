import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sholawat.dart';
import '../services/local_data_service.dart';

import '../services/supabase_service.dart';

final localDataServiceProvider = Provider((ref) => LocalDataService());

final sholawatListProvider = FutureProvider<List<Sholawat>>((ref) async {
  final service = ref.watch(localDataServiceProvider);
  
  try {
    // Coba ambil dari Supabase dulu (Feature 3)
    final remoteData = await SupabaseService.fetchRemoteSholawat();
    if (remoteData.isNotEmpty) {
      return remoteData.map((e) => Sholawat.fromJson(e)).toList();
    }
  } catch (e) {
    // Jika gagal (offine/tabel belum ada), pakai lokal
  }
  
  return await service.loadSholawatFromJson();
});

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<int>>((ref) {
  final service = ref.watch(localDataServiceProvider);
  return FavoritesNotifier(service);
});

class FavoritesNotifier extends StateNotifier<List<int>> {
  final LocalDataService _service;

  FavoritesNotifier(this._service) : super([]) {
    _loadFavorites();
  }

  void _loadFavorites() {
    final favorites = _service.favoritesBox.keys.map((e) => int.parse(e.toString())).toList();
    state = favorites.where((id) => _service.isFavorite(id)).toList();
  }

  Future<void> toggleFavorite(int id) async {
    final bool currentlyFav = _service.isFavorite(id);
    await _service.toggleFavorite(id);
    _loadFavorites();
    
    // Sync ke Cloud (Feature 2)
    try {
      if (SupabaseService.currentUser != null) {
        await SupabaseService.toggleCloudFavorite(id, !currentlyFav);
      }
    } catch (e) {
      // Gagal sync cloud (offline), tidak apa-apa karena sudah tersimpan lokal
    }
  }
}
