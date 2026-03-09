import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:expand/exploration/geo_math.dart';

void main() {
  group('GeoMath', () {
    test('haversine calculates distance correctly', () {
      const p1 = LatLng(52.5200, 13.4050); // Berlin
      const p2 = LatLng(52.5200, 13.4060); // ~68m east

      final dist = GeoMath.haversine(p1, p2);
      expect(dist, closeTo(67.8, 1.0));
    });

    test('circleToPolygon returns 32 points by default', () {
      const center = LatLng(45.0, 45.0);
      final poly = GeoMath.circleToPolygon(center, 50.0);

      expect(poly.length, 32);
      expect(poly.first, isNot(poly.last));
    });

    test('accumulatedCircleAreaM2 handles non-overlapping circles', () {
      final centers = [
        const LatLng(0, 0),
        const LatLng(10, 10), // Far away
      ];

      final area = GeoMath.accumulatedCircleAreaM2(centers, radius: 10.0);
      const singleArea = 3.14159 * 100;
      expect(area, closeTo(singleArea * 2, 10.0));
    });

    test('accumulatedCircleAreaM2 handles overlapping circles (heuristic)', () {
      final centers = [
        const LatLng(0, 0),
        const LatLng(0.00001, 0.00001), // Very close
      ];

      final area = GeoMath.accumulatedCircleAreaM2(centers, radius: 50.0);
      const singleArea = 3.14159 * 50 * 50;
      // Heuristic should reject the second point as too close
      expect(area, closeTo(singleArea, 10.0));
    });
  });
}
