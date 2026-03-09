import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../models/user_statistics.dart';
import '../../core/app_typography.dart';
import '../../services/exploration_engine.dart';
import '../widgets/exp_stat_card.dart';
import 'app_shell.dart';
import 'home_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  // Let engine handle state dynamically
  @override
  Widget build(BuildContext context) {
    final engine = context.watch<ExplorationEngine>();
    final stats = engine.stats;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.limestone,
      appBar: AppBar(title: Text(l10n.statisticsTitle)),
      body: !engine.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                // ── Global Progress ────────────────────────────────────────
                _SectionHeader(l10n.globalLevel(stats.level)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ExpStatCard(
                        label: l10n.totalDistance,
                        value: _fmtDist(stats.totalDistanceM),
                        unit: stats.totalDistanceM >= 1000 ? 'km' : 'm',
                        icon: Icons.route_outlined,
                        variant: ExpStatCardVariant.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ExpStatCard(
                        label: l10n.areaExplored,
                        value: _fmtArea(stats.totalAreaM2),
                        unit: stats.totalAreaM2 >= 1000000 ? 'km²' : 'm²',
                        icon: Icons.map_outlined,
                        variant: ExpStatCardVariant.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ExpStatCard(
                        label: l10n.discoveredPoints,
                        value: stats.totalDiscoveredPoints.toString(),
                        icon: Icons.location_on_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ExpStatCard(
                        label: l10n.citiesExplored,
                        value: stats.cityStats.length.toString(),
                        icon: Icons.location_city_outlined,
                      ),
                    ),
                  ],
                ),

                // ── Cities List ────────────────────────────────────────
                if (stats.cityStats.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _SectionHeader(l10n.citiesHeader),
                  const SizedBox(height: 10),
                  ..._buildCityCards(context, stats.cityStats),
                ],
              ],
            ),
    );
  }

  List<Widget> _buildCityCards(
    BuildContext context,
    Map<String, CityStats> cityStats,
  ) {
    // Sort by discovered area descending
    final list = cityStats.values.toList()
      ..sort((a, b) => b.discoveredAreaM2.compareTo(a.discoveredAreaM2));

    return list.map((city) {
      // Approximate percentage scaling (placeholder bound)
      const double cityMaxM2 = 25000000;
      final progress = (city.discoveredAreaM2 / cityMaxM2 * 100).clamp(
        0.0,
        100.0,
      );

      return Padding(
        key: ValueKey(city.cityName),
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: () async {
            HapticFeedback.lightImpact();
            try {
              final locs = await locationFromAddress(
                "${city.cityName}, ${city.countryName}",
              );
              if (locs.isNotEmpty && context.mounted) {
                // Switch to Map Tab
                AppShell.of(context)?.switchToMap();

                // Wait a tiny bit for the tab to build/animate
                Future.delayed(const Duration(milliseconds: 300), () {
                  final state = HomeScreen.globalKey.currentState;
                  if (state != null) {
                    state.startInspectionMode(
                      city.cityName,
                      city.countryName,
                      LatLng(locs.first.latitude, locs.first.longitude),
                    );
                  }
                });
              }
            } catch (e) {
              // Ignore failure
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(city.cityName, style: AppTextStyles.headingSmall),
                    Text(
                      '${_fmtPercent(progress)}%',
                      style: AppTextStyles.dataLabel.copyWith(
                        color: AppColors.styrianForest,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  city.countryName,
                  style: AppTypography.dataLabel.copyWith(
                    color: AppColors.slateLight,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(99)),
                  child: LinearProgressIndicator(
                    value: (progress / 100).clamp(0, 1),
                    minHeight: 6,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.glacierMint,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  String _fmtPercent(double p) {
    if (p == 0) return '0.00';
    if (p >= 1) return p.toStringAsFixed(2);
    if (p >= 0.001) return p.toStringAsFixed(3);
    return '<0.01'; // Avoid scientific notation
  }

  String _fmtDist(double m) {
    if (m >= 1000) return (m / 1000).toStringAsFixed(1);
    return m.toInt().toString();
  }

  String _fmtArea(double m2) {
    if (m2 >= 1000000) return (m2 / 1000000).toStringAsFixed(2);
    return m2.toInt().toString();
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.titleLarge);
  }
}
