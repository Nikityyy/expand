import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:expand/services/exploration_engine.dart';
import 'package:expand/services/location_service.dart';
import 'package:expand/services/land_check_service.dart';
import 'package:expand/services/storage_service.dart';
import 'package:expand/models/user_statistics.dart';

class MockLocationService extends Mock implements LocationService {}

class MockLandCheckService extends Mock implements LandCheckService {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  late ExplorationEngine engine;
  late MockLocationService mockLocation;
  late MockLandCheckService mockLandCheck;
  late MockStorageService mockStorage;

  setUpAll(() {
    registerFallbackValue(const LatLng(0, 0));
    registerFallbackValue(UserStatistics());
  });

  setUp(() {
    mockLocation = MockLocationService();
    mockLandCheck = MockLandCheckService();
    mockStorage = MockStorageService();

    // Default mock behaviors
    when(() => mockStorage.loadDiscoveredPoints()).thenReturn([]);
    when(() => mockStorage.loadPathPoints()).thenReturn([]);
    when(() => mockStorage.loadStatistics())
        .thenAnswer((_) async => UserStatistics());
    when(() => mockStorage.savePathPoints(any())).thenAnswer((_) async {});
    when(() => mockStorage.saveDiscoveredPoints(any()))
        .thenAnswer((_) async {});
    when(() => mockStorage.saveStatistics(any())).thenAnswer((_) async {});

    when(() => mockLocation.positionStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockLocation.startTracking()).thenAnswer((_) async => true);
    when(() => mockLocation.dispose()).thenAnswer((_) async {});

    engine = ExplorationEngine(
      locationService: mockLocation,
      landCheck: mockLandCheck,
      storage: mockStorage,
    );
  });

  group('ExplorationEngine', () {
    test('initialization loads data and starts tracking', () async {
      await engine.init();

      verify(() => mockStorage.loadDiscoveredPoints()).called(1);
      verify(() => mockStorage.loadStatistics()).called(1);
      verify(() => mockLocation.startTracking()).called(1);
      expect(engine.isRunning, true);
    });

    test('onPosition updates path and stats', () async {
      final posStreamController = StreamController<Position>();
      when(() => mockLocation.positionStream)
          .thenAnswer((_) => posStreamController.stream);
      when(() => mockLandCheck.isLand(any())).thenAnswer((_) async => true);

      await engine.init();

      final pos = Position(
        latitude: 52.52,
        longitude: 13.40,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );

      posStreamController.add(pos);

      // Wait for async processing
      await Future.delayed(Duration.zero);

      expect(engine.pathPoints.length, 1);
      expect(engine.discoveredCentres.length, 1);
      verify(() => mockStorage.savePathPoints(any())).called(1);

      await posStreamController.close();
    });
  });
}
