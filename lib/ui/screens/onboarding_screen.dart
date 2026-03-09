// lib/ui/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../services/storage_service.dart';
import 'app_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;

  Future<void> _nextStep() async {
    if (_step == 1) {
      // Request location permissions
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enable location services first.'),
            ),
          );
        }
        return;
      }
      var p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) {
        p = await Geolocator.requestPermission();
      }
      if (p == LocationPermission.deniedForever) {
        Geolocator.openAppSettings();
        return;
      }
      if (p == LocationPermission.denied) return;
    }

    if (_step == 1) {
      // Just in case it bypasses the direct handler.
      await context.read<StorageService>().setOnboardingCompleted();
      if (mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const AppShell()));
      }
      return;
    }

    setState(() => _step++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.limestone,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildStepContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _WelcomeStep(onNext: _nextStep);
      case 1:
        return _LocationStep(
          onNext: () async {
            await context.read<StorageService>().setOnboardingCompleted();
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AppShell()),
              );
            }
          },
        );
      default:
        return const SizedBox();
    }
  }
}

class _WelcomeStep extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomeStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      key: const ValueKey('step0'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(l10n.manifestoTitle, style: AppTextStyles.heroNumber),
        const SizedBox(height: 16),
        Text(
          l10n.manifestoBody,
          style: AppTextStyles.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        FilledButton(onPressed: onNext, child: Text(l10n.getStarted)),
      ],
    );
  }
}

class _LocationStep extends StatelessWidget {
  final VoidCallback onNext;
  const _LocationStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      key: const ValueKey('step1'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.styrianForest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.location_on, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 32),
        Text(l10n.locationRequiredTitle, style: AppTextStyles.displayMedium),
        const SizedBox(height: 16),
        Text(
          l10n.locationRequiredBody,
          style: AppTextStyles.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        FilledButton(onPressed: onNext, child: Text(l10n.grantAccess)),
      ],
    );
  }
}
