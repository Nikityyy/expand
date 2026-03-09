// lib/models/region_info.dart
import 'package:latlong2/latlong.dart';

/// Describes the selected exploration region.
class RegionInfo {
  final String name; // Display name
  final LatLng center; // Map center
  final double radiusM; // Bounding radius in meters (for street mode)
  final List<LatLng>? boundaryPolygon; // Optional polygon for city/country
  final double? totalAreaM2; // Pre-calculated discoverable land area

  const RegionInfo({
    required this.name,
    required this.center,
    this.radiusM = 5000,
    this.boundaryPolygon,
    this.totalAreaM2,
  });

  bool get hasPolygon => boundaryPolygon != null && boundaryPolygon!.isNotEmpty;
}
