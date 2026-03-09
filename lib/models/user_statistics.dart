// lib/models/user_statistics.dart

class CityStats {
  final String cityName;
  final String countryName;
  double discoveredAreaM2;
  int discoveredPointsCount;

  CityStats({
    required this.cityName,
    required this.countryName,
    this.discoveredAreaM2 = 0,
    this.discoveredPointsCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'cityName': cityName,
        'countryName': countryName,
        'discoveredAreaM2': discoveredAreaM2,
        'discoveredPointsCount': discoveredPointsCount,
      };

  factory CityStats.fromJson(Map<String, dynamic> j) => CityStats(
        cityName: j['cityName'] as String,
        countryName: j['countryName'] as String,
        discoveredAreaM2: (j['discoveredAreaM2'] as num).toDouble(),
        discoveredPointsCount: j['discoveredPointsCount'] as int,
      );
}

class UserStatistics {
  double totalDistanceM;
  double totalAreaM2;
  int totalSessions; // Deprecated, kept for legacy compat
  double longestWalkM;
  int totalDiscoveredPoints;

  // Track stats per city globally
  Map<String, CityStats> cityStats;

  // Legacy compat
  Map<String, double> regionProgress;

  UserStatistics({
    this.totalDistanceM = 0,
    this.totalAreaM2 = 0,
    this.totalSessions = 0,
    this.longestWalkM = 0,
    this.totalDiscoveredPoints = 0,
    Map<String, double>? regionProgress,
    Map<String, CityStats>? cityStats,
  })  : regionProgress = regionProgress ?? {},
        cityStats = cityStats ?? {};

  double get totalDistanceKm => totalDistanceM / 1000;
  double get totalAreaKm2 => totalAreaM2 / 1e6;

  int get level =>
      (totalAreaM2 / 50000).floor() + 1; // 1 level per 50,000 sq meters

  void addCityArea(String city, String country, double areaM2,
      {bool incrementPoints = true}) {
    if (!cityStats.containsKey(city)) {
      cityStats[city] = CityStats(cityName: city, countryName: country);
    }
    cityStats[city]!.discoveredAreaM2 += areaM2;
    if (incrementPoints) {
      cityStats[city]!.discoveredPointsCount += 1;
    }
    totalAreaM2 += areaM2;
  }

  Map<String, dynamic> toJson() => {
        'totalDistanceM': totalDistanceM,
        'totalAreaM2': totalAreaM2,
        'totalSessions': totalSessions,
        'longestWalkM': longestWalkM,
        'totalDiscoveredPoints': totalDiscoveredPoints,
        'regionProgress': regionProgress,
        'cityStats': cityStats.map((k, v) => MapEntry(k, v.toJson())),
      };

  factory UserStatistics.fromJson(Map<String, dynamic> j) => UserStatistics(
        totalDistanceM: (j['totalDistanceM'] as num? ?? 0).toDouble(),
        totalAreaM2: (j['totalAreaM2'] as num? ?? 0).toDouble(),
        totalSessions: (j['totalSessions'] as num? ?? 0).toInt(),
        longestWalkM: (j['longestWalkM'] as num? ?? 0).toDouble(),
        totalDiscoveredPoints:
            (j['totalDiscoveredPoints'] as num? ?? 0).toInt(),
        regionProgress: ((j['regionProgress'] as Map?) ?? {}).map(
          (k, v) => MapEntry(k as String, (v as num).toDouble()),
        ),
        cityStats: ((j['cityStats'] as Map?) ?? {}).map(
          (k, v) => MapEntry(
              k as String, CityStats.fromJson(v as Map<String, dynamic>)),
        ),
      );
}
