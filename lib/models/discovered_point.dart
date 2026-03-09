// lib/models/discovered_point.dart
import 'package:latlong2/latlong.dart';

/// A single GPS point that was confirmed as land and added to the discovery layer.
class DiscoveredPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double accuracy; // meters

  const DiscoveredPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy = 0,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  Map<String, dynamic> toJson() => {
    'lat': latitude,
    'lng': longitude,
    'ts': timestamp.millisecondsSinceEpoch,
    'acc': accuracy,
  };

  factory DiscoveredPoint.fromJson(Map<String, dynamic> j) => DiscoveredPoint(
    latitude: (j['lat'] as num).toDouble(),
    longitude: (j['lng'] as num).toDouble(),
    timestamp: DateTime.fromMillisecondsSinceEpoch(j['ts'] as int),
    accuracy: (j['acc'] as num).toDouble(),
  );
}
