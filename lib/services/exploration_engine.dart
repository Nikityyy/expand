// lib/services/exploration_engine.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../exploration/geo_math.dart';
import '../models/discovered_point.dart';
import '../models/user_statistics.dart';
import 'land_check_service.dart';
import 'location_service.dart';
import 'storage_service.dart';

/// Central engine that ties GPS → geocoding → land check → global discovery → progress.
class ExplorationEngine extends ChangeNotifier {
  final LocationService _locationService;
  final LandCheckService _landCheck;
  final StorageService _storage;

  StreamSubscription<Position>? _posSub;

  bool _isRunning = false;
  bool _isInitialized = false;
  String? _permissionError;

  // Global Context State
  String? _currentCity;
  String? _currentCountry;

  List<DiscoveredPoint> _discoveredPoints = [];
  List<DiscoveredPoint> _pathPoints = [];
  UserStatistics _stats = UserStatistics();

  // ── Getters ──────────────────────────────────────────────────────────────
  bool get isRunning => _isRunning;
  bool get isInitialized => _isInitialized;
  String? get permissionError => _permissionError;
  String? get currentCity => _currentCity;
  String? get currentCountry => _currentCountry;

  List<LatLng> get discoveredCentres =>
      _discoveredPoints.map((p) => p.latLng).toList();
  List<LatLng> get pathPoints => _pathPoints.map((p) => p.latLng).toList();

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;
  UserStatistics get stats => _stats;

  ExplorationEngine({
    required LocationService locationService,
    required LandCheckService landCheck,
    required StorageService storage,
  })  : _locationService = locationService,
        _landCheck = landCheck,
        _storage = storage;

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  Future<void> init() async {
    _isInitialized = false;
    notifyListeners();

    // Load global history
    _discoveredPoints = _storage.loadDiscoveredPoints();
    _pathPoints = _storage.loadPathPoints();
    _stats = await _storage.loadStatistics();

    _isInitialized = true;
    notifyListeners();

    // Contextual tracking is always-on
    await autoStartTracking();
  }

  Future<void> autoStartTracking() async {
    final granted = await _locationService.startTracking();
    if (!granted) {
      _permissionError =
          'Location access denied. Please enable it in Settings.';
      notifyListeners();
    } else {
      _permissionError = null;
      _isRunning = true;
      _posSub ??= _locationService.positionStream.listen(_onPosition);
      notifyListeners();
    }
  }

  // ── Core GPS handler ──────────────────────────────────────────────────────
  Future<void> _onPosition(Position pos) async {
    _currentPosition = pos;
    final ll = LatLng(pos.latitude, pos.longitude);

    // 1. Always record path point
    final pathPt = DiscoveredPoint(
      latitude: pos.latitude,
      longitude: pos.longitude,
      timestamp: DateTime.now(),
      accuracy: pos.accuracy,
    );
    _pathPoints.add(pathPt);
    _updateDistance(pathPt);

    // 2. Geocode current location asynchronously without blocking
    _resolveLocation(pos.latitude, pos.longitude);

    // 3. Land check before adding to discovered
    final land = await _landCheck.isLand(ll);
    if (land) {
      // Distance Filter: Only add if >= 40m from nearest discovered point
      bool tooClose = false;
      for (final p in _discoveredPoints) {
        if (GeoMath.haversine(ll, p.latLng) < 40.0) {
          tooClose = true;
          break;
        }
      }

      if (!tooClose) {
        _discoveredPoints.add(pathPt);
        _stats.totalDiscoveredPoints += 1;

        // Accurate area delta accounting for overlap
        final deltaArea = GeoMath.calculateNewAreaM2(
          ll,
          _discoveredPoints
              .where((p) => p != pathPt)
              .map((p) => p.latLng)
              .toList(),
        );

        if (_currentCity != null && _currentCountry != null) {
          _stats.addCityArea(_currentCity!, _currentCountry!, deltaArea);
        } else {
          _stats.totalAreaM2 += deltaArea;
        }
      }
    }

    // Debounce saves in production if memory/IO becomes a concern, right now just blast it
    await _storage.savePathPoints(_pathPoints);
    await _storage.saveDiscoveredPoints(_discoveredPoints);
    await _storage.saveStatistics(_stats);

    notifyListeners();
  }

  DateTime? _lastGeocode;
  Future<void> _resolveLocation(double lat, double lon) async {
    if (_lastGeocode != null &&
        DateTime.now().difference(_lastGeocode!).inSeconds < 30) {
      return; // Rate limit geocoding to once per 30s
    }

    _lastGeocode = DateTime.now();
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final city = p.locality ??
            p.subAdministrativeArea ??
            p.administrativeArea ??
            "Unknown City";
        final country = p.country ?? "Unknown Country";

        if (_currentCity != city || _currentCountry != country) {
          _currentCity = city;
          _currentCountry = country;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Geocoding failed: $e");
    }
  }

  void _updateDistance(DiscoveredPoint newPt) {
    if (_pathPoints.length < 2) return;
    final prev = _pathPoints[_pathPoints.length - 2];
    final dist = GeoMath.haversine(
      LatLng(prev.latitude, prev.longitude),
      newPt.latLng,
    );
    _stats.totalDistanceM += dist;
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _locationService.dispose();
    super.dispose();
  }

  /// One-time fix to clean up corrupted stats by recalculating from scratch
  /// based on the unique discovered points and proper discovery radius.
  Future<void> fixStats() async {
    final filtered = <DiscoveredPoint>[];
    for (final p in _discoveredPoints) {
      bool tooClose = false;
      for (final f in filtered) {
        if (GeoMath.haversine(p.latLng, f.latLng) < 40.0) {
          tooClose = true;
          break;
        }
      }
      if (!tooClose) filtered.add(p);
    }

    _discoveredPoints = filtered;

    // Reset area stats
    _stats.totalAreaM2 = 0;
    _stats.totalDiscoveredPoints = _discoveredPoints.length;
    for (var v in _stats.cityStats.values) {
      v.discoveredAreaM2 = 0;
      v.discoveredPointsCount = 0;
    }

    // Re-accumulate area using the same overlap logic
    final pointsSoFar = <LatLng>[];
    for (final p in _discoveredPoints) {
      final delta = GeoMath.calculateNewAreaM2(p.latLng, pointsSoFar);
      _stats.totalAreaM2 += delta;

      if (_currentCity != null && _currentCountry != null) {
        _stats.addCityArea(_currentCity!, _currentCountry!, delta,
            incrementPoints: true);
      }

      pointsSoFar.add(p.latLng);
    }

    await _storage.saveDiscoveredPoints(_discoveredPoints);
    await _storage.saveStatistics(_stats);
    notifyListeners();
  }
}
