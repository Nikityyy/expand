// lib/services/location_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static const double _highAccuracyM = 10.0;

  final _positionStreamController = StreamController<Position>.broadcast();

  Stream<Position> get positionStream => _positionStreamController.stream;
  Position? _lastPosition;
  StreamSubscription<Position>? _sub;

  bool _isTracking = false;
  bool get isTracking => _isTracking;

  /// Request location permissions, return true if granted.
  Future<bool> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  /// Start continuous GPS tracking.
  Future<bool> startTracking() async {
    if (_isTracking) return true;
    final granted = await requestPermissions();
    if (!granted) return false;

    final settings = AppleSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    final androidSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
      forceLocationManager: false,
      intervalDuration: const Duration(seconds: 5),
      // Foreground service notification (Android 10+)
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText:
            "Expand is tracking your exploration in the background.",
        notificationTitle: "Exploration Active",
        enableWakeLock: true,
      ),
    );

    _sub = Geolocator.getPositionStream(
      locationSettings: defaultTargetPlatform == TargetPlatform.android
          ? androidSettings
          : settings,
    ).listen((
      pos,
    ) {
      if (_shouldEmit(pos)) {
        _lastPosition = pos;
        _positionStreamController.add(pos);
      }
    }, onError: (Object e) => debugPrint('LocationService error: $e'));

    _isTracking = true;
    return true;
  }

  void stopTracking() {
    _sub?.cancel();
    _sub = null;
    _isTracking = false;
  }

  /// Returns the current position (one-shot).
  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (_) {
      return null;
    }
  }

  bool _shouldEmit(Position pos) {
    if (_lastPosition == null) return true;
    final dist = Geolocator.distanceBetween(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      pos.latitude,
      pos.longitude,
    );
    return dist >= _highAccuracyM;
  }

  LatLng? get lastLatLng {
    if (_lastPosition == null) return null;
    return LatLng(_lastPosition!.latitude, _lastPosition!.longitude);
  }

  void dispose() {
    stopTracking();
    _positionStreamController.close();
  }
}
