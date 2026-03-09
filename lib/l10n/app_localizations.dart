import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get appName;

  /// No description provided for @exploreTab.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreTab;

  /// No description provided for @statisticsTab.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTab;

  /// No description provided for @settingsTab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Locating...'**
  String get locating;

  /// No description provided for @awaitingGps.
  ///
  /// In en, this message translates to:
  /// **'Awaiting GPS lock...'**
  String get awaitingGps;

  /// No description provided for @exploringCity.
  ///
  /// In en, this message translates to:
  /// **'Exploring: {city}'**
  String exploringCity(String city);

  /// No description provided for @inspectingCity.
  ///
  /// In en, this message translates to:
  /// **'Inspecting: {city}'**
  String inspectingCity(String city);

  /// No description provided for @statisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTitle;

  /// No description provided for @globalLevel.
  ///
  /// In en, this message translates to:
  /// **'Global Explorer Level {level}'**
  String globalLevel(int level);

  /// No description provided for @totalDistance.
  ///
  /// In en, this message translates to:
  /// **'Total Distance'**
  String get totalDistance;

  /// No description provided for @areaExplored.
  ///
  /// In en, this message translates to:
  /// **'Area Explored'**
  String get areaExplored;

  /// No description provided for @discoveredPoints.
  ///
  /// In en, this message translates to:
  /// **'Discovered Points'**
  String get discoveredPoints;

  /// No description provided for @citiesExplored.
  ///
  /// In en, this message translates to:
  /// **'Cities Explored'**
  String get citiesExplored;

  /// No description provided for @citiesHeader.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get citiesHeader;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @generalSection.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalSection;

  /// No description provided for @gpsSection.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get gpsSection;

  /// No description provided for @highAccuracy.
  ///
  /// In en, this message translates to:
  /// **'High Accuracy GPS'**
  String get highAccuracy;

  /// No description provided for @highAccuracySub.
  ///
  /// In en, this message translates to:
  /// **'Best results, uses more battery'**
  String get highAccuracySub;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @mapData.
  ///
  /// In en, this message translates to:
  /// **'Map Data'**
  String get mapData;

  /// No description provided for @mapDataVal.
  ///
  /// In en, this message translates to:
  /// **'© OpenStreetMap contributors'**
  String get mapDataVal;

  /// No description provided for @geocodingTitle.
  ///
  /// In en, this message translates to:
  /// **'Geocoding'**
  String get geocodingTitle;

  /// No description provided for @geocodingVal.
  ///
  /// In en, this message translates to:
  /// **'Nominatim / OpenStreetMap'**
  String get geocodingVal;

  /// No description provided for @manifestoTitle.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get manifestoTitle;

  /// No description provided for @manifestoBody.
  ///
  /// In en, this message translates to:
  /// **'Turn every walk into an adventure. Discover the world one step at a time.'**
  String get manifestoBody;

  /// No description provided for @resetProgress.
  ///
  /// In en, this message translates to:
  /// **'Reset Progress'**
  String get resetProgress;

  /// No description provided for @resetProgressConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all your exploration progress? This cannot be undone.'**
  String get resetProgressConfirm;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Expand'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Discover the world around you.\nThe fog clears as you move.'**
  String get welcomeBody;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Permission'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Expand needs persistent location access to clear the fog of war as you walk, run, or cycle.'**
  String get locationPermissionBody;

  /// No description provided for @locationRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Required'**
  String get locationRequiredTitle;

  /// No description provided for @locationRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'Expand uses your location in the background to automatically clear the fog of war as you move.'**
  String get locationRequiredBody;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// No description provided for @grantAccess.
  ///
  /// In en, this message translates to:
  /// **'Grant Access'**
  String get grantAccess;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get permissionDenied;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
