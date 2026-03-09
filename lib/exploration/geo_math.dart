// lib/exploration/geo_math.dart
import 'dart:math' as math;
import 'package:latlong2/latlong.dart';

/// Core geospatial math utilities used by the exploration engine.
abstract final class GeoMath {
  static const double _earthR = 6371000.0; // metres
  static const double discoveryRadius = 50.0; // FIXED – never change

  /// Haversine distance between two LatLng points in metres.
  static double haversine(LatLng a, LatLng b) {
    final dLat = _toRad(b.latitude - a.latitude);
    final dLon = _toRad(b.longitude - a.longitude);
    final sinLat = math.sin(dLat / 2);
    final sinLon = math.sin(dLon / 2);
    final h = sinLat * sinLat +
        math.cos(_toRad(a.latitude)) *
            math.cos(_toRad(b.latitude)) *
            sinLon *
            sinLon;
    return 2 * _earthR * math.asin(math.sqrt(h));
  }

  /// Convert a centre + radius into a polygon (list of LatLng).
  /// [steps] controls the smoothness (32 is fine for fog rendering).
  static List<LatLng> circleToPolygon(
    LatLng center,
    double radiusM, {
    int steps = 32,
  }) {
    final lat = _toRad(center.latitude);
    final lng = _toRad(center.longitude);
    final d = radiusM / _earthR; // angular distance in radians

    return List.generate(steps, (i) {
      final bearing = 2 * math.pi * i / steps;
      final pLat = math.asin(
        math.sin(lat) * math.cos(d) +
            math.cos(lat) * math.sin(d) * math.cos(bearing),
      );
      final pLng = lng +
          math.atan2(
            math.sin(bearing) * math.sin(d) * math.cos(lat),
            math.cos(d) - math.sin(lat) * math.sin(pLat),
          );
      return LatLng(_toDeg(pLat), _toDeg(pLng));
    });
  }

  /// Approximate area of a polygon in m² using the spherical excess method.
  static double polygonAreaM2(List<LatLng> pts) {
    if (pts.length < 3) return 0;
    double area = 0;
    final n = pts.length;
    for (int i = 0; i < n; i++) {
      final j = (i + 1) % n;
      area += _toRad(pts[j].longitude - pts[i].longitude) *
          (2 +
              math.sin(_toRad(pts[i].latitude)) +
              math.sin(_toRad(pts[j].latitude)));
    }
    return (area * _earthR * _earthR / 2).abs();
  }

  /// Returns the area of the union of a list of circles (approximation).
  /// For the progress calculation we accumulate non-overlapping area by
  /// checking if a new centre is farther than 2×radius from all existing ones.
  static double accumulatedCircleAreaM2(
    List<LatLng> centres, {
    double radius = discoveryRadius,
  }) {
    final unique = <LatLng>[];
    for (final c in centres) {
      bool tooClose = false;
      for (final u in unique) {
        if (haversine(c, u) < radius * 1.5) {
          tooClose = true;
          break;
        }
      }
      if (!tooClose) unique.add(c);
    }
    return unique.length * math.pi * radius * radius;
  }

  /// Calculates the approximate "new" area added by a new point,
  /// accounting for overlap with existing points.
  static double calculateNewAreaM2(
      LatLng newPoint, List<LatLng> existingPoints) {
    const radius = discoveryRadius;
    const areaCircle = math.pi * radius * radius;

    // If no existing points, full area
    if (existingPoints.isEmpty) return areaCircle;

    // Find the closest point
    double minDict = double.infinity;
    for (final p in existingPoints) {
      final d = haversine(newPoint, p);
      if (d < minDict) minDict = d;
    }

    // If extremely close to an existing point, assume zero new area
    if (minDict < radius * 0.1) return 0;

    // Simple heuristic: if distance > 2*radius, no overlap
    if (minDict >= 2 * radius) return areaCircle;

    // Geometric overlap approximation (circular segment area)
    // Area = 2 * R^2 * acos(d/2R) - (d/2) * sqrt(R^2 - (d/2)^2)
    final d = minDict;
    const r = radius;
    final overlap = 2 * r * r * math.acos(d / (2 * r)) -
        (d / 2) * math.sqrt(r * r - (d * d / 4));

    return (areaCircle - overlap).clamp(0, areaCircle);
  }

  static double _toRad(double deg) => deg * math.pi / 180;
  static double _toDeg(double rad) => rad * 180 / math.pi;
}
