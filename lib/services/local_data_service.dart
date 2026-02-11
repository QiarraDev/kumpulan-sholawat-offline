import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/sholawat.dart';

class LocalDataService {
  static const String sholawatBoxName = 'sholawat_box';
  static const String settingsBoxName = 'settings_box';
  static const String favoritesBoxName = 'favorites_box';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SholawatAdapter());
    await Hive.openBox<Sholawat>(sholawatBoxName);
    await Hive.openBox(settingsBoxName);
    await Hive.openBox<bool>(favoritesBoxName);
  }

  Future<List<Sholawat>> loadSholawatFromJson() async {
    final String response = await rootBundle.loadString('assets/data/sholawat.json');
    final data = await json.decode(response);
    return (data as List).map((e) => Sholawat.fromJson(e)).toList();
  }

  Box<Sholawat> get sholawatBox => Hive.box<Sholawat>(sholawatBoxName);
  Box get settingsBox => Hive.box(settingsBoxName);
  Box<bool> get favoritesBox => Hive.box<bool>(favoritesBoxName);

  bool isFavorite(int id) {
    return favoritesBox.get(id.toString(), defaultValue: false) ?? false;
  }

  Future<void> toggleFavorite(int id) async {
    final bool current = isFavorite(id);
    await favoritesBox.put(id.toString(), !current);
  }
}
