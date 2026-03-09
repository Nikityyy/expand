// lib/services/region_service.dart
import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/region_info.dart';
import '../models/exploration_mode.dart';

class RegionService {
  static const String _nominatimBase = 'https://nominatim.openstreetmap.org';

  /// Search for places matching [query] for the given mode.
  Future<List<RegionInfo>> search(ExplorationMode mode, String query) async {
    if (mode == ExplorationMode.world) {
      return [_worldRegion()];
    }

    final osmType = mode == ExplorationMode.city
        ? 'city'
        : mode == ExplorationMode.country
        ? 'country'
        : null;

    final params = {
      'q': query,
      'format': 'json',
      'addressdetails': '1',
      'limit': '5',
    };
    if (osmType != null) params['featuretype'] = osmType;

    final uri = Uri.parse(
      '$_nominatimBase/search',
    ).replace(queryParameters: params);

    final response = await http
        .get(uri, headers: {'User-Agent': 'ExpandApp/1.0'})
        .timeout(const Duration(seconds: 8));

    if (response.statusCode != 200) return [];

    final results = (json.decode(response.body) as List)
        .cast<Map<String, dynamic>>();

    return results
        .map((r) => _parseResult(r, mode))
        .whereType<RegionInfo>()
        .toList();
  }

  RegionInfo? _parseResult(Map<String, dynamic> r, ExplorationMode mode) {
    try {
      final lat = double.parse(r['lat'] as String);
      final lon = double.parse(r['lon'] as String);
      final name = r['display_name'] as String? ?? '';
      final center = LatLng(lat, lon);

      double radiusM = 5000;
      if (mode == ExplorationMode.city) radiusM = 20000;
      if (mode == ExplorationMode.country) radiusM = 500000;

      // Build a simple bounding-box polygon from the bbox
      List<LatLng>? boundary;
      final bbox = r['boundingbox'] as List?;
      if (bbox != null && bbox.length == 4) {
        final s = double.parse(bbox[0].toString());
        final n = double.parse(bbox[1].toString());
        final w = double.parse(bbox[2].toString());
        final e = double.parse(bbox[3].toString());
        boundary = [LatLng(s, w), LatLng(n, w), LatLng(n, e), LatLng(s, e)];
        // Estimate area from bounding box
        radiusM =
            math.max(
              _haversine(LatLng(s, w), LatLng(n, w)),
              _haversine(LatLng(s, w), LatLng(s, e)),
            ) /
            2;
      }

      return RegionInfo(
        name: _shortName(name),
        center: center,
        radiusM: radiusM,
        boundaryPolygon: boundary,
      );
    } catch (_) {
      return null;
    }
  }

  String _shortName(String displayName) {
    final parts = displayName.split(',');
    if (parts.isEmpty) return displayName;
    return parts.take(2).map((p) => p.trim()).join(', ');
  }

  RegionInfo _worldRegion() {
    return const RegionInfo(
      name: 'World',
      center: LatLng(20, 0),
      radiusM: 20037508,
      boundaryPolygon: [
        LatLng(-85, -180),
        LatLng(85, -180),
        LatLng(85, 180),
        LatLng(-85, 180),
      ],
    );
  }

  double _haversine(LatLng a, LatLng b) {
    const r = 6371000.0;
    final dLat = _deg2rad(b.latitude - a.latitude);
    final dLon = _deg2rad(b.longitude - a.longitude);
    final sinLat = math.sin(dLat / 2);
    final sinLon = math.sin(dLon / 2);
    final h =
        sinLat * sinLat +
        math.cos(_deg2rad(a.latitude)) *
            math.cos(_deg2rad(b.latitude)) *
            sinLon *
            sinLon;
    return 2 * r * math.asin(math.sqrt(h));
  }

  double _deg2rad(double deg) => deg * math.pi / 180;
}
