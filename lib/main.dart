// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'core/app_theme.dart';
import 'services/exploration_engine.dart';
import 'services/land_check_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'ui/screens/app_shell.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Enable edge-to-edge for modern UI
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialise storage
  final storage = StorageService();
  await storage.init();

  // Build services
  final locationService = LocationService();
  final landCheck = LandCheckService();

  final engine = ExplorationEngine(
    locationService: locationService,
    landCheck: landCheck,
    storage: storage,
  );
  await engine.init(); // Auto-starts GPS inside

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: engine),
        Provider.value(value: storage),
      ],
      child: const ExpandApp(),
    ),
  );
}

class ExpandApp extends StatelessWidget {
  const ExpandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('de', ''),
      ],
      home: Consumer<ExplorationEngine>(
        builder: (context, engine, child) {
          if (!engine.isInitialized) {
            return const SplashScreen();
          }
          final storage = context.read<StorageService>();
          if (!storage.isOnboardingCompleted) {
            return const OnboardingScreen();
          }
          return const AppShell();
        },
      ),
    );
  }
}
