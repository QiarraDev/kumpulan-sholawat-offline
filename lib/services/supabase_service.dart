import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String _url = 'YOUR_SUPABASE_URL';
  static const String _anonKey = 'YOUR_SUPABASE_ANON_KEY';

  static Future<void> init() async {
    await Supabase.initialize(
      url: _url,
      anonKey: _anonKey,
    );
    debugPrint("Supabase Initialized");
  }

  static SupabaseClient get client => Supabase.instance.client;

  // --- FEATURE 1: JAM'IYYAH ONLINE (Real-time Global Counter) ---
  static Stream<int> getGlobalCounterStream() {
    return client
        .from('global_counters')
        .stream(primaryKey: ['id'])
        .eq('id', 1)
        .map((data) => data.isEmpty ? 0 : data.first['count'] as int);
  }

  static Future<void> incrementGlobalCounter() async {
    try {
      await client.rpc('increment_global_counter');
    } catch (e) {
      debugPrint("Error incrementing counter: $e");
    }
  }

  // --- FEATURE 2: CLOUD FAVORITES & AUTH ---
  static Future<void> signInWithGoogle() async {
    await client.auth.signInWithOAuth(OAuthProvider.google);
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static User? get currentUser => client.auth.currentUser;

  static Stream<List<int>> getCloudFavoritesStream() {
    final user = currentUser;
    if (user == null) return const Stream.empty();
    
    return client
        .from('user_favorites')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .map((data) => data.map((item) => item['sholawat_id'] as int).toList());
  }

  static Future<void> toggleCloudFavorite(int sholawatId, bool isFavorite) async {
    final user = currentUser;
    if (user == null) return;

    if (isFavorite) {
      await client.from('user_favorites').insert({
        'user_id': user.id,
        'sholawat_id': sholawatId,
      });
    } else {
      await client
          .from('user_favorites')
          .delete()
          .match({'user_id': user.id, 'sholawat_id': sholawatId});
    }
  }

  // --- FEATURE 3: REMOTE CONTENT (Dynamic Sholawat List) ---
  static Future<List<Map<String, dynamic>>> fetchRemoteSholawat() async {
    try {
      final response = await client.from('sholawat').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("Error fetching remote sholawat: $e");
      return [];
    }
  }

  // --- FEATURE 4: DINDING DOA ---
  static Stream<List<Map<String, dynamic>>> getPrayerWallStream() {
    return client
        .from('prayer_wall')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  static Future<void> postPrayer(String name, String message) async {
    await client.from('prayer_wall').insert({
      'name': name,
      'message': message,
      'user_id': currentUser?.id,
    });
  }

  static Future<void> aamiinPrayer(int prayerId) async {
    await client.rpc('increment_aamiin', params: {'prayer_id': prayerId});
  }
}
