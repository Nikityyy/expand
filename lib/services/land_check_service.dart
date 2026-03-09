// lib/services/land_check_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Determines whether a GPS point is on land or water using OSM Nominatim.
/// Results are cached (snapped to 4 decimal places ~11m).
class LandCheckService {
  static const int _snap = 4; // decimal places

  final _cache = <String, bool>{};

  String _key(LatLng point) {
    final lat = point.latitude.toStringAsFixed(_snap);
    final lng = point.longitude.toStringAsFixed(_snap);
    return '$lat,$lng';
  }

  /// Returns true if the point is on land (or a bridge/road), false if water.
  Future<bool> isLand(LatLng point) async {
    final key = _key(point);
    if (_cache.containsKey(key)) return _cache[key]!;

    try {
      final result = await _query(point);
      _cache[key] = result;
      return result;
    } catch (_) {
      // On error, assume land to avoid discarding legit data
      return true;
    }
  }

  Future<bool> _query(LatLng point) async {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse'
      '?lat=${point.latitude}&lon=${point.longitude}'
      '&format=json&zoom=16',
    );

    final response = await http.get(uri, headers: {
      'User-Agent': 'ExpandApp/1.0'
    }).timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) return true; // assume land on error

    final data = json.decode(response.body) as Map<String, dynamic>? ?? {};

    final osmClass = (data['class'] as String? ?? '').toLowerCase();
    final osmType = (data['type'] as String? ?? '').toLowerCase();

    // Water classification
    final isWater = (osmClass == 'waterway') ||
        (osmClass == 'natural' &&
            (osmType == 'water' ||
                osmType == 'bay' ||
                osmType == 'coastline' ||
                osmType == 'sea' ||
                osmType == 'ocean')) ||
        (osmClass == 'place' && (osmType == 'sea' || osmType == 'ocean'));

    // Bridge/road override
    final isRoad = osmClass == 'highway' ||
        osmType == 'bridge' ||
        osmType == 'road' ||
        osmType == 'path' ||
        osmType == 'footway' ||
        osmType == 'cycleway';

    if (isRoad) return true;
    return !isWater;
  }

  void clearCache() => _cache.clear();
}
