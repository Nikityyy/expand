// lib/ui/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _highAccuracy = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.limestone,
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // ── GPS ────────────────────────────────────────────────────────────
          _SectionHeader(l10n.gpsSection),
          const SizedBox(height: 10),
          _SettingsTile(
            icon: Icons.gps_fixed_outlined,
            title: l10n.highAccuracy,
            subtitle: l10n.highAccuracySub,
            trailing: Switch(
              value: _highAccuracy,
              activeThumbColor: AppColors.styrianForest,
              onChanged: (v) => setState(() => _highAccuracy = v),
            ),
          ),
          const SizedBox(height: 24),

          // ── About ──────────────────────────────────────────────────────────
          _SectionHeader(l10n.aboutSection),
          const SizedBox(height: 10),
          _SettingsTile(
            icon: Icons.map_outlined,
            title: l10n.mapData,
            subtitle: l10n.mapDataVal,
          ),
          const SizedBox(height: 4),
          _SettingsTile(
            icon: Icons.location_on_outlined,
            title: l10n.geocodingTitle,
            subtitle: l10n.geocodingVal,
          ),
          const SizedBox(height: 24),

          // ── Manifesto card ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.styrianForest,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.manifestoTitle,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.manifestoBody,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTextStyles.titleLarge);
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.pebble,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Icon(icon, size: 18, color: AppColors.styrianForest),
        ),
        title: Text(title, style: AppTextStyles.headingSmall),
        subtitle: Text(subtitle, style: AppTextStyles.bodyMedium),
        trailing: trailing,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
