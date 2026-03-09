// lib/ui/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../exploration/geo_math.dart';
import '../../core/app_typography.dart';
import '../../services/exploration_engine.dart';
import '../widgets/exp_progress_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final GlobalKey<HomeScreenState> globalKey = GlobalKey();

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  String? _inspectingCity;
  String? _inspectingCountry;

  // Memoized map layers
  List<LatLng>? _lastDiscovered;
  List<Polygon>? _memoizedFog;
  List<Polygon>? _memoizedHighlights;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final engine = context.read<ExplorationEngine>();
      engine.addListener(_onEngineUpdate);
    });
  }

  void _onEngineUpdate() {
    final engine = context.read<ExplorationEngine>();
    final pathPts = engine.pathPoints;

    // Only auto-follow if we have moved and we ARE NOT inspecting a city
    if (pathPts.isNotEmpty && _inspectingCity == null) {
      final last = pathPts.last;
      _mapController.move(last, _mapController.camera.zoom);
    }
  }

  void startInspectionMode(String city, String country, LatLng center) {
    setState(() {
      _inspectingCity = city;
      _inspectingCountry = country;
    });
    // Move map to the inspected city
    _mapController.move(center, 13.0);
  }

  void _clearInspection() {
    setState(() {
      _inspectingCity = null;
      _inspectingCountry = null;
    });
    // Snap back to user
    final engine = context.read<ExplorationEngine>();
    if (engine.pathPoints.isNotEmpty) {
      _mapController.move(engine.pathPoints.last, 16.0);
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    try {
      context.read<ExplorationEngine>().removeListener(_onEngineUpdate);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<ExplorationEngine>();
    final pathPts = engine.pathPoints;
    final discovered = engine.discoveredCentres;

    // Use currentPosition explicitly to keep camera glued to user if needed
    final LatLng initialCenter = engine.currentPosition != null
        ? LatLng(
            engine.currentPosition!.latitude,
            engine.currentPosition!.longitude,
          )
        : (pathPts.isNotEmpty
            ? pathPts.last
            : const LatLng(
                52.5200,
                13.4050,
              )); // Default fallback if zero data

    return Scaffold(
      body: Stack(
        children: [
          // ── Base Map ──────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 15,
              minZoom: 3,
              maxZoom: 19,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.expand',
                maxZoom: 19,
              ),
              // ── Fog of war ────────────────────────────────────────────────
              if (discovered.isNotEmpty)
                PolygonLayer(polygons: _buildFogMemoized(discovered)),
              // ── Discovered highlight rings ─────────────────────────────
              if (discovered.isNotEmpty)
                PolygonLayer(
                  polygons: _buildHighlightsMemoized(discovered),
                ),
              // ── Path trace ────────────────────────────────────────────────
              if (pathPts.length > 1)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: pathPts,
                      color: AppColors.styrianForest,
                      strokeWidth: 3.5,
                    ),
                  ],
                ),
              // ── Current location marker ───────────────────────────────────
              if (pathPts.isNotEmpty)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: pathPts.last,
                      width: 40,
                      height: 40,
                      child: AnimatedBuilder(
                        animation: _pulseAnim,
                        builder: (_, __) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.styrianForest.withAlpha(
                              (_pulseAnim.value * 60).toInt(),
                            ),
                            border: Border.all(
                              color: AppColors.styrianForest,
                              width: 2.5,
                            ),
                          ),
                          child: const Center(
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: AppColors.styrianForest,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // ── Top HUD ───────────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Material(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _inspectingCity != null
                      ? _buildInspectionHUD(
                          _inspectingCity!,
                          _inspectingCountry!,
                          engine,
                        )
                      : (engine.currentCity == null
                          ? _buildEmptyHUD(!engine.isInitialized)
                          : _buildContextHUD(
                              engine.currentCity!,
                              engine.currentCountry!,
                              engine,
                            )),
                ),
              ),
            ),
          ),

          // ── Bottom tracking controls ──────────────────────────────────────
          Positioned(
            bottom: 24,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Exit inspection button
                if (_inspectingCity != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _mapFab(
                      icon: Icons.close,
                      onTap: () {
                        _clearInspection();
                      },
                    ),
                  ),
                // Location Tracking visual lock
                _mapFab(
                  icon: Icons.my_location,
                  primary: true,
                  onTap: () {
                    if (!engine.isRunning) {
                      engine.autoStartTracking();
                    }
                    if (_inspectingCity != null) _clearInspection();
                    if (engine.pathPoints.isNotEmpty) {
                      _mapController.move(engine.pathPoints.last, 17.0);
                    }
                  },
                ),
              ],
            ),
          ),

          // ── Permission error banner ───────────────────────────────────────
          if (engine.permissionError != null)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: Material(
                color: AppColors.kaiserRed,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    engine.permissionError!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyHUD(bool initializing) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        const Icon(
          Icons.explore_outlined,
          color: AppColors.slateLight,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            initializing ? l10n.locating : l10n.awaitingGps,
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildInspectionHUD(
    String city,
    String country,
    ExplorationEngine engine,
  ) {
    final l10n = AppLocalizations.of(context)!;
    double progress = 0.0;
    if (engine.stats.cityStats.containsKey(city)) {
      final cityData = engine.stats.cityStats[city]!;
      const double fakeCityAreaM2 = 25000000;
      progress = (cityData.discoveredAreaM2 / fakeCityAreaM2 * 100).clamp(
        0,
        100,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.saved_search,
                  color: AppColors.styrianForest,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.inspectingCity(city),
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.styrianForest,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Text(
              country,
              style: AppTextStyles.label.copyWith(color: AppColors.slateLight),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ExpProgressBar(percent: progress),
      ],
    );
  }

  Widget _buildContextHUD(
    String city,
    String country,
    ExplorationEngine engine,
  ) {
    final l10n = AppLocalizations.of(context)!;
    // Dynamically look up progress
    double progress = 0.0;
    if (engine.stats.cityStats.containsKey(city)) {
      final cityData = engine.stats.cityStats[city]!;
      // Roughly approximate max city area so percentage climbs visibly
      // Eventually we would bound this properly or fetch real city area via Nominatim
      const double fakeCityAreaM2 = 25000000;
      progress = (cityData.discoveredAreaM2 / fakeCityAreaM2 * 100).clamp(
        0,
        100,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.exploringCity(city),
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.styrianForest,
                fontSize: 15,
              ),
            ),
            Text(
              country,
              style: AppTextStyles.label.copyWith(color: AppColors.slateLight),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ExpProgressBar(percent: progress),
      ],
    );
  }

  Widget _mapFab({
    required IconData icon,
    required VoidCallback onTap,
    bool primary = false,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: primary ? 56 : 44,
        height: primary ? 56 : 44,
        decoration: BoxDecoration(
          color: primary ? AppColors.styrianForest : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(
            color: primary ? AppColors.styrianForest : AppColors.border,
          ),
        ),
        child: Icon(
          icon,
          color: primary ? Colors.white : AppColors.slate,
          size: primary ? 28 : 22,
        ),
      ),
    );
  }

  // ── Fog of war layers (Memoized) ──────────────────────────────────────────

  List<Polygon> _buildHighlightsMemoized(List<LatLng> centres) {
    if (_lastDiscovered == centres && _memoizedHighlights != null) {
      return _memoizedHighlights!;
    }
    _memoizedHighlights = _buildDiscoveredHighlights(centres);
    _lastDiscovered = centres;
    return _memoizedHighlights!;
  }

  List<Polygon> _buildFogMemoized(List<LatLng> centres) {
    if (_lastDiscovered == centres && _memoizedFog != null) {
      return _memoizedFog!;
    }
    _memoizedFog = _buildFog(centres);
    _lastDiscovered = centres;
    return _memoizedFog!;
  }

  /// Creates the discovered highlight rings (subtle Forest tint circles).
  List<Polygon> _buildDiscoveredHighlights(List<LatLng> centres) {
    return centres.map((c) {
      final pts = GeoMath.circleToPolygon(c, GeoMath.discoveryRadius);
      return Polygon(
        points: pts,
        color: AppColors.styrianForest.withAlpha(15),
        isFilled: true,
      );
    }).toList();
  }

  /// Fog overlay: a huge covering polygon with holes for discovered circles.
  /// flutter_map renders polygon holes via holePointsList.
  List<Polygon> _buildFog(List<LatLng> centres) {
    // Outer cover: massive rectangle
    const cover = [
      LatLng(-85, -180),
      LatLng(-85, 180),
      LatLng(85, 180),
      LatLng(85, -180),
    ];

    final holes = centres
        .map((c) => GeoMath.circleToPolygon(c, GeoMath.discoveryRadius))
        .toList();

    return [
      Polygon(
        points: cover,
        holePointsList: holes,
        color: AppColors.fogOverlay,
        isFilled: true,
      ),
    ];
  }
}
