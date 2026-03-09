// lib/services/storage_service.dart
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/discovered_point.dart';
import '../models/user_statistics.dart';

class StorageService {
  static const String _globalBox = 'global_tracking';
  static const String _statsBox = 'stats';
  static const String _statsKey = 'user_stats';
  static const String _settingsBox = 'settings';

  static const String _discoveredKey = 'discovered_points';
  static const String _pathKey = 'path_points';

  late Box _globalData;
  late Box _stats;
  late Box _settings;

  Future<void> init() async {
    await Hive.initFlutter();
    _globalData = await Hive.openBox(_globalBox);
    _stats = await Hive.openBox(_statsBox);
    _settings = await Hive.openBox(_settingsBox);
  }

  // ── Settings ──────────────────────────────────────────────────────────────
  bool get isOnboardingCompleted =>
      _settings.get('onboarding', defaultValue: false) as bool;
  Future<void> setOnboardingCompleted() async =>
      await _settings.put('onboarding', true);

  // ── Global Tracking Data ──────────────────────────────────────────────────
  List<DiscoveredPoint> loadDiscoveredPoints() {
    final raw = _globalData.get(_discoveredKey);
    if (raw == null) return [];
    final list = jsonDecode(raw as String) as List;
    return list
        .map((e) => DiscoveredPoint.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveDiscoveredPoints(List<DiscoveredPoint> pts) async {
    final list = pts.map((p) => p.toJson()).toList();
    await _globalData.put(_discoveredKey, jsonEncode(list));
  }

  List<DiscoveredPoint> loadPathPoints() {
    final raw = _globalData.get(_pathKey);
    if (raw == null) return [];
    final list = jsonDecode(raw as String) as List;
    return list
        .map((e) => DiscoveredPoint.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> savePathPoints(List<DiscoveredPoint> pts) async {
    final list = pts.map((p) => p.toJson()).toList();
    await _globalData.put(_pathKey, jsonEncode(list));
  }

  // ── Statistics ────────────────────────────────────────────────────────────
  Future<UserStatistics> loadStatistics() async {
    final raw = _stats.get(_statsKey);
    if (raw == null) return UserStatistics();
    return UserStatistics.fromJson(
      jsonDecode(raw as String) as Map<String, dynamic>,
    );
  }

  Future<void> saveStatistics(UserStatistics stats) async {
    await _stats.put(_statsKey, jsonEncode(stats.toJson()));
  }

  Future<void> clearAll() async {
    await _globalData.clear();
    await _stats.clear();
  }
}
