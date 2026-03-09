// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Expand';

  @override
  String get exploreTab => 'Explore';

  @override
  String get statisticsTab => 'Statistics';

  @override
  String get settingsTab => 'Settings';

  @override
  String get locating => 'Locating...';

  @override
  String get awaitingGps => 'Awaiting GPS lock...';

  @override
  String exploringCity(String city) {
    return 'Exploring: $city';
  }

  @override
  String inspectingCity(String city) {
    return 'Inspecting: $city';
  }

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String globalLevel(int level) {
    return 'Global Explorer Level $level';
  }

  @override
  String get totalDistance => 'Total Distance';

  @override
  String get areaExplored => 'Area Explored';

  @override
  String get discoveredPoints => 'Discovered Points';

  @override
  String get citiesExplored => 'Cities Explored';

  @override
  String get citiesHeader => 'Cities';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get generalSection => 'General';

  @override
  String get gpsSection => 'Location';

  @override
  String get highAccuracy => 'High Accuracy GPS';

  @override
  String get highAccuracySub => 'Best results, uses more battery';

  @override
  String get aboutSection => 'About';

  @override
  String get version => 'Version';

  @override
  String get mapData => 'Map Data';

  @override
  String get mapDataVal => '© OpenStreetMap contributors';

  @override
  String get geocodingTitle => 'Geocoding';

  @override
  String get geocodingVal => 'Nominatim / OpenStreetMap';

  @override
  String get manifestoTitle => 'Expand';

  @override
  String get manifestoBody =>
      'Turn every walk into an adventure. Discover the world one step at a time.';

  @override
  String get resetProgress => 'Reset Progress';

  @override
  String get resetProgressConfirm =>
      'Are you sure you want to reset all your exploration progress? This cannot be undone.';

  @override
  String get reset => 'Reset';

  @override
  String get cancel => 'Cancel';

  @override
  String get welcomeTitle => 'Welcome to Expand';

  @override
  String get welcomeBody =>
      'Discover the world around you.\nThe fog clears as you move.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get locationPermissionTitle => 'Location Permission';

  @override
  String get locationPermissionBody =>
      'Expand needs persistent location access to clear the fog of war as you walk, run, or cycle.';

  @override
  String get locationRequiredTitle => 'Location Required';

  @override
  String get locationRequiredBody =>
      'Expand uses your location in the background to automatically clear the fog of war as you move.';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get grantAccess => 'Grant Access';

  @override
  String get permissionDenied => 'Location permission denied';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get tryAgain => 'Try Again';
}
