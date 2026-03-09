// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Expand';

  @override
  String get exploreTab => 'Entdecken';

  @override
  String get statisticsTab => 'Statistiken';

  @override
  String get settingsTab => 'Einstellungen';

  @override
  String get locating => 'Ortung...';

  @override
  String get awaitingGps => 'Warte auf GPS-Signal...';

  @override
  String exploringCity(String city) {
    return 'Entdecke: $city';
  }

  @override
  String inspectingCity(String city) {
    return 'Inspektion: $city';
  }

  @override
  String get statisticsTitle => 'Statistiken';

  @override
  String globalLevel(int level) {
    return 'Globales Entdecker-Level $level';
  }

  @override
  String get totalDistance => 'Gesamtdistanz';

  @override
  String get areaExplored => 'Erkundete Fläche';

  @override
  String get discoveredPoints => 'Entdeckte Punkte';

  @override
  String get citiesExplored => 'Erkundete Städte';

  @override
  String get citiesHeader => 'Städte';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get generalSection => 'Allgemein';

  @override
  String get gpsSection => 'Standort';

  @override
  String get highAccuracy => 'Hochpräzises GPS';

  @override
  String get highAccuracySub => 'Beste Ergebnisse, verbraucht mehr Akku';

  @override
  String get aboutSection => 'Über';

  @override
  String get version => 'Version';

  @override
  String get mapData => 'Kartendaten';

  @override
  String get mapDataVal => '© OpenStreetMap-Mitwirkende';

  @override
  String get geocodingTitle => 'Geokodierung';

  @override
  String get geocodingVal => 'Nominatim / OpenStreetMap';

  @override
  String get manifestoTitle => 'Expand';

  @override
  String get manifestoBody =>
      'Mach jeden Spaziergang zu einem Abenteuer. Entdecke die Welt Schritt für Schritt.';

  @override
  String get resetProgress => 'Fortschritt zurücksetzen';

  @override
  String get resetProgressConfirm =>
      'Bist du sicher, dass du deinen gesamten Fortschritt zurücksetzen möchtest? Dies kann nicht rückgängig gemacht werden.';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get welcomeTitle => 'Willkommen bei Expand';

  @override
  String get welcomeBody =>
      'Entdecke die Welt um dich herum.\nDer Nebel lichtet sich, während du dich bewegst.';

  @override
  String get getStarted => 'Los geht\'s';

  @override
  String get locationPermissionTitle => 'Standortberechtigung';

  @override
  String get locationPermissionBody =>
      'Expand benötigt dauerhaften Zugriff auf den Standort, um den Nebel während des Gehens, Laufens oder Radfahrens zu entfernen.';

  @override
  String get locationRequiredTitle => 'Standort erforderlich';

  @override
  String get locationRequiredBody =>
      'Expand nutzt deinen Standort im Hintergrund, um den Nebel automatisch zu lichten, während du dich bewegst.';

  @override
  String get grantPermission => 'Berechtigung erteilen';

  @override
  String get grantAccess => 'Zugriff gewähren';

  @override
  String get permissionDenied => 'Standortberechtigung verweigert';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get tryAgain => 'Erneut versuchen';
}
