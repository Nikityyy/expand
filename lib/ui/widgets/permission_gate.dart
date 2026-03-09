// lib/ui/widgets/permission_gate.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class PermissionGate extends StatelessWidget {
  final Widget child;

  const PermissionGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkPermission(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.data == true) return child;
        return _PermissionDeniedScreen();
      },
    );
  }

  Future<bool> _checkPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    final p = await Geolocator.checkPermission();
    return p == LocationPermission.always || p == LocationPermission.whileInUse;
  }
}

class _PermissionDeniedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.limestone,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.styrianForest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.location_off_outlined,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 32),
              Text(l10n.locationRequiredTitle, style: AppTextStyles.titleLarge),
              const SizedBox(height: 12),
              Text(l10n.locationRequiredBody, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 40),
              FilledButton.icon(
                onPressed: () => Geolocator.openAppSettings(),
                icon: const Icon(Icons.settings_outlined),
                label: Text(l10n.openSettings),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  await Geolocator.requestPermission();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed('/');
                  }
                },
                child: Text(l10n.tryAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
