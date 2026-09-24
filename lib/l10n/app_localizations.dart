import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('es'),
  ];

  /// Home tab title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// Plan tab title
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get tabPlan;

  /// Progress tab title
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get tabProgress;

  /// Nutrition tab title
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get tabNutrition;

  /// Profile tab title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// PAR-Q Assessment screen title
  ///
  /// In en, this message translates to:
  /// **'PAR-Q Assessment'**
  String get onboardingParqTitle;

  /// Subtitle for PAR-Q screen
  ///
  /// In en, this message translates to:
  /// **'Cardiovascular fitness'**
  String get onboardingParqSubtitle;

  /// Description text explaining the purpose of PAR-Q
  ///
  /// In en, this message translates to:
  /// **'Answer honestly. These 7 questions determine if it\'s safe for you to start training without medical supervision.'**
  String get onboardingParqDesc;

  /// Validation badge text
  ///
  /// In en, this message translates to:
  /// **'Internationally validated · Mandatory'**
  String get onboardingParqValidated;

  /// Label indicating the current question and the total number of questions
  ///
  /// In en, this message translates to:
  /// **'Question {index} of {total}'**
  String onboardingParqQuestionLabel(int index, int total);

  /// Yes confirmation
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No confirmation
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Sport selection screen header
  ///
  /// In en, this message translates to:
  /// **'Select your main discipline'**
  String get onboardingSportSelectionHeader;

  /// General settings screen title
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsTitle;

  /// Appearance section label
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get settingsSectionAppearance;

  /// Dark mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsDarkMode;

  /// Language and units section label
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE AND UNITS'**
  String get settingsSectionLanguageUnits;

  /// Language selector label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Distance selector label
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get settingsDistance;

  /// Privacy section label
  ///
  /// In en, this message translates to:
  /// **'PRIVACY'**
  String get settingsSectionPrivacy;

  /// Privacy policy label
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacyPolicy;

  /// Terms and conditions label
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get settingsTermsConditions;

  /// Save changes button label
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get settingsSaveChanges;

  /// Settings saved success message
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSavedSuccess;

  /// General continue button on onboarding flow
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// Error message when saving onboarding data fails
  ///
  /// In en, this message translates to:
  /// **'Error saving ({statusCode})'**
  String onboardingSaveError(int statusCode);

  /// PARQ results screen clear state title
  ///
  /// In en, this message translates to:
  /// **'You\'re ready to train!'**
  String get onboardingParqClearTitle;

  /// PARQ results screen clear state description
  ///
  /// In en, this message translates to:
  /// **'You answered No to all questions. You can safely start your training plan.'**
  String get onboardingParqClearDesc;

  /// First green bullet on clear parq results screen
  ///
  /// In en, this message translates to:
  /// **'No cardiovascular contraindications detected'**
  String get onboardingParqClearBullet1;

  /// Second green bullet on clear parq results screen
  ///
  /// In en, this message translates to:
  /// **'No joint or muscle risk factors'**
  String get onboardingParqClearBullet2;

  /// Third green bullet on clear parq results screen
  ///
  /// In en, this message translates to:
  /// **'No active cardiovascular medication'**
  String get onboardingParqClearBullet3;

  /// Title for confirmation section on clear parq results screen
  ///
  /// In en, this message translates to:
  /// **'Responsibility confirmation'**
  String get onboardingParqClearConfirmTitle;

  /// Description for confirmation section on clear parq results screen
  ///
  /// In en, this message translates to:
  /// **'By continuing, you confirm that the information provided is correct and that you are fit to start a physical training program.'**
  String get onboardingParqClearConfirmDesc;

  /// Label for confirmation checkbox on clear parq results screen
  ///
  /// In en, this message translates to:
  /// **'I confirm that the information is correct and I am fit to train.'**
  String get onboardingParqClearCheckboxLabel;

  /// PARQ results screen warning state title
  ///
  /// In en, this message translates to:
  /// **'Medical consultation required'**
  String get onboardingParqWarningTitle;

  /// Subtitle for PARQ warning screen
  ///
  /// In en, this message translates to:
  /// **'Before starting your plan'**
  String get onboardingParqWarningSubtitle;

  /// Description on warning parq results screen
  ///
  /// In en, this message translates to:
  /// **'One or more of your answers indicates that you must speak with a doctor before starting an exercise program. This is for your safety — it does not mean you cannot train.'**
  String get onboardingParqWarningDesc;

  /// Title listing the answers that triggered parq alert
  ///
  /// In en, this message translates to:
  /// **'Answers that triggered the alert'**
  String get onboardingParqWarningAlertTitle;

  /// Instructions header on warning parq results screen
  ///
  /// In en, this message translates to:
  /// **'What should you do?'**
  String get onboardingParqWarningHelpTitle;

  /// Instructions content on warning parq results screen
  ///
  /// In en, this message translates to:
  /// **'Consult a doctor before starting. Show them this result. Once you get their authorization, you will be able to activate your plan from Fitnflai.'**
  String get onboardingParqWarningHelpDesc;

  /// Button to confirm understanding of warning
  ///
  /// In en, this message translates to:
  /// **'Understood · I will consult with my doctor'**
  String get onboardingParqWarningUnderstoodButton;

  /// Title of override section on warning parq results screen
  ///
  /// In en, this message translates to:
  /// **'Do you want to continue anyway?'**
  String get onboardingParqWarningOverrideTitle;

  /// Description of override section on warning parq results screen
  ///
  /// In en, this message translates to:
  /// **'If you already have medical authorization or consider that your answer was an error, you can declare it here. Fitnflai is not responsible if you continue without consulting a professional.'**
  String get onboardingParqWarningOverrideDesc;

  /// Override checkbox label on warning parq results screen
  ///
  /// In en, this message translates to:
  /// **'I have medical authorization and assume the responsibility to continue with the program'**
  String get onboardingParqWarningOverrideCheckboxLabel;

  /// Sport selection confirmation
  ///
  /// In en, this message translates to:
  /// **'{sport} selected'**
  String onboardingSportSelected(String sport);

  /// Title of week duration picker
  ///
  /// In en, this message translates to:
  /// **'How many weeks\ndo you want your plan to last'**
  String get onboardingSportWeeksDurationTitle;

  /// Obligatory badge label
  ///
  /// In en, this message translates to:
  /// **'Mandatory'**
  String get onboardingSportObligatory;

  /// Weeks slider display value
  ///
  /// In en, this message translates to:
  /// **'{weeks} weeks'**
  String onboardingSportWeeks(int weeks);

  /// Slider edge label
  ///
  /// In en, this message translates to:
  /// **'{weeks} wk'**
  String onboardingSportWeeksLabel(int weeks);

  /// Minimum recommended weeks display under slider
  ///
  /// In en, this message translates to:
  /// **'min. recommended: {weeks} wk'**
  String onboardingSportMinRecommended(int weeks);

  /// Alert title when weeks chosen are below recommended
  ///
  /// In en, this message translates to:
  /// **'Very tight schedule'**
  String get onboardingSportTimeTight;

  /// Alert details when weeks chosen are below recommended
  ///
  /// In en, this message translates to:
  /// **'For your level and discipline, we recommend at least {weeks} weeks. With less time, the risk of overtraining and injuries increases considerably.'**
  String onboardingSportTimeTightDesc(int weeks);

  /// Accept risk checkbox label
  ///
  /// In en, this message translates to:
  /// **'I understand the risk and wish to continue under my own responsibility.'**
  String get onboardingSportTimeTightCheckbox;

  /// Obligatory banner notice text
  ///
  /// In en, this message translates to:
  /// **'This step is mandatory — it defines the structure of your plan.'**
  String get onboardingSportObligatoryBanner;

  /// Trail running sport title
  ///
  /// In en, this message translates to:
  /// **'Trail running'**
  String get onboardingSportTrailRunning;

  /// Trail running sport subtitle
  ///
  /// In en, this message translates to:
  /// **'Mountain and trail running.'**
  String get onboardingSportTrailRunningSubtitle;

  /// Triathlon sport title
  ///
  /// In en, this message translates to:
  /// **'Triathlon'**
  String get onboardingSportTriathlon;

  /// Triathlon sport subtitle
  ///
  /// In en, this message translates to:
  /// **'Swim, bike, run.'**
  String get onboardingSportTriathlonSubtitle;

  /// Road cycling sport title
  ///
  /// In en, this message translates to:
  /// **'Road cycling'**
  String get onboardingSportRoadCycling;

  /// Road cycling sport subtitle
  ///
  /// In en, this message translates to:
  /// **'Road and speed.'**
  String get onboardingSportRoadCyclingSubtitle;

  /// MTB sport title
  ///
  /// In en, this message translates to:
  /// **'MTB'**
  String get onboardingSportMtb;

  /// MTB sport subtitle
  ///
  /// In en, this message translates to:
  /// **'Mountain biking.'**
  String get onboardingSportMtbSubtitle;

  /// Hiking sport title
  ///
  /// In en, this message translates to:
  /// **'Hiking'**
  String get onboardingSportHiking;

  /// Hiking sport subtitle
  ///
  /// In en, this message translates to:
  /// **'Hiking and trekking.'**
  String get onboardingSportHikingSubtitle;

  /// Conditioning sport title
  ///
  /// In en, this message translates to:
  /// **'Conditioning'**
  String get onboardingSportConditioning;

  /// Conditioning sport subtitle
  ///
  /// In en, this message translates to:
  /// **'Fitness and general strength.'**
  String get onboardingSportConditioningSubtitle;

  /// Competition goal title
  ///
  /// In en, this message translates to:
  /// **'Prepare for a competition'**
  String get onboardingSportPrepRace;

  /// Competition goal subtitle
  ///
  /// In en, this message translates to:
  /// **'I have a target date in mind'**
  String get onboardingSportPrepRaceSubtitle;

  /// Time improvement goal title
  ///
  /// In en, this message translates to:
  /// **'Improve my personal time'**
  String get onboardingSportImproveTime;

  /// Time improvement goal subtitle
  ///
  /// In en, this message translates to:
  /// **'I already compete, I want to be faster'**
  String get onboardingSportImproveTimeSubtitle;

  /// General condition goal title
  ///
  /// In en, this message translates to:
  /// **'Improve my general condition'**
  String get onboardingSportImproveCondition;

  /// General condition goal subtitle
  ///
  /// In en, this message translates to:
  /// **'No specific competition for now'**
  String get onboardingSportImproveConditionSubtitle;

  /// Form title for competition details
  ///
  /// In en, this message translates to:
  /// **'Give us your competition details'**
  String get onboardingSportFormRaceData;

  /// Form description for competition details
  ///
  /// In en, this message translates to:
  /// **'Your plan will be structured in phases so that you arrive in your best shape on the day of the competition.'**
  String get onboardingSportFormRaceDataDesc;

  /// Form title for time improvement details
  ///
  /// In en, this message translates to:
  /// **'What time do you want to improve'**
  String get onboardingSportFormTimeImprove;

  /// Form title for general condition details
  ///
  /// In en, this message translates to:
  /// **'What do you want to improve'**
  String get onboardingSportFormImprove;

  /// Label of competition drop-down
  ///
  /// In en, this message translates to:
  /// **'Competition'**
  String get onboardingSportDropdownRace;

  /// Hint text of competition drop-down
  ///
  /// In en, this message translates to:
  /// **'Select your competition'**
  String get onboardingSportDropdownSelectRace;

  /// Disabled dropdown message
  ///
  /// In en, this message translates to:
  /// **'Select a discipline first'**
  String get onboardingSportDropdownSelectSportFirst;

  /// Label of competition name field
  ///
  /// In en, this message translates to:
  /// **'Competition name'**
  String get onboardingSportRaceName;

  /// Hint of competition name field
  ///
  /// In en, this message translates to:
  /// **'E.g.: Ultra Trail del Sur'**
  String get onboardingSportRaceNameHint;

  /// Label of date field
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get onboardingSportDate;

  /// Hint / button of date selection
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get onboardingSportSelectDate;

  /// Label of distance field
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get onboardingSportDistance;

  /// Hint of distance field
  ///
  /// In en, this message translates to:
  /// **'E.g.: 15'**
  String get onboardingSportDistanceHint;

  /// Notice of weeks available until race
  ///
  /// In en, this message translates to:
  /// **'{weeks} weeks available · Adjusted plan'**
  String onboardingSportRaceWeeksAvailable(int weeks);

  /// Risk alert header
  ///
  /// In en, this message translates to:
  /// **'Insufficient time to prepare'**
  String get onboardingSportRaceWeeksRequiredTitle;

  /// Risk alert detail description
  ///
  /// In en, this message translates to:
  /// **'You have {weeksAvailable} weeks until one day before your competition, but for your level you need at least {weeksRequired}. With this time the risk of injury is high and we cannot guarantee that you will arrive in the best conditions.'**
  String onboardingSportRaceWeeksRequiredDesc(
    int weeksAvailable,
    int weeksRequired,
  );

  /// Reassuring message under risk alert
  ///
  /// In en, this message translates to:
  /// **'Even so, we can help you prepare in the best possible way within the available time. 💪'**
  String get onboardingSportRaceWeeksRequiredNote;

  /// Risk acceptance checkbox label
  ///
  /// In en, this message translates to:
  /// **'I understand the risks and assume responsibility. I want to continue with the preparation on my own.'**
  String get onboardingSportRaceWeeksRequiredCheckbox;

  /// Label for actual time picker
  ///
  /// In en, this message translates to:
  /// **'Actual time'**
  String get onboardingSportActualTime;

  /// Label for target time picker
  ///
  /// In en, this message translates to:
  /// **'Target time'**
  String get onboardingSportTargetTime;

  /// Notice describing plan adaptation for time improvement
  ///
  /// In en, this message translates to:
  /// **'Your plan will be structured in phases so you improve your time progressively.'**
  String get onboardingSportActualTimeDesc;

  /// Error when target time is slower than actual
  ///
  /// In en, this message translates to:
  /// **'Target time must be less than actual time. Your goal is to improve your record.'**
  String get onboardingSportTargetTimeError;

  /// Dropdown label for general condition
  ///
  /// In en, this message translates to:
  /// **'What do you want to improve?'**
  String get onboardingSportWhatToImprove;

  /// Dropdown hint for category
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get onboardingSportSelectCategory;

  /// Dropdown label for subcategory
  ///
  /// In en, this message translates to:
  /// **'What is your specific goal?'**
  String get onboardingSportSpecificGoal;

  /// Dropdown hint for subcategory
  ///
  /// In en, this message translates to:
  /// **'Select a goal'**
  String get onboardingSportSelectGoal;

  /// General description under subcategory selection
  ///
  /// In en, this message translates to:
  /// **'Your plan will be structured in phases to achieve your goal progressively.'**
  String get onboardingSportGeneralConditionDesc;

  /// Title of basic profile section
  ///
  /// In en, this message translates to:
  /// **'Basic profile'**
  String get onboardingProfileBasicTitle;

  /// Label for birthdate field
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get onboardingProfileBirthdate;

  /// Placeholder for birthdate field
  ///
  /// In en, this message translates to:
  /// **'DD / MM / YYYY'**
  String get onboardingProfileBirthdateHint;

  /// Label for gender selection
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get onboardingProfileGender;

  /// Male gender option label
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get onboardingProfileGenderMale;

  /// Female gender option label
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get onboardingProfileGenderFemale;

  /// Title of body metrics section
  ///
  /// In en, this message translates to:
  /// **'Body metrics'**
  String get onboardingProfileMetricsTitle;

  /// Label for current weight field
  ///
  /// In en, this message translates to:
  /// **'Current weight'**
  String get onboardingProfileWeight;

  /// Label for height field
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get onboardingProfileHeight;

  /// Title of city and altitude section
  ///
  /// In en, this message translates to:
  /// **'City and altitude'**
  String get onboardingProfileCityTitle;

  /// Label for city search field
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get onboardingProfileCity;

  /// Hint text for city search field
  ///
  /// In en, this message translates to:
  /// **'Search city...'**
  String get onboardingProfileCityHint;

  /// Text displayed when loading elevation data
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get onboardingProfileCitySearching;

  /// Label for altitude field
  ///
  /// In en, this message translates to:
  /// **'Altitude'**
  String get onboardingProfileAltitude;

  /// Hint text for altitude field
  ///
  /// In en, this message translates to:
  /// **'E.g.: 2850'**
  String get onboardingProfileAltitudeHint;

  /// Title of smart altitude banner
  ///
  /// In en, this message translates to:
  /// **'Smart altitude activated'**
  String get onboardingProfileAltitudeActiveTitle;

  /// Description of smart altitude banner
  ///
  /// In en, this message translates to:
  /// **'Your plan adjusts HR zones, hydration, and recovery for {altitude}m a.s.l.'**
  String onboardingProfileAltitudeActiveDesc(String altitude);

  /// Simple description of smart altitude banner when value is unknown
  ///
  /// In en, this message translates to:
  /// **'Your plan adjusts HR zones, hydration, and recovery according to your altitude.'**
  String get onboardingProfileAltitudeActiveDescSimple;

  /// Indicator of active altitude correction
  ///
  /// In en, this message translates to:
  /// **'🏔️  {altitude} m a.s.l. · Active correction'**
  String onboardingProfileAltitudeCorrection(String altitude);

  /// Simple indicator of active altitude correction when value is unknown
  ///
  /// In en, this message translates to:
  /// **'🏔️  Active correction'**
  String get onboardingProfileAltitudeCorrectionSimple;

  /// Title of female cycle section
  ///
  /// In en, this message translates to:
  /// **'Female cycle'**
  String get onboardingProfileMenstrualTitle;

  /// Label for menstrual cycle load adaptation switch
  ///
  /// In en, this message translates to:
  /// **'Activate load adaptation'**
  String get onboardingProfileMenstrualToggle;

  /// Description of menstrual cycle load adaptation
  ///
  /// In en, this message translates to:
  /// **'If you activate it, Fitnflai will adapt the intensity of the plan according to the phases of your menstrual cycle.'**
  String get onboardingProfileMenstrualDesc;

  /// Header for last menstrual cycle dates
  ///
  /// In en, this message translates to:
  /// **'Last cycle'**
  String get onboardingProfileMenstrualLastCycle;

  /// Label for cycle start date picker
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardingProfileMenstrualCycleStart;

  /// Label for cycle end date picker
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get onboardingProfileMenstrualCycleEnd;

  /// General select label
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get onboardingProfileMenstrualSelect;

  /// Hint text when dates are not chosen
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get onboardingProfileMenstrualSelectDates;

  /// Menstrual cycle range indicator text
  ///
  /// In en, this message translates to:
  /// **'From {start} to {end} of {month}'**
  String onboardingProfileMenstrualRange(int start, int end, String month);

  /// Optional badge label
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get onboardingProfileOptional;

  /// Title of current activity level section
  ///
  /// In en, this message translates to:
  /// **'Current activity level'**
  String get onboardingFitnessActivityTitle;

  /// Title of session time selection section
  ///
  /// In en, this message translates to:
  /// **'Time per session'**
  String get onboardingFitnessSessionTitle;

  /// Title of equipment availability section
  ///
  /// In en, this message translates to:
  /// **'Available equipment'**
  String get onboardingFitnessEquipmentTitle;

  /// Title of available days section
  ///
  /// In en, this message translates to:
  /// **'Available days'**
  String get onboardingFitnessDaysTitle;

  /// Prompt when no days are selected
  ///
  /// In en, this message translates to:
  /// **'Select at least one day'**
  String get onboardingFitnessDaysSelectAtLeastOne;

  /// Count of days selected (singular)
  ///
  /// In en, this message translates to:
  /// **'{count} day selected'**
  String onboardingFitnessDaysSelected(int count);

  /// Count of days selected (plural)
  ///
  /// In en, this message translates to:
  /// **'{count} days selected'**
  String onboardingFitnessDaysSelectedPlural(int count);

  /// Title of desired start date section
  ///
  /// In en, this message translates to:
  /// **'When do you want to start'**
  String get onboardingFitnessStartTitle;

  /// Label for start date selector
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get onboardingFitnessStartDate;

  /// Select text for buttons
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get onboardingFitnessSelect;

  /// Title of sports experience section
  ///
  /// In en, this message translates to:
  /// **'Sports experience'**
  String get onboardingFitnessExperienceTitle;

  /// Label for currently active prompt
  ///
  /// In en, this message translates to:
  /// **'Do you exercise currently?'**
  String get onboardingFitnessExercisingNow;

  /// Dropdown label for years active
  ///
  /// In en, this message translates to:
  /// **'Years training'**
  String get onboardingFitnessYearsTraining;

  /// Dropdown label for inactivity duration
  ///
  /// In en, this message translates to:
  /// **'Since when do you not exercise?'**
  String get onboardingFitnessInactivityDuration;

  /// Label for prior competition switch
  ///
  /// In en, this message translates to:
  /// **'Have you competed before?'**
  String get onboardingFitnessCompetedBefore;

  /// Title of health and medical conditions section
  ///
  /// In en, this message translates to:
  /// **'Injuries and conditions'**
  String get onboardingBodyInjuriesTitle;

  /// Label for active injuries switch
  ///
  /// In en, this message translates to:
  /// **'Active injuries?'**
  String get onboardingBodyInjuryActive;

  /// Label for active injury description field
  ///
  /// In en, this message translates to:
  /// **'Description of the discomfort'**
  String get onboardingBodyInjuryDesc;

  /// Placeholder for active injury description
  ///
  /// In en, this message translates to:
  /// **'E.g.: Patellofemoral pain syndrome, hurts when going down slopes'**
  String get onboardingBodyInjuryDescHint;

  /// Label for active injury affected zone field
  ///
  /// In en, this message translates to:
  /// **'Affected area'**
  String get onboardingBodyInjuryZone;

  /// Placeholder for active injury affected zone
  ///
  /// In en, this message translates to:
  /// **'E.g.: Right Knee'**
  String get onboardingBodyInjuryZoneHint;

  /// Label for injury type selection
  ///
  /// In en, this message translates to:
  /// **'Type of injury'**
  String get onboardingBodyInjuryType;

  /// Active injury chip label
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get onboardingBodyInjuryTypeActive;

  /// Chronic injury chip label
  ///
  /// In en, this message translates to:
  /// **'Chronic'**
  String get onboardingBodyInjuryTypeChronic;

  /// Label for pain visual analog scale
  ///
  /// In en, this message translates to:
  /// **'Pain level (VAS: 1–10)'**
  String get onboardingBodyInjuryPainLevel;

  /// Label for recent surgery switch
  ///
  /// In en, this message translates to:
  /// **'Recent surgeries (last year)?'**
  String get onboardingBodySurgery;

  /// Placeholder for surgery detail field
  ///
  /// In en, this message translates to:
  /// **'Which one? E.g.: meniscus, shoulder...'**
  String get onboardingBodySurgeryHint;

  /// Label for chronic pain switch
  ///
  /// In en, this message translates to:
  /// **'Chronic or recurring pain?'**
  String get onboardingBodyPainChronic;

  /// Placeholder for chronic pain detail field
  ///
  /// In en, this message translates to:
  /// **'Where? E.g.: lumbar, hip...'**
  String get onboardingBodyPainChronicHint;

  /// Label for cardiovascular condition switch
  ///
  /// In en, this message translates to:
  /// **'Diagnosed cardiovascular condition?'**
  String get onboardingBodyCardio;

  /// Placeholder for cardiovascular condition detail
  ///
  /// In en, this message translates to:
  /// **'Which one? E.g.: hypertension, arrhythmia...'**
  String get onboardingBodyCardioHint;

  /// Title of optional body composition section
  ///
  /// In en, this message translates to:
  /// **'Do you have body composition data?'**
  String get onboardingBodyCompositionTitle;

  /// Description of bioimpedance scale reports feature
  ///
  /// In en, this message translates to:
  /// **'If you have a smart scale or bioimpedance report, Fitnflai automatically extracts the data to better customize your plan.'**
  String get onboardingBodyCompositionDesc;

  /// Title of upload card
  ///
  /// In en, this message translates to:
  /// **'Upload report'**
  String get onboardingBodyUploadTitle;

  /// Loading state during OCR analysis
  ///
  /// In en, this message translates to:
  /// **'Processing report...'**
  String get onboardingBodyUploadProcessing;

  /// Upload area placeholder text
  ///
  /// In en, this message translates to:
  /// **'Upload your scale report'**
  String get onboardingBodyUploadScaleHint;

  /// Upload area benefits description
  ///
  /// In en, this message translates to:
  /// **'Fitnflai extracts % fat, muscle, body water and BMR to better calibrate your plan.'**
  String get onboardingBodyUploadScaleDesc;

  /// Upload image button label
  ///
  /// In en, this message translates to:
  /// **'Upload photo'**
  String get onboardingBodyUploadImageBtn;

  /// Upload PDF button label
  ///
  /// In en, this message translates to:
  /// **'Upload PDF'**
  String get onboardingBodyUploadPdfBtn;

  /// Remove uploaded file button
  ///
  /// In en, this message translates to:
  /// **'✕  Delete file'**
  String get onboardingBodyUploadDeleteBtn;

  /// Informational banner at bottom of health screen
  ///
  /// In en, this message translates to:
  /// **'This step is completely optional. You can add these details later from your profile.'**
  String get onboardingBodyOptionalNote;

  /// Snackbar success message for scale upload
  ///
  /// In en, this message translates to:
  /// **'✅ File uploaded successfully'**
  String get onboardingBodyUploadSuccess;

  /// Modal sheet success header
  ///
  /// In en, this message translates to:
  /// **'Report processed successfully'**
  String get onboardingBodyUploadProcessedSuccess;

  /// Modal sheet data subtitle
  ///
  /// In en, this message translates to:
  /// **'Data extracted from your scale:'**
  String get onboardingBodyUploadScaleDataExtracted;

  /// OCR Extraction successful dialog title
  ///
  /// In en, this message translates to:
  /// **'Report processed successfully'**
  String get onboardingBodyUploadSuccessDialogTitle;

  /// OCR Extraction error dialog title
  ///
  /// In en, this message translates to:
  /// **'Could not process'**
  String get onboardingBodyUploadErrorDialogTitle;

  /// OCR Extraction error dialog description
  ///
  /// In en, this message translates to:
  /// **'It was not possible to extract the data from the report. Make sure the file is readable and try again.'**
  String get onboardingBodyUploadErrorDialogDesc;

  /// OCR Extraction error dialog cancel option
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get onboardingBodyUploadErrorDialogCancel;

  /// OCR Extraction error dialog retry option
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get onboardingBodyUploadErrorDialogRetry;

  /// Plan generation screen header
  ///
  /// In en, this message translates to:
  /// **'Generating your custom plan'**
  String get onboardingGeneratingPlanTitle;

  /// Plan generation state subtitle
  ///
  /// In en, this message translates to:
  /// **'We are working on your plan.'**
  String get onboardingGeneratingWorking;

  /// Plan generation details subtitle
  ///
  /// In en, this message translates to:
  /// **'Analyzing your data and structuring your plan'**
  String get onboardingGeneratingAnalyzing;

  /// Plan generation progress step 1
  ///
  /// In en, this message translates to:
  /// **'✓ PAR-Q saved\nsuccessfully'**
  String get onboardingGeneratingStepParq;

  /// Plan generation progress step 2
  ///
  /// In en, this message translates to:
  /// **'✓ User data\nsaved successfully'**
  String get onboardingGeneratingStepUserProfile;

  /// Plan generation progress step 3
  ///
  /// In en, this message translates to:
  /// **'✓ Physical data\nsaved successfully'**
  String get onboardingGeneratingStepPhysical;

  /// Plan generation progress step 4
  ///
  /// In en, this message translates to:
  /// **'✓ Physical state and availability\nsaved successfully'**
  String get onboardingGeneratingStepFitness;

  /// Plan generation progress step 5
  ///
  /// In en, this message translates to:
  /// **'✓ Medical history and injuries\nsaved successfully'**
  String get onboardingGeneratingStepMedical;

  /// Plan generation progress step 6
  ///
  /// In en, this message translates to:
  /// **'✓ Functional test\nsaved successfully'**
  String get onboardingGeneratingStepFunctionalTest;

  /// Plan generation progress step 7 (active)
  ///
  /// In en, this message translates to:
  /// **'Structuring phases of your plan...'**
  String get onboardingGeneratingStepStructuring;

  /// Plan generation progress step 8 (pending)
  ///
  /// In en, this message translates to:
  /// **'Generating weekly sessions'**
  String get onboardingGeneratingStepWeeklySessions;

  /// Onboarding feedback welcome header
  ///
  /// In en, this message translates to:
  /// **'Ready, {name}!'**
  String onboardingFeedbackReadyTitle(String name);

  /// Onboarding feedback subtitle
  ///
  /// In en, this message translates to:
  /// **'Your plan is customized, start and\nachieve your goals.'**
  String get onboardingFeedbackReadySubtitle;

  /// Header for customized plan details list
  ///
  /// In en, this message translates to:
  /// **'Your plan in detail'**
  String get onboardingFeedbackDetailTitle;

  /// General wellness ecosystem warning prefix
  ///
  /// In en, this message translates to:
  /// **'What you see here is just the surface. Behind your plan is a '**
  String get onboardingFeedbackEcosystemTitle;

  /// General wellness ecosystem warning highlight
  ///
  /// In en, this message translates to:
  /// **'wellness ecosystem'**
  String get onboardingFeedbackEcosystemHighlight;

  /// General wellness ecosystem warning body text
  ///
  /// In en, this message translates to:
  /// **' working for you — each session, each intensity, each rest '**
  String get onboardingFeedbackWorkingForYou;

  /// General wellness ecosystem warning suffix
  ///
  /// In en, this message translates to:
  /// **'has a reason.'**
  String get onboardingFeedbackHasReason;

  /// Call-to-action button to start using the app
  ///
  /// In en, this message translates to:
  /// **'Start my 21 days free'**
  String get onboardingFeedbackStartFreeTrial;

  /// Duration label on hero details
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get onboardingFeedbackDurationLabel;

  /// Start date label on hero details
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardingFeedbackStartLabel;

  /// Training zones section title
  ///
  /// In en, this message translates to:
  /// **'Your training zones'**
  String get onboardingFeedbackZonesTitle;

  /// Training zones section explanation text
  ///
  /// In en, this message translates to:
  /// **'Each zone indicates exactly how hard to go in each session. Without this, you train blind.'**
  String get onboardingFeedbackZonesDesc;

  /// Training zones section highlighted tip
  ///
  /// In en, this message translates to:
  /// **'Your plan specifies which zone each session goes into.'**
  String get onboardingFeedbackZonesHighlight;

  /// Training zones section warning disclaimer
  ///
  /// In en, this message translates to:
  /// **'As you train, your body improves and these zones change. '**
  String get onboardingFeedbackZonesDisclaimer;

  /// Training zones section warning action
  ///
  /// In en, this message translates to:
  /// **'Repeating tests periodically allows adjusting them.'**
  String get onboardingFeedbackZonesDisclaimerAction;

  /// Or continue with social login divider
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get authDividerOr;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPassword;

  /// Email field placeholder hint
  ///
  /// In en, this message translates to:
  /// **'email@example.com'**
  String get authEmailHint;

  /// Password field placeholder hint
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get authPasswordHint;

  /// Google social login button label
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authGoogleButton;

  /// Apple social login button label
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authAppleButton;

  /// Meta social login button label
  ///
  /// In en, this message translates to:
  /// **'Continue with Meta'**
  String get authMetaButton;

  /// Welcome screen language selection title
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get welcomeTitle;

  /// Welcome screen language selection subtitle
  ///
  /// In en, this message translates to:
  /// **'You can change this later in settings'**
  String get welcomeSubtitle;

  /// Welcome screen continue button label
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get welcomeButton;

  /// Welcome screen marketing slogan
  ///
  /// In en, this message translates to:
  /// **'Complete wellness, at your pace.'**
  String get welcomeMarketingText;

  /// Login screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginTitle;

  /// Login screen welcome subtitle
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcomeBack;

  /// Login screen forgot password button text
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get loginForgotPassword;

  /// Login screen sign up prefix text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get loginNoAccount;

  /// Login screen sign up button link
  ///
  /// In en, this message translates to:
  /// **'Sign up →'**
  String get loginSignUpLink;

  /// Login screen submit button label
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// Login screen email required error
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get loginEmailRequired;

  /// Login screen invalid email error
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get loginEmailInvalid;

  /// Login screen password required error
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordRequired;

  /// Register screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// Register screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Create your account to start'**
  String get registerSubtitle;

  /// Register screen full name label
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get registerNameLabel;

  /// Register screen full name hint
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get registerNameHint;

  /// Register screen name required error
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get registerNameRequired;

  /// Register screen username label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get registerUsernameLabel;

  /// Register screen username hint
  ///
  /// In en, this message translates to:
  /// **'@username'**
  String get registerUsernameHint;

  /// Register screen username required error
  ///
  /// In en, this message translates to:
  /// **'Enter a username'**
  String get registerUsernameRequired;

  /// Register screen username no spaces error
  ///
  /// In en, this message translates to:
  /// **'No spaces'**
  String get registerUsernameNoSpaces;

  /// Register screen username too short error
  ///
  /// In en, this message translates to:
  /// **'Minimum 3 characters'**
  String get registerUsernameTooShort;

  /// Register screen email invalid error
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email (e.g.: name@gmail.com)'**
  String get registerEmailInvalid;

  /// Register screen password required error
  ///
  /// In en, this message translates to:
  /// **'Enter a password'**
  String get registerPasswordRequired;

  /// Register screen password too short error
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get registerPasswordTooShort;

  /// Register screen confirm password required error
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get registerConfirmPasswordRequired;

  /// Register screen password mismatch error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get registerPasswordsDoNotMatch;

  /// Register screen accept terms prefix text
  ///
  /// In en, this message translates to:
  /// **'I accept the '**
  String get registerTermsAccept;

  /// Register screen terms and conditions link
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get registerTermsLink;

  /// Register screen terms separator text
  ///
  /// In en, this message translates to:
  /// **' and the '**
  String get registerAnd;

  /// Register screen privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get registerPrivacyLink;

  /// Register screen already have an account prefix text
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get registerAlreadyHaveAccount;

  /// Register screen log in link text
  ///
  /// In en, this message translates to:
  /// **'Log in →'**
  String get registerLoginLink;

  /// Register screen snackbar error text
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms and conditions'**
  String get registerTermsSnackBarError;

  /// Forgot password screen title
  ///
  /// In en, this message translates to:
  /// **'Recover password'**
  String get forgotPasswordTitle;

  /// Forgot password instruction text
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we will send you\na link to reset your password.'**
  String get forgotPasswordInstruction;

  /// Forgot password submit button label
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get forgotPasswordSendButton;

  /// Forgot password back button label
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get forgotPasswordBackToLogin;

  /// Forgot password direct link to reset code text
  ///
  /// In en, this message translates to:
  /// **'I already have a code'**
  String get forgotPasswordHasCode;

  /// Forgot password error response text
  ///
  /// In en, this message translates to:
  /// **'Could not send the link. Verify your email.'**
  String get forgotPasswordErrorSending;

  /// Forgot password network failure error
  ///
  /// In en, this message translates to:
  /// **'Connection error. Try again.'**
  String get forgotPasswordConnectionError;

  /// Forgot password email sent success title
  ///
  /// In en, this message translates to:
  /// **'Email sent!'**
  String get forgotPasswordSuccessTitle;

  /// Forgot password success description text
  ///
  /// In en, this message translates to:
  /// **'We sent a recovery link to\n{email}'**
  String forgotPasswordSuccessDesc(String email);

  /// Forgot password go to reset code button label
  ///
  /// In en, this message translates to:
  /// **'Enter code / token'**
  String get forgotPasswordEnterCodeButton;

  /// Reset password screen title
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get resetPasswordTitle;

  /// Reset password instruction text
  ///
  /// In en, this message translates to:
  /// **'Enter the token you received by email and your new password.'**
  String get resetPasswordInstruction;

  /// Reset password invalid token error text
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired token.'**
  String get resetPasswordErrorDefault;

  /// Reset password network failure error text
  ///
  /// In en, this message translates to:
  /// **'Connection error. Try again.'**
  String get resetPasswordConnectionError;

  /// Reset password token label text
  ///
  /// In en, this message translates to:
  /// **'Recovery token'**
  String get resetPasswordTokenLabel;

  /// Reset password token placeholder text
  ///
  /// In en, this message translates to:
  /// **'Paste the token from your email'**
  String get resetPasswordTokenHint;

  /// Reset password token required error
  ///
  /// In en, this message translates to:
  /// **'Enter the token'**
  String get resetPasswordTokenRequired;

  /// Reset password new password label text
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get resetPasswordNewLabel;

  /// Reset password new password placeholder text
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get resetPasswordNewHint;

  /// Reset password password required error
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get resetPasswordNewRequired;

  /// Reset password password too short error
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get resetPasswordNewTooShort;

  /// Reset password confirm label text
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get resetPasswordConfirmLabel;

  /// Reset password confirm placeholder text
  ///
  /// In en, this message translates to:
  /// **'Repeat the password'**
  String get resetPasswordConfirmHint;

  /// Reset password confirm password required error
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get resetPasswordConfirmRequired;

  /// Reset password password mismatch error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get resetPasswordConfirmMismatch;

  /// Reset password submit button label
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get resetPasswordChangeButton;

  /// Reset password back link text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get resetPasswordBackLink;

  /// Reset password updated success title text
  ///
  /// In en, this message translates to:
  /// **'Password updated!'**
  String get resetPasswordSuccessTitle;

  /// Reset password updated success description text
  ///
  /// In en, this message translates to:
  /// **'Your password was successfully changed.\nYou can now log in.'**
  String get resetPasswordSuccessDesc;

  /// Reset password go back to login button label
  ///
  /// In en, this message translates to:
  /// **'Go to login'**
  String get resetPasswordGoToLoginButton;

  /// Header section label for Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeHeaderSection;

  /// Header for key session note
  ///
  /// In en, this message translates to:
  /// **'Key session of the week'**
  String get homeKeySessionNoteHeader;

  /// Title for connect devices banner
  ///
  /// In en, this message translates to:
  /// **'Connect your devices'**
  String get homeConnectDevicesTitle;

  /// Description for connect devices banner
  ///
  /// In en, this message translates to:
  /// **'Optional but recommended. With your wearable data, Fitnflai adapts your plan in real-time: steps, sleep, HR and more.'**
  String get homeConnectDevicesDesc;

  /// Title for connected device banner
  ///
  /// In en, this message translates to:
  /// **'Device connected'**
  String get homeDeviceConnectedTitle;

  /// Description for connected device banner
  ///
  /// In en, this message translates to:
  /// **'Fitnflai is receiving your data in real-time.'**
  String get homeDeviceConnectedDesc;

  /// Sleep stat card label
  ///
  /// In en, this message translates to:
  /// **'Sleep\nlast night'**
  String get homeSleepLabel;

  /// Rest heart rate stat card label
  ///
  /// In en, this message translates to:
  /// **'Rest HR'**
  String get homeRestHRLabel;

  /// Temperature stat card label
  ///
  /// In en, this message translates to:
  /// **'Temperature\nnow'**
  String get homeTemperatureLabel;

  /// Weather condition stat card label
  ///
  /// In en, this message translates to:
  /// **'Weather\ncondition'**
  String get homeWeatherLabel;

  /// Daily check-in banner title
  ///
  /// In en, this message translates to:
  /// **'How are you today?'**
  String get homeDailyCheckinTitle;

  /// Daily check-in banner description
  ///
  /// In en, this message translates to:
  /// **'Answer 4 quick questions so Fitnflai can adjust your session.'**
  String get homeDailyCheckinDesc;

  /// Weekly distribution section label
  ///
  /// In en, this message translates to:
  /// **'WEEKLY DISTRIBUTION'**
  String get homeSectionWeeklyDist;

  /// Weekly intensity section label
  ///
  /// In en, this message translates to:
  /// **'WEEKLY INTENSITY'**
  String get homeSectionWeeklyIntensity;

  /// Weekly adherence section label
  ///
  /// In en, this message translates to:
  /// **'ADHERENCE TO PLAN'**
  String get homeSectionWeeklyAdherence;

  /// Number of completed sessions in a week
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} sessions completed'**
  String homeSessionCompleted(int completed, int total);

  /// Rest day title
  ///
  /// In en, this message translates to:
  /// **'Rest, {name}'**
  String homeRestDayTitle(String name);

  /// Rest day description
  ///
  /// In en, this message translates to:
  /// **'Recovery is part of training.\nEnjoy this rest day!'**
  String get homeRestDayDesc;

  /// Active rest tips section label
  ///
  /// In en, this message translates to:
  /// **'ACTIVE REST'**
  String get homeRestDayActiveSection;

  /// Rest tip walk title
  ///
  /// In en, this message translates to:
  /// **'Easy walk'**
  String get homeRestTipWalkTitle;

  /// Rest tip walk description
  ///
  /// In en, this message translates to:
  /// **'20–30 min at conversational pace'**
  String get homeRestTipWalkDesc;

  /// Rest tip mobility title
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get homeRestTipMobilityTitle;

  /// Rest tip mobility description
  ///
  /// In en, this message translates to:
  /// **'10 min of dynamic stretching'**
  String get homeRestTipMobilityDesc;

  /// Rest tip hydration title
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get homeRestTipHydrationTitle;

  /// Rest tip hydration description
  ///
  /// In en, this message translates to:
  /// **'Maintain a good hydration level today'**
  String get homeRestTipHydrationDesc;

  /// Rest tip sleep title
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get homeRestTipSleepTitle;

  /// Rest tip sleep description
  ///
  /// In en, this message translates to:
  /// **'Prioritize 7–9 hours of rest'**
  String get homeRestTipSleepDesc;

  /// Missed session status badge
  ///
  /// In en, this message translates to:
  /// **'Not completed'**
  String get homeSessionMissed;

  /// Start training button label
  ///
  /// In en, this message translates to:
  /// **'Start training'**
  String get homeWorkoutStartButton;

  /// Adjust training button label
  ///
  /// In en, this message translates to:
  /// **'Tired or bad weather? Adjust'**
  String get homeWorkoutAdjustButton;

  /// See detail button label
  ///
  /// In en, this message translates to:
  /// **'See workout detail'**
  String get homeWorkoutDetailButton;

  /// Adherence percentage
  ///
  /// In en, this message translates to:
  /// **'{percentage}%'**
  String homeAdherencePct(int percentage);

  /// Tip of the day header
  ///
  /// In en, this message translates to:
  /// **'Tip of the day'**
  String get homeTipOfTheDayTitle;

  /// Tip of the day description
  ///
  /// In en, this message translates to:
  /// **'Remember to hydrate well before your next high-intensity session.'**
  String get homeTipOfTheDayDesc;

  /// Refund request link in settings
  ///
  /// In en, this message translates to:
  /// **'Request refund'**
  String get settingsRefundRequest;

  /// Instructions for Nuvei payment flow
  ///
  /// In en, this message translates to:
  /// **'We have opened the secure Nuvei payment gateway in your browser. Please complete your payment there. Once finished, return to Fitnflai and click the \'Verify Payment\' button to update your subscription. DO NOT CLOSE this window until you have completed the process.'**
  String get membershipNuveiInstructions;

  /// Button to verify Nuvei payment
  ///
  /// In en, this message translates to:
  /// **'Verify Payment'**
  String get membershipNuveiVerifyButton;

  /// Button to close Nuvei payment instructions
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get membershipNuveiCloseButton;

  /// Label for refund reference input
  ///
  /// In en, this message translates to:
  /// **'Payment reference (order number)'**
  String get refundReferenceLabel;

  /// Label for refund reason input
  ///
  /// In en, this message translates to:
  /// **'Reason for refund'**
  String get refundReasonLabel;

  /// Error message for empty refund fields
  ///
  /// In en, this message translates to:
  /// **'Please enter the reference and reason.'**
  String get refundEmptyFieldsError;

  /// Success message for refund request
  ///
  /// In en, this message translates to:
  /// **'Refund request successfully submitted. We will contact you soon.'**
  String get refundSuccess;

  /// No description provided for @workoutAdjustmentReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason for adjustment'**
  String get workoutAdjustmentReasonLabel;

  /// No description provided for @workoutAdjustmentReasonSelect.
  ///
  /// In en, this message translates to:
  /// **'Select a reason'**
  String get workoutAdjustmentReasonSelect;

  /// No description provided for @workoutAdjustmentReasonWeather.
  ///
  /// In en, this message translates to:
  /// **'Bad weather'**
  String get workoutAdjustmentReasonWeather;

  /// No description provided for @workoutAdjustmentReasonTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get workoutAdjustmentReasonTired;

  /// No description provided for @workoutAdjustmentReasonInjury.
  ///
  /// In en, this message translates to:
  /// **'Injury'**
  String get workoutAdjustmentReasonInjury;

  /// No description provided for @workoutAdjustmentReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get workoutAdjustmentReasonOther;

  /// No description provided for @workoutAdjustmentSeverityLabel.
  ///
  /// In en, this message translates to:
  /// **'Injury severity'**
  String get workoutAdjustmentSeverityLabel;

  /// No description provided for @workoutAdjustmentSeveritySelect.
  ///
  /// In en, this message translates to:
  /// **'Select severity'**
  String get workoutAdjustmentSeveritySelect;

  /// No description provided for @workoutAdjustmentSeverityMild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get workoutAdjustmentSeverityMild;

  /// No description provided for @workoutAdjustmentSeverityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get workoutAdjustmentSeverityModerate;

  /// No description provided for @workoutAdjustmentSeveritySevere.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get workoutAdjustmentSeveritySevere;

  /// No description provided for @workoutAdjustmentDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Additional details (optional)'**
  String get workoutAdjustmentDescLabel;

  /// No description provided for @workoutAdjustmentDescPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe how you feel here...'**
  String get workoutAdjustmentDescPlaceholder;

  /// No description provided for @workoutAdjustmentValidationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get workoutAdjustmentValidationRequired;

  /// No description provided for @workoutAdjustmentBtnSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get workoutAdjustmentBtnSubmit;

  /// No description provided for @workoutAdjustmentBtnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get workoutAdjustmentBtnCancel;

  /// No description provided for @workoutAdjustmentSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Adjustment submitted successfully!'**
  String get workoutAdjustmentSuccessMessage;

  /// Title of the booking screen
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get specialistBookingTitle;

  /// Label to select date
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get specialistBookingSelectDate;

  /// Label to select time
  ///
  /// In en, this message translates to:
  /// **'Select Time Slot'**
  String get specialistBookingSelectTime;

  /// Button to schedule appointment
  ///
  /// In en, this message translates to:
  /// **'Schedule Appointment (\$19.99)'**
  String get specialistBookingConfirmBtn;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'45 min Session'**
  String get specialistBookingDuration;

  /// Title of the payment modal sheet
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get specialistBookingCheckoutTitle;

  /// Checkout summary description
  ///
  /// In en, this message translates to:
  /// **'Specialist Session (45 min)'**
  String get specialistBookingCheckoutSummary;

  /// Button to confirm and pay
  ///
  /// In en, this message translates to:
  /// **'Confirm & Pay'**
  String get specialistBookingCheckoutConfirmBtn;

  /// Success booking dialog title
  ///
  /// In en, this message translates to:
  /// **'Appointment Scheduled!'**
  String get specialistBookingSuccessTitle;

  /// Success booking dialog description
  ///
  /// In en, this message translates to:
  /// **'Your appointment has been successfully scheduled for {date} at {time}.'**
  String specialistBookingSuccessDesc(String date, String time);

  /// Success dialog close button
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get specialistBookingSuccessClose;

  /// Error message when essential data for booking is missing
  ///
  /// In en, this message translates to:
  /// **'Missing data for booking. Please ensure a specialist and time are selected.'**
  String get specialistBookingErrorMissingData;

  /// Snackbar message when profile reload fails after successful booking
  ///
  /// In en, this message translates to:
  /// **'Appointment scheduled, but profile could not be updated immediately.'**
  String get specialistBookingProfileReloadFailed;

  /// Generic error message for booking failure
  ///
  /// In en, this message translates to:
  /// **'Failed to schedule appointment. Please try again.'**
  String get specialistBookingGenericError;

  /// Default description for specialist appointment
  ///
  /// In en, this message translates to:
  /// **'Online consultation'**
  String get specialistBookingDefaultDescription;

  /// Borg scale question
  ///
  /// In en, this message translates to:
  /// **'How much effort did you perceive? (Borg 6–20)'**
  String get testTimerBorgQuestion;

  /// Borg RPE level 6
  ///
  /// In en, this message translates to:
  /// **'No effort'**
  String get testTimerBorgLevel6;

  /// Borg RPE level 7
  ///
  /// In en, this message translates to:
  /// **'Very, very light'**
  String get testTimerBorgLevel7;

  /// Borg RPE level 8
  ///
  /// In en, this message translates to:
  /// **'Very light'**
  String get testTimerBorgLevel8;

  /// Borg RPE level 9
  ///
  /// In en, this message translates to:
  /// **'Fairly light'**
  String get testTimerBorgLevel9;

  /// Borg RPE level 10
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get testTimerBorgLevel10;

  /// Borg RPE level 11
  ///
  /// In en, this message translates to:
  /// **'Moderately light'**
  String get testTimerBorgLevel11;

  /// Borg RPE level 12
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get testTimerBorgLevel12;

  /// Borg RPE level 13
  ///
  /// In en, this message translates to:
  /// **'Somewhat hard'**
  String get testTimerBorgLevel13;

  /// Borg RPE level 14
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get testTimerBorgLevel14;

  /// Borg RPE level 15
  ///
  /// In en, this message translates to:
  /// **'Very hard'**
  String get testTimerBorgLevel15;

  /// Borg RPE level 16
  ///
  /// In en, this message translates to:
  /// **'Very, very hard'**
  String get testTimerBorgLevel16;

  /// Borg RPE level 17
  ///
  /// In en, this message translates to:
  /// **'Extremely hard'**
  String get testTimerBorgLevel17;

  /// Borg RPE level 18
  ///
  /// In en, this message translates to:
  /// **'Almost maximal'**
  String get testTimerBorgLevel18;

  /// Borg RPE level 19
  ///
  /// In en, this message translates to:
  /// **'Very near maximal'**
  String get testTimerBorgLevel19;

  /// Borg RPE level 20
  ///
  /// In en, this message translates to:
  /// **'Maximal effort'**
  String get testTimerBorgLevel20;

  /// Borg scale minimum label
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get testTimerBorgMinLabel;

  /// Borg scale middle label
  ///
  /// In en, this message translates to:
  /// **'Somewhat hard'**
  String get testTimerBorgMidLabel;

  /// Borg scale maximum label
  ///
  /// In en, this message translates to:
  /// **'Maximal'**
  String get testTimerBorgMaxLabel;

  /// Snackbar prompt to enter test result
  ///
  /// In en, this message translates to:
  /// **'Enter your result before continuing'**
  String get testTimerEnterResultPrompt;

  /// Error message when saving test result fails
  ///
  /// In en, this message translates to:
  /// **'Error saving result. Try again.'**
  String get testTimerSaveError;

  /// Connection error message for test timer
  ///
  /// In en, this message translates to:
  /// **'Connection error. Try again.'**
  String get testTimerConnectionError;

  /// Label for stopwatch mode (free timer)
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get testTimerModeFree;

  /// Status for completed test
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get testTimerStatusCompleted;

  /// Button label to manually finish stopwatch timer
  ///
  /// In en, this message translates to:
  /// **'Finish now'**
  String get testTimerButtonFinishNow;

  /// Button label to reset timer
  ///
  /// In en, this message translates to:
  /// **'Reset from scratch'**
  String get testTimerButtonReset;

  /// Title for test completion success message
  ///
  /// In en, this message translates to:
  /// **'Test completed!'**
  String get testTimerCompletionTitle;

  /// Time displayed on test completion
  ///
  /// In en, this message translates to:
  /// **'Time: {time}'**
  String testTimerCompletionTime(String time);

  /// Flexibility test question
  ///
  /// In en, this message translates to:
  /// **'How far did your hands reach?'**
  String get testTimerFlexibilityQuestion;

  /// Flexibility test option: doesn't reach knees
  ///
  /// In en, this message translates to:
  /// **'Doesn\'t reach knees'**
  String get testTimerFlexOptionKnees;

  /// Flexibility test option: reaches feet
  ///
  /// In en, this message translates to:
  /// **'Reaches feet'**
  String get testTimerFlexOptionFeet;

  /// Flexibility test option: past feet
  ///
  /// In en, this message translates to:
  /// **'Past feet'**
  String get testTimerFlexOptionPastFeet;

  /// Flexibility test option: palms to the ground
  ///
  /// In en, this message translates to:
  /// **'Palms to the ground'**
  String get testTimerFlexOptionGround;

  /// Prompt to enter result with unit
  ///
  /// In en, this message translates to:
  /// **'Enter your result in {unit}'**
  String testTimerEnterResultWithUnit(String unit);

  /// Button label to save test result and continue
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get testTimerSaveAndContinue;

  /// No description provided for @homeCalendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeCalendarToday;

  /// No description provided for @weatherRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get weatherRain;

  /// No description provided for @weatherClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get weatherClear;

  /// No description provided for @weatherPartlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly cloudy'**
  String get weatherPartlyCloudy;

  /// No description provided for @weatherCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherCloudy;

  /// No description provided for @weatherFog.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get weatherFog;

  /// No description provided for @weatherSnow.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get weatherSnow;

  /// No description provided for @weatherShowers.
  ///
  /// In en, this message translates to:
  /// **'Showers'**
  String get weatherShowers;

  /// No description provided for @weatherThunderstorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get weatherThunderstorm;

  /// No description provided for @planHeaderSection.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planHeaderSection;

  /// No description provided for @planContextPast.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get planContextPast;

  /// No description provided for @planContextFuture.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get planContextFuture;

  /// No description provided for @planContextCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current week'**
  String get planContextCurrent;

  /// No description provided for @planSessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'sessions'**
  String get planSessionsLabel;

  /// No description provided for @planCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get planCompletedLabel;

  /// No description provided for @planEmptyFutureTitle.
  ///
  /// In en, this message translates to:
  /// **'Your plan for this week is not ready yet'**
  String get planEmptyFutureTitle;

  /// No description provided for @planEmptyFutureDesc.
  ///
  /// In en, this message translates to:
  /// **'The AI will generate your plan when the time comes.'**
  String get planEmptyFutureDesc;

  /// No description provided for @planEmptyPastTitle.
  ///
  /// In en, this message translates to:
  /// **'No workouts this week'**
  String get planEmptyPastTitle;

  /// No description provided for @planEmptyPastDesc.
  ///
  /// In en, this message translates to:
  /// **'The AI will generate your plan when the time comes.'**
  String get planEmptyPastDesc;

  /// No description provided for @planLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading plan'**
  String get planLoadError;

  /// No description provided for @planConnError.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get planConnError;

  /// No description provided for @planRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get planRetry;

  /// No description provided for @planActiveRestLabel.
  ///
  /// In en, this message translates to:
  /// **'REST DAY'**
  String get planActiveRestLabel;

  /// No description provided for @planActiveRestToday.
  ///
  /// In en, this message translates to:
  /// **'Today · Rest'**
  String get planActiveRestToday;

  /// No description provided for @planActiveRestActive.
  ///
  /// In en, this message translates to:
  /// **'Active rest'**
  String get planActiveRestActive;

  /// No description provided for @planActiveRestDefaultMsg.
  ///
  /// In en, this message translates to:
  /// **'Recovery is part of training.\nEnjoy this rest day!'**
  String get planActiveRestDefaultMsg;

  /// No description provided for @planActiveRestRecs.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDATIONS'**
  String get planActiveRestRecs;

  /// No description provided for @planActiveRestTipWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get planActiveRestTipWalk;

  /// No description provided for @planActiveRestTipMobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get planActiveRestTipMobility;

  /// No description provided for @planActiveRestTipHydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get planActiveRestTipHydration;

  /// No description provided for @planActiveRestTipSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get planActiveRestTipSleep;

  /// No description provided for @planActiveRestTipWalkDesc.
  ///
  /// In en, this message translates to:
  /// **'Easy walk'**
  String get planActiveRestTipWalkDesc;

  /// No description provided for @planActiveRestTipMobilityDesc.
  ///
  /// In en, this message translates to:
  /// **'Dynamic stretches'**
  String get planActiveRestTipMobilityDesc;

  /// No description provided for @planActiveRestTipHydrationDesc.
  ///
  /// In en, this message translates to:
  /// **'Stay hydrated'**
  String get planActiveRestTipHydrationDesc;

  /// No description provided for @planActiveRestTipSleepDesc.
  ///
  /// In en, this message translates to:
  /// **'Sleep well'**
  String get planActiveRestTipSleepDesc;

  /// No description provided for @planSessionCardTodayHeader.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S WORKOUT'**
  String get planSessionCardTodayHeader;

  /// No description provided for @planSessionCardTodayBadge.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get planSessionCardTodayBadge;

  /// No description provided for @planSessionCardCompletedBadge.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get planSessionCardCompletedBadge;

  /// No description provided for @planSessionCardMissedBadge.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get planSessionCardMissedBadge;

  /// No description provided for @planSessionCardStartBtn.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get planSessionCardStartBtn;

  /// No description provided for @planSessionCardAdjustBtn.
  ///
  /// In en, this message translates to:
  /// **'Tired or bad weather? Adjust'**
  String get planSessionCardAdjustBtn;

  /// No description provided for @planSessionCardDetailBtn.
  ///
  /// In en, this message translates to:
  /// **'See detail'**
  String get planSessionCardDetailBtn;

  /// No description provided for @planSessionCardLockDesc.
  ///
  /// In en, this message translates to:
  /// **'Available when the week arrives'**
  String get planSessionCardLockDesc;

  /// No description provided for @progressHeaderSection.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressHeaderSection;

  /// No description provided for @progressSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'In these {months} months you achieved:'**
  String progressSummaryTitle(int months);

  /// No description provided for @progressSummaryCompleted.
  ///
  /// In en, this message translates to:
  /// **'sessions completed'**
  String get progressSummaryCompleted;

  /// No description provided for @progressSummaryHours.
  ///
  /// In en, this message translates to:
  /// **'hours training'**
  String get progressSummaryHours;

  /// No description provided for @progressSummaryFat.
  ///
  /// In en, this message translates to:
  /// **'body fat'**
  String get progressSummaryFat;

  /// No description provided for @progressWellnessAgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Wellness age'**
  String get progressWellnessAgeTitle;

  /// No description provided for @progressWellnessAgeDesc.
  ///
  /// In en, this message translates to:
  /// **'Your body is {years} years younger than your actual age. You started with {startAge}.'**
  String progressWellnessAgeDesc(int years, int startAge);

  /// No description provided for @progressWellnessAgeDiff.
  ///
  /// In en, this message translates to:
  /// **'{years} years since you started'**
  String progressWellnessAgeDiff(int years);

  /// No description provided for @progressClaveBadge.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get progressClaveBadge;

  /// No description provided for @progressClaveDesc.
  ///
  /// In en, this message translates to:
  /// **'Maintain cardiovascular conditions. Strength, mobility and body composition are the metrics that \"go\" with quality training. The more you train, the easier everything becomes.'**
  String get progressClaveDesc;

  /// No description provided for @progressSectionHealthComp.
  ///
  /// In en, this message translates to:
  /// **'Health and composition'**
  String get progressSectionHealthComp;

  /// No description provided for @progressIndicatorsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The 3 key indicators'**
  String get progressIndicatorsSubtitle;

  /// No description provided for @progressIndicatorBefore.
  ///
  /// In en, this message translates to:
  /// **'before: {before}'**
  String progressIndicatorBefore(String before);

  /// No description provided for @progressIndicatorTarget.
  ///
  /// In en, this message translates to:
  /// **'target: {target}'**
  String progressIndicatorTarget(String target);

  /// No description provided for @progressSectionPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance and training'**
  String get progressSectionPerformance;

  /// No description provided for @progressComplianceTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan compliance'**
  String get progressComplianceTitle;

  /// No description provided for @progressComplianceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Last 4 weeks'**
  String get progressComplianceSubtitle;

  /// No description provided for @progressComplianceDesc.
  ///
  /// In en, this message translates to:
  /// **'Consistency is the factor that most predicts progress. Completing the plan week by week is as important as the training itself.'**
  String get progressComplianceDesc;

  /// No description provided for @progressLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly load'**
  String get progressLoadTitle;

  /// No description provided for @progressLoadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'for same load'**
  String get progressLoadSubtitle;

  /// No description provided for @progressLoadDesc.
  ///
  /// In en, this message translates to:
  /// **'More hours progressively is the sign that your body adapts and can handle more. Low weeks are planned deloads, not setbacks.'**
  String get progressLoadDesc;

  /// No description provided for @progressLoadThisWeek.
  ///
  /// In en, this message translates to:
  /// **'this week'**
  String get progressLoadThisWeek;

  /// No description provided for @progressLoadVsPrevious.
  ///
  /// In en, this message translates to:
  /// **'vs previous month'**
  String get progressLoadVsPrevious;

  /// No description provided for @progressLoadAverage.
  ///
  /// In en, this message translates to:
  /// **'average'**
  String get progressLoadAverage;

  /// No description provided for @progressLoadDescNote.
  ///
  /// In en, this message translates to:
  /// **'= weeks marked with planned deloads'**
  String get progressLoadDescNote;

  /// No description provided for @progressRpeTitle.
  ///
  /// In en, this message translates to:
  /// **'Perceived exertion (RPE)'**
  String get progressRpeTitle;

  /// No description provided for @progressRpeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'#2 hours · # sessions'**
  String get progressRpeSubtitle;

  /// No description provided for @progressRpeDesc.
  ///
  /// In en, this message translates to:
  /// **'If you do the workout with less effort, your body is becoming more efficient. Lower bars are proof that you are improving.'**
  String get progressRpeDesc;

  /// No description provided for @progressAITendencyTitle.
  ///
  /// In en, this message translates to:
  /// **'General trend · Fitnflai'**
  String get progressAITendencyTitle;

  /// No description provided for @progressAITendencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Last 3 months analysis'**
  String get progressAITendencySubtitle;

  /// No description provided for @progressAITendencyDesc.
  ///
  /// In en, this message translates to:
  /// **'You have had a positive trend in all key metrics for 3 months. Nico, your body recomposition is progressing consistently and your cardiovascular capacity is at an excellent level for your age.'**
  String get progressAITendencyDesc;

  /// No description provided for @nutritionHeaderSection.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutritionHeaderSection;

  /// No description provided for @nutritionAIBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart nutrition for your training'**
  String get nutritionAIBannerTitle;

  /// No description provided for @nutritionAIBannerDesc.
  ///
  /// In en, this message translates to:
  /// **'Your weekly nutritional plan, personalized macros and type of diet before each session. Generated by Fitnflai according to your training load.'**
  String get nutritionAIBannerDesc;

  /// No description provided for @nutritionAIBannerProTitle.
  ///
  /// In en, this message translates to:
  /// **'With the Pro plan you unlock:'**
  String get nutritionAIBannerProTitle;

  /// No description provided for @nutritionAIBannerProBtn.
  ///
  /// In en, this message translates to:
  /// **'See Pro plan'**
  String get nutritionAIBannerProBtn;

  /// No description provided for @nutritionAIBannerProNote.
  ///
  /// In en, this message translates to:
  /// **'No credit card · Cancel anytime'**
  String get nutritionAIBannerProNote;

  /// No description provided for @nutritionRestDayBanner.
  ///
  /// In en, this message translates to:
  /// **'Rest day · Eat light and stay well hydrated.'**
  String get nutritionRestDayBanner;

  /// No description provided for @nutritionMacrosTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Macros'**
  String get nutritionMacrosTitle;

  /// No description provided for @nutritionMacrosKcal.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal'**
  String nutritionMacrosKcal(int kcal);

  /// No description provided for @nutritionMacrosCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get nutritionMacrosCarbs;

  /// No description provided for @nutritionMacrosProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get nutritionMacrosProtein;

  /// No description provided for @nutritionMacrosFat.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get nutritionMacrosFat;

  /// No description provided for @nutritionSectionPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'DAILY PLAN · {title}'**
  String nutritionSectionPlanTitle(String title);

  /// No description provided for @nutritionHydrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic hydration'**
  String get nutritionHydrationTitle;

  /// No description provided for @nutritionHydrationValue.
  ///
  /// In en, this message translates to:
  /// **'{current}L / {total}L'**
  String nutritionHydrationValue(double current, double total);

  /// No description provided for @nutritionHydrationInfo.
  ///
  /// In en, this message translates to:
  /// **'At {altitude}m your hydration needs increase by {pct}% vs sea level'**
  String nutritionHydrationInfo(int altitude, int pct);

  /// No description provided for @profileButtonEdit.
  ///
  /// In en, this message translates to:
  /// **'EDIT PROFILE'**
  String get profileButtonEdit;

  /// No description provided for @profilePremiumTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}, join Fitnflai Premium'**
  String profilePremiumTitle(String name);

  /// No description provided for @profilePremiumDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlock your full plan and reach your full potential.'**
  String get profilePremiumDesc;

  /// No description provided for @profilePremiumSubscribe.
  ///
  /// In en, this message translates to:
  /// **'SUBSCRIBE'**
  String get profilePremiumSubscribe;

  /// No description provided for @profilePremiumRestore.
  ///
  /// In en, this message translates to:
  /// **'RESTORE'**
  String get profilePremiumRestore;

  /// No description provided for @profilePlanActiveHeader.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE PLAN'**
  String get profilePlanActiveHeader;

  /// No description provided for @profilePlanActiveProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} / {total} sessions'**
  String profilePlanActiveProgress(int completed, int total);

  /// No description provided for @profileJoinDate.
  ///
  /// In en, this message translates to:
  /// **'Joined: {month} {year}'**
  String profileJoinDate(String month, int year);

  /// No description provided for @profileSectionMyStuff.
  ///
  /// In en, this message translates to:
  /// **'MY STUFF'**
  String get profileSectionMyStuff;

  /// No description provided for @profileMenuConnectedApps.
  ///
  /// In en, this message translates to:
  /// **'Connected apps and devices'**
  String get profileMenuConnectedApps;

  /// No description provided for @profileMenuPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal info'**
  String get profileMenuPersonalInfo;

  /// No description provided for @profileMenuNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileMenuNotifications;

  /// No description provided for @profileMenuWeeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Configure weekly report'**
  String get profileMenuWeeklyReport;

  /// No description provided for @profileSectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'MY PREFERENCES'**
  String get profileSectionPreferences;

  /// No description provided for @profileMenuGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get profileMenuGeneral;

  /// No description provided for @profileMenuMyPlan.
  ///
  /// In en, this message translates to:
  /// **'My plan'**
  String get profileMenuMyPlan;

  /// No description provided for @profileMenuMyTests.
  ///
  /// In en, this message translates to:
  /// **'My tests'**
  String get profileMenuMyTests;

  /// No description provided for @profileMenuPeriodicEval.
  ///
  /// In en, this message translates to:
  /// **'Periodic evaluation'**
  String get profileMenuPeriodicEval;

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get profileSectionAccount;

  /// No description provided for @profileMenuDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileMenuDeleteAccount;

  /// No description provided for @profileButtonLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileButtonLogout;

  /// No description provided for @profileConfirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get profileConfirmDeleteTitle;

  /// No description provided for @profileConfirmDeleteDesc.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible. All your data, plan and history will be deleted.'**
  String get profileConfirmDeleteDesc;

  /// No description provided for @profileConfirmDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileConfirmDeleteCancel;

  /// No description provided for @profileConfirmDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profileConfirmDeleteConfirm;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @editProfileChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get editProfileChangePhoto;

  /// No description provided for @editProfileTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get editProfileTakePhoto;

  /// No description provided for @editProfileChooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get editProfileChooseGallery;

  /// No description provided for @editProfileDeletePhoto.
  ///
  /// In en, this message translates to:
  /// **'Delete photo'**
  String get editProfileDeletePhoto;

  /// No description provided for @editProfileSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get editProfileSuccess;

  /// No description provided for @editProfileError.
  ///
  /// In en, this message translates to:
  /// **'Error saving. Try again.'**
  String get editProfileError;

  /// No description provided for @editProfileTapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap to change photo'**
  String get editProfileTapToChange;

  /// No description provided for @editProfileUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get editProfileUsername;

  /// No description provided for @editProfileUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'@username'**
  String get editProfileUsernameHint;

  /// No description provided for @editProfileUsernameError.
  ///
  /// In en, this message translates to:
  /// **'Enter a username'**
  String get editProfileUsernameError;

  /// No description provided for @editProfileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get editProfileEmail;

  /// No description provided for @editProfileEmailHint.
  ///
  /// In en, this message translates to:
  /// **'email@example.com'**
  String get editProfileEmailHint;

  /// No description provided for @editProfileEmailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get editProfileEmailEmpty;

  /// No description provided for @editProfileEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get editProfileEmailInvalid;

  /// No description provided for @editProfileCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get editProfileCity;

  /// No description provided for @editProfileCitySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search city...'**
  String get editProfileCitySearchHint;

  /// No description provided for @editProfileAltitude.
  ///
  /// In en, this message translates to:
  /// **'Altitude (m.a.s.l.)'**
  String get editProfileAltitude;

  /// No description provided for @editProfileAltitudeHint.
  ///
  /// In en, this message translates to:
  /// **'Detected when selecting city'**
  String get editProfileAltitudeHint;

  /// No description provided for @editProfileMembership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get editProfileMembership;

  /// No description provided for @editProfileMembershipPlan.
  ///
  /// In en, this message translates to:
  /// **'Essential Plan'**
  String get editProfileMembershipPlan;

  /// No description provided for @editProfileMembershipDays.
  ///
  /// In en, this message translates to:
  /// **'21 free days active'**
  String get editProfileMembershipDays;

  /// No description provided for @editProfileMembershipChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get editProfileMembershipChange;

  /// No description provided for @editProfileSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get editProfileSaving;

  /// No description provided for @editProfileSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get editProfileSave;

  /// No description provided for @trainingSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get trainingSettingsTitle;

  /// No description provided for @trainingSettingsSmartAdaptations.
  ///
  /// In en, this message translates to:
  /// **'SMART ADAPTATIONS'**
  String get trainingSettingsSmartAdaptations;

  /// No description provided for @trainingSettingsSmartAltitude.
  ///
  /// In en, this message translates to:
  /// **'Smart altitude'**
  String get trainingSettingsSmartAltitude;

  /// No description provided for @trainingSettingsSmartAltitudeDesc.
  ///
  /// In en, this message translates to:
  /// **'Adjusts HR zones and hydration according to your altitude'**
  String get trainingSettingsSmartAltitudeDesc;

  /// No description provided for @trainingSettingsInjuryAlerts.
  ///
  /// In en, this message translates to:
  /// **'Injury alerts'**
  String get trainingSettingsInjuryAlerts;

  /// No description provided for @trainingSettingsInjuryAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Warns when there is risk of overtraining'**
  String get trainingSettingsInjuryAlertsDesc;

  /// No description provided for @trainingSettingsPlanPrefs.
  ///
  /// In en, this message translates to:
  /// **'PLAN PREFERENCES'**
  String get trainingSettingsPlanPrefs;

  /// No description provided for @trainingSettingsDiscipline.
  ///
  /// In en, this message translates to:
  /// **'Discipline'**
  String get trainingSettingsDiscipline;

  /// No description provided for @trainingSettingsDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty level'**
  String get trainingSettingsDifficulty;

  /// No description provided for @trainingSettingsTimePerSession.
  ///
  /// In en, this message translates to:
  /// **'Time per session'**
  String get trainingSettingsTimePerSession;

  /// No description provided for @trainingSettingsMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String trainingSettingsMinutes(int minutes);

  /// No description provided for @trainingSettingsTrainingDays.
  ///
  /// In en, this message translates to:
  /// **'TRAINING DAYS'**
  String get trainingSettingsTrainingDays;

  /// No description provided for @trainingSettingsSelectDays.
  ///
  /// In en, this message translates to:
  /// **'Select the days you train'**
  String get trainingSettingsSelectDays;

  /// No description provided for @trainingSettingsCompetitions.
  ///
  /// In en, this message translates to:
  /// **'COMPETITIONS AND EVENTS'**
  String get trainingSettingsCompetitions;

  /// No description provided for @trainingSettingsMyCompetitions.
  ///
  /// In en, this message translates to:
  /// **'My competitions and events'**
  String get trainingSettingsMyCompetitions;

  /// No description provided for @trainingSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved'**
  String get trainingSettingsSaved;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get difficultyModerate;

  /// No description provided for @difficultyChallenging.
  ///
  /// In en, this message translates to:
  /// **'Challenging'**
  String get difficultyChallenging;

  /// No description provided for @difficultyCompetitive.
  ///
  /// In en, this message translates to:
  /// **'Competitive'**
  String get difficultyCompetitive;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySun;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportTitle;

  /// No description provided for @supportHelpHeader.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get supportHelpHeader;

  /// No description provided for @supportHelpSub.
  ///
  /// In en, this message translates to:
  /// **'We are here to help you get the most out of your training.'**
  String get supportHelpSub;

  /// No description provided for @supportContact.
  ///
  /// In en, this message translates to:
  /// **'CONTACT'**
  String get supportContact;

  /// No description provided for @supportLiveChat.
  ///
  /// In en, this message translates to:
  /// **'Live chat'**
  String get supportLiveChat;

  /// No description provided for @supportLiveChatSub.
  ///
  /// In en, this message translates to:
  /// **'Response in less than 2 hours'**
  String get supportLiveChatSub;

  /// No description provided for @supportAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get supportAvailable;

  /// No description provided for @supportEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get supportEmail;

  /// No description provided for @supportHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get supportHelpCenter;

  /// No description provided for @supportHelpCenterSub.
  ///
  /// In en, this message translates to:
  /// **'Detailed guides and tutorials'**
  String get supportHelpCenterSub;

  /// No description provided for @supportFaqs.
  ///
  /// In en, this message translates to:
  /// **'FREQUENTLY ASKED QUESTIONS'**
  String get supportFaqs;

  /// No description provided for @supportFollowUs.
  ///
  /// In en, this message translates to:
  /// **'FOLLOW US'**
  String get supportFollowUs;

  /// No description provided for @supportVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String supportVersion(String version);

  /// No description provided for @supportFaqQ1.
  ///
  /// In en, this message translates to:
  /// **'How does the training plan work?'**
  String get supportFaqQ1;

  /// No description provided for @supportFaqA1.
  ///
  /// In en, this message translates to:
  /// **'Fitnflai analyzes your profile, history, functional tests and objectives to generate a personalized week-by-week plan. The plan automatically adjusts according to your progress and daily feedback.'**
  String get supportFaqA1;

  /// No description provided for @supportFaqQ2.
  ///
  /// In en, this message translates to:
  /// **'Can I change my training days?'**
  String get supportFaqQ2;

  /// No description provided for @supportFaqA2.
  ///
  /// In en, this message translates to:
  /// **'Yes. Go to Profile → My plan → Training days and select the days that best suit your week. The plan will automatically reorganize.'**
  String get supportFaqA2;

  /// No description provided for @supportFaqQ3.
  ///
  /// In en, this message translates to:
  /// **'What if I skip a workout?'**
  String get supportFaqQ3;

  /// No description provided for @supportFaqA3.
  ///
  /// In en, this message translates to:
  /// **'No problem. Fitnflai detects the missed session and adjusts the weekly load so as not to compromise your progress. You can mark the reason in the daily check-in.'**
  String get supportFaqA3;

  /// No description provided for @supportFaqQ4.
  ///
  /// In en, this message translates to:
  /// **'How do I connect my Garmin or Strava?'**
  String get supportFaqQ4;

  /// No description provided for @supportFaqA4.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → Apps and devices. From there you can connect Garmin, Strava or your health app. Once connected, your activity data will automatically sync.'**
  String get supportFaqA4;

  /// No description provided for @supportFaqQ5.
  ///
  /// In en, this message translates to:
  /// **'Can I use Fitnflai without a wearable device?'**
  String get supportFaqQ5;

  /// No description provided for @supportFaqA5.
  ///
  /// In en, this message translates to:
  /// **'Yes, completely. The wearable enriches the plan with real-time data, but it is not mandatory. You can enter your status manually through the daily check-in.'**
  String get supportFaqA5;

  /// No description provided for @supportFaqQ6.
  ///
  /// In en, this message translates to:
  /// **'How do I cancel my subscription?'**
  String get supportFaqQ6;

  /// No description provided for @supportFaqA6.
  ///
  /// In en, this message translates to:
  /// **'You can cancel from the store where you subscribed (App Store or Google Play). Your active plan will continue until the end of the billed period.'**
  String get supportFaqA6;

  /// No description provided for @connectedAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps and devices'**
  String get connectedAppsTitle;

  /// No description provided for @connectedAppsDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your workouts on compatible devices and sync completed sessions with your favorite applications.'**
  String get connectedAppsDesc;

  /// No description provided for @connectedAppsSectionApps.
  ///
  /// In en, this message translates to:
  /// **'APPLICATIONS'**
  String get connectedAppsSectionApps;

  /// No description provided for @connectedAppsConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connectedAppsConnected;

  /// No description provided for @connectedAppsSectionCalendars.
  ///
  /// In en, this message translates to:
  /// **'CALENDARS'**
  String get connectedAppsSectionCalendars;

  /// No description provided for @connectedAppsConnectCalendar.
  ///
  /// In en, this message translates to:
  /// **'Connect a calendar'**
  String get connectedAppsConnectCalendar;

  /// No description provided for @connectedAppsCalendarDesc.
  ///
  /// In en, this message translates to:
  /// **'Sync your workouts with Google Calendar, Apple Calendar or others.'**
  String get connectedAppsCalendarDesc;

  /// No description provided for @connectedAppsSectionWearables.
  ///
  /// In en, this message translates to:
  /// **'WEARABLE DEVICES'**
  String get connectedAppsSectionWearables;

  /// No description provided for @connectedAppsConnectWearable.
  ///
  /// In en, this message translates to:
  /// **'Connect another wearable device'**
  String get connectedAppsConnectWearable;

  /// No description provided for @connectedAppsDisconnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect {name}'**
  String connectedAppsDisconnectTitle(String name);

  /// No description provided for @connectedAppsDisconnectDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disconnect {name}?'**
  String connectedAppsDisconnectDesc(String name);

  /// No description provided for @connectedAppsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get connectedAppsCancel;

  /// No description provided for @connectedAppsDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get connectedAppsDisconnect;

  /// No description provided for @connectedAppsDisconnectedToast.
  ///
  /// In en, this message translates to:
  /// **'{name} disconnected'**
  String connectedAppsDisconnectedToast(String name);

  /// No description provided for @connectedAppsConnectedToast.
  ///
  /// In en, this message translates to:
  /// **'{name} connected'**
  String connectedAppsConnectedToast(String name);

  /// No description provided for @connectedAppsActionPrompt.
  ///
  /// In en, this message translates to:
  /// **'What do you want to do?'**
  String get connectedAppsActionPrompt;

  /// No description provided for @connectedAppsSync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get connectedAppsSync;

  /// No description provided for @connectedAppsStravaSynced.
  ///
  /// In en, this message translates to:
  /// **'Strava synced'**
  String get connectedAppsStravaSynced;

  /// No description provided for @connectedAppsStravaSyncError.
  ///
  /// In en, this message translates to:
  /// **'Error syncing'**
  String get connectedAppsStravaSyncError;

  /// No description provided for @connectedAppsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} — coming soon'**
  String connectedAppsComingSoon(String feature);

  /// No description provided for @connectedAppsNullUserError.
  ///
  /// In en, this message translates to:
  /// **'Could not load user profile. Please try again.'**
  String get connectedAppsNullUserError;

  /// No description provided for @connectedAppsStravaSyncPrompt.
  ///
  /// In en, this message translates to:
  /// **'Do you want to sync all your workouts?'**
  String get connectedAppsStravaSyncPrompt;

  /// No description provided for @connectedAppsAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get connectedAppsAccept;

  /// No description provided for @connectedAppsSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get connectedAppsSkip;

  /// No description provided for @competitionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Competitions and events'**
  String get competitionsTitle;

  /// No description provided for @competitionsAddEvent.
  ///
  /// In en, this message translates to:
  /// **'Add event'**
  String get competitionsAddEvent;

  /// No description provided for @competitionsEditEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get competitionsEditEvent;

  /// No description provided for @competitionsFieldName.
  ///
  /// In en, this message translates to:
  /// **'Event name'**
  String get competitionsFieldName;

  /// No description provided for @competitionsFieldNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: Bogotá Marathon 2026'**
  String get competitionsFieldNameHint;

  /// No description provided for @competitionsFieldType.
  ///
  /// In en, this message translates to:
  /// **'Event type'**
  String get competitionsFieldType;

  /// No description provided for @competitionsFieldLocation.
  ///
  /// In en, this message translates to:
  /// **'Location (optional)'**
  String get competitionsFieldLocation;

  /// No description provided for @competitionsFieldLocationHint.
  ///
  /// In en, this message translates to:
  /// **'City or venue of the event'**
  String get competitionsFieldLocationHint;

  /// No description provided for @competitionsFieldDate.
  ///
  /// In en, this message translates to:
  /// **'Event date'**
  String get competitionsFieldDate;

  /// No description provided for @competitionsSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get competitionsSelectDate;

  /// No description provided for @competitionsSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get competitionsSaveButton;

  /// No description provided for @competitionsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete event?'**
  String get competitionsDeleteTitle;

  /// No description provided for @competitionsDeleteDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String competitionsDeleteDesc(String name);

  /// No description provided for @competitionsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get competitionsCancel;

  /// No description provided for @competitionsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get competitionsDelete;

  /// No description provided for @shortMonths.
  ///
  /// In en, this message translates to:
  /// **'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec'**
  String get shortMonths;

  /// No description provided for @competitionsStatusPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get competitionsStatusPast;

  /// No description provided for @competitionsStatusToday.
  ///
  /// In en, this message translates to:
  /// **'Today!'**
  String get competitionsStatusToday;

  /// No description provided for @competitionsStatusDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String competitionsStatusDays(int days);

  /// No description provided for @competitionsType5k.
  ///
  /// In en, this message translates to:
  /// **'5K Race'**
  String get competitionsType5k;

  /// No description provided for @competitionsType10k.
  ///
  /// In en, this message translates to:
  /// **'10K Race'**
  String get competitionsType10k;

  /// No description provided for @competitionsTypeHalfMarathon.
  ///
  /// In en, this message translates to:
  /// **'Half Marathon'**
  String get competitionsTypeHalfMarathon;

  /// No description provided for @competitionsTypeMarathon.
  ///
  /// In en, this message translates to:
  /// **'Marathon'**
  String get competitionsTypeMarathon;

  /// No description provided for @competitionsTypeTrail.
  ///
  /// In en, this message translates to:
  /// **'Trail'**
  String get competitionsTypeTrail;

  /// No description provided for @competitionsTypeTriathlon.
  ///
  /// In en, this message translates to:
  /// **'Triathlon'**
  String get competitionsTypeTriathlon;

  /// No description provided for @competitionsTypeCycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get competitionsTypeCycling;

  /// No description provided for @competitionsTypeSwimming.
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get competitionsTypeSwimming;

  /// No description provided for @competitionsTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get competitionsTypeOther;

  /// No description provided for @competitionsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No competitions yet'**
  String get competitionsEmptyTitle;

  /// No description provided for @competitionsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Add the races, triathlons or events you plan to participate in. Your plan will adapt to your dates.'**
  String get competitionsEmptyDesc;

  /// No description provided for @competitionsAddFirst.
  ///
  /// In en, this message translates to:
  /// **'Add first event'**
  String get competitionsAddFirst;

  /// No description provided for @periodicEvalTitle.
  ///
  /// In en, this message translates to:
  /// **'Periodic test'**
  String get periodicEvalTitle;

  /// No description provided for @periodicEvalBanner.
  ///
  /// In en, this message translates to:
  /// **'Record your weight and height every week. This data helps Fitnflai calculate your BMI, effort zones and keep your plan always updated.'**
  String get periodicEvalBanner;

  /// No description provided for @periodicEvalMetrics.
  ///
  /// In en, this message translates to:
  /// **'Body measurements'**
  String get periodicEvalMetrics;

  /// No description provided for @periodicEvalWeight.
  ///
  /// In en, this message translates to:
  /// **'Current weight'**
  String get periodicEvalWeight;

  /// No description provided for @periodicEvalHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get periodicEvalHeight;

  /// No description provided for @periodicEvalCompTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you have body\ncomposition data?'**
  String get periodicEvalCompTitle;

  /// No description provided for @periodicEvalCompDesc.
  ///
  /// In en, this message translates to:
  /// **'If you have a smart scale or bioimpedance report, Fitnflai automatically extracts the data to better customize your plan.'**
  String get periodicEvalCompDesc;

  /// No description provided for @periodicEvalUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload report'**
  String get periodicEvalUploadTitle;

  /// No description provided for @periodicEvalOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get periodicEvalOptional;

  /// No description provided for @periodicEvalUploadHint.
  ///
  /// In en, this message translates to:
  /// **'Upload your scale report'**
  String get periodicEvalUploadHint;

  /// No description provided for @periodicEvalUploadDesc.
  ///
  /// In en, this message translates to:
  /// **'Fitnflai extracts % fat, muscle, body water and BMR to better calibrate your plan.'**
  String get periodicEvalUploadDesc;

  /// No description provided for @periodicEvalUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload photo'**
  String get periodicEvalUploadPhoto;

  /// No description provided for @periodicEvalUploadPdf.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF'**
  String get periodicEvalUploadPdf;

  /// No description provided for @periodicEvalSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get periodicEvalSave;

  /// No description provided for @myTestsTitle.
  ///
  /// In en, this message translates to:
  /// **'My tests'**
  String get myTestsTitle;

  /// No description provided for @myTestsBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Periodic tests = more precise plan'**
  String get myTestsBannerTitle;

  /// No description provided for @myTestsBannerDesc.
  ///
  /// In en, this message translates to:
  /// **'Perform each test every 30 days so Fitnflai can adjust your plan to your real level.'**
  String get myTestsBannerDesc;

  /// No description provided for @myTestsSection.
  ///
  /// In en, this message translates to:
  /// **'YOUR TESTS'**
  String get myTestsSection;

  /// No description provided for @myTestsSquatsName.
  ///
  /// In en, this message translates to:
  /// **'Squats 1 min'**
  String get myTestsSquatsName;

  /// No description provided for @myTestsSquatsCategory.
  ///
  /// In en, this message translates to:
  /// **'Lower body strength'**
  String get myTestsSquatsCategory;

  /// No description provided for @myTestsCooperName.
  ///
  /// In en, this message translates to:
  /// **'Cooper Test'**
  String get myTestsCooperName;

  /// No description provided for @myTestsCooperCategory.
  ///
  /// In en, this message translates to:
  /// **'Cardiovascular endurance'**
  String get myTestsCooperCategory;

  /// No description provided for @myTestsPushupsName.
  ///
  /// In en, this message translates to:
  /// **'Push-ups 1 min'**
  String get myTestsPushupsName;

  /// No description provided for @myTestsPushupsCategory.
  ///
  /// In en, this message translates to:
  /// **'Upper body strength'**
  String get myTestsPushupsCategory;

  /// No description provided for @myTestsPlankName.
  ///
  /// In en, this message translates to:
  /// **'Plank'**
  String get myTestsPlankName;

  /// No description provided for @myTestsPlankCategory.
  ///
  /// In en, this message translates to:
  /// **'Core / Stability'**
  String get myTestsPlankCategory;

  /// No description provided for @myTestsFlexName.
  ///
  /// In en, this message translates to:
  /// **'Forward bend'**
  String get myTestsFlexName;

  /// No description provided for @myTestsFlexCategory.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get myTestsFlexCategory;

  /// No description provided for @myTestsStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get myTestsStatusPending;

  /// No description provided for @myTestsStatusRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get myTestsStatusRepeat;

  /// No description provided for @myTestsStatusDays.
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String myTestsStatusDays(int days);

  /// No description provided for @myTestsLastTime.
  ///
  /// In en, this message translates to:
  /// **'Last time: {date}'**
  String myTestsLastTime(String date);

  /// No description provided for @myTestsBtnRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get myTestsBtnRetake;

  /// No description provided for @myTestsBtnStart.
  ///
  /// In en, this message translates to:
  /// **'Do test'**
  String get myTestsBtnStart;

  /// No description provided for @notificationsSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSettingsTitle;

  /// No description provided for @notificationsSettingsIntensityHeader.
  ///
  /// In en, this message translates to:
  /// **'GENERAL INTENSITY'**
  String get notificationsSettingsIntensityHeader;

  /// No description provided for @notificationsSettingsIntensityLabel.
  ///
  /// In en, this message translates to:
  /// **'Notification frequency'**
  String get notificationsSettingsIntensityLabel;

  /// No description provided for @notificationsSettingsIntensityDesc.
  ///
  /// In en, this message translates to:
  /// **'Control how many notifications you receive in total'**
  String get notificationsSettingsIntensityDesc;

  /// No description provided for @notificationsIntensityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get notificationsIntensityLow;

  /// No description provided for @notificationsIntensityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get notificationsIntensityMedium;

  /// No description provided for @notificationsIntensityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get notificationsIntensityHigh;

  /// No description provided for @notificationsSettingsTypesHeader.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATION TYPES'**
  String get notificationsSettingsTypesHeader;

  /// No description provided for @notificationsSettingsWorkoutsLabel.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get notificationsSettingsWorkoutsLabel;

  /// No description provided for @notificationsSettingsWorkoutsDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminder of your daily session'**
  String get notificationsSettingsWorkoutsDesc;

  /// No description provided for @notificationsSettingsRemindersLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notificationsSettingsRemindersLabel;

  /// No description provided for @notificationsSettingsRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Alerts before your scheduled session'**
  String get notificationsSettingsRemindersDesc;

  /// No description provided for @notificationsSettingsProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly progress'**
  String get notificationsSettingsProgressLabel;

  /// No description provided for @notificationsSettingsProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'Summary of your progress each week'**
  String get notificationsSettingsProgressDesc;

  /// No description provided for @notificationsSettingsNutritionLabel.
  ///
  /// In en, this message translates to:
  /// **'Nutrition and hydration'**
  String get notificationsSettingsNutritionLabel;

  /// No description provided for @notificationsSettingsNutritionDesc.
  ///
  /// In en, this message translates to:
  /// **'Meal and water reminders'**
  String get notificationsSettingsNutritionDesc;

  /// No description provided for @notificationsSettingsOffersLabel.
  ///
  /// In en, this message translates to:
  /// **'Offers and news'**
  String get notificationsSettingsOffersLabel;

  /// No description provided for @notificationsSettingsOffersDesc.
  ///
  /// In en, this message translates to:
  /// **'Fitnflai news and promotions'**
  String get notificationsSettingsOffersDesc;

  /// No description provided for @notificationsSettingsSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get notificationsSettingsSaving;

  /// No description provided for @notificationsSettingsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get notificationsSettingsSave;

  /// No description provided for @notificationsSettingsSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Notifications saved'**
  String get notificationsSettingsSaveSuccess;

  /// No description provided for @notificationsSettingsSaveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving. Try again.'**
  String get notificationsSettingsSaveError;

  /// No description provided for @notificationsPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsPanelTitle;

  /// No description provided for @notificationsPanelMarkAll.
  ///
  /// In en, this message translates to:
  /// **'Mark all'**
  String get notificationsPanelMarkAll;

  /// No description provided for @notificationsPanelEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationsPanelEmptyTitle;

  /// No description provided for @notificationsPanelEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Your alerts and news will appear here.'**
  String get notificationsPanelEmptyDesc;

  /// No description provided for @timeAgoJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeAgoJustNow;

  /// No description provided for @timeAgoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String timeAgoMinutes(int minutes);

  /// No description provided for @timeAgoHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String timeAgoHours(int hours);

  /// No description provided for @timeAgoDays.
  ///
  /// In en, this message translates to:
  /// **'{days} day ago'**
  String timeAgoDays(int days);

  /// No description provided for @timeAgoDaysPlural.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String timeAgoDaysPlural(int days);

  /// No description provided for @dailyCheckinGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name} 👋'**
  String dailyCheckinGreeting(String name);

  /// No description provided for @dailyCheckinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tuesday · Today\'s session: Zone 2 Run'**
  String get dailyCheckinSubtitle;

  /// No description provided for @dailyCheckinHeaderDesc.
  ///
  /// In en, this message translates to:
  /// **'Answer 4 quick questions so the AI can adjust your session today.'**
  String get dailyCheckinHeaderDesc;

  /// No description provided for @dailyCheckinQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Question {index} · {label}'**
  String dailyCheckinQuestionLabel(int index, String label);

  /// No description provided for @dailyCheckinLabelSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get dailyCheckinLabelSleep;

  /// No description provided for @dailyCheckinLabelEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get dailyCheckinLabelEnergy;

  /// No description provided for @dailyCheckinLabelPain.
  ///
  /// In en, this message translates to:
  /// **'Pain or discomfort'**
  String get dailyCheckinLabelPain;

  /// No description provided for @dailyCheckinLabelTime.
  ///
  /// In en, this message translates to:
  /// **'Time available'**
  String get dailyCheckinLabelTime;

  /// No description provided for @dailyCheckinQuestionSleep.
  ///
  /// In en, this message translates to:
  /// **'How did you sleep last night?'**
  String get dailyCheckinQuestionSleep;

  /// No description provided for @dailyCheckinQuestionEnergy.
  ///
  /// In en, this message translates to:
  /// **'How is your energy right now?'**
  String get dailyCheckinQuestionEnergy;

  /// No description provided for @dailyCheckinQuestionPain.
  ///
  /// In en, this message translates to:
  /// **'Do you have any pain or discomfort today?'**
  String get dailyCheckinQuestionPain;

  /// No description provided for @dailyCheckinQuestionTime.
  ///
  /// In en, this message translates to:
  /// **'How much time do you have to train today?'**
  String get dailyCheckinQuestionTime;

  /// No description provided for @dailyCheckinPainNo.
  ///
  /// In en, this message translates to:
  /// **'✓ No, I\'m fine'**
  String get dailyCheckinPainNo;

  /// No description provided for @dailyCheckinPainYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, a little'**
  String get dailyCheckinPainYes;

  /// No description provided for @dailyCheckinPainWhere.
  ///
  /// In en, this message translates to:
  /// **'Where?'**
  String get dailyCheckinPainWhere;

  /// No description provided for @dailyCheckinPainDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Additional details (optional)'**
  String get dailyCheckinPainDetailsHint;

  /// No description provided for @dailyCheckinBtnResult.
  ///
  /// In en, this message translates to:
  /// **'See my adjusted session →'**
  String get dailyCheckinBtnResult;

  /// No description provided for @dailyCheckinBtnAnswerAll.
  ///
  /// In en, this message translates to:
  /// **'Answer all questions'**
  String get dailyCheckinBtnAnswerAll;

  /// No description provided for @dailyCheckinProgressStatus.
  ///
  /// In en, this message translates to:
  /// **'{answered} of {total} answered'**
  String dailyCheckinProgressStatus(int answered, int total);

  /// No description provided for @dailyCheckinScoreSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get dailyCheckinScoreSleep;

  /// No description provided for @dailyCheckinScoreEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get dailyCheckinScoreEnergy;

  /// No description provided for @dailyCheckinScorePain.
  ///
  /// In en, this message translates to:
  /// **'Pain'**
  String get dailyCheckinScorePain;

  /// No description provided for @dailyCheckinScoreTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get dailyCheckinScoreTime;

  /// No description provided for @dailyCheckinPainValueNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get dailyCheckinPainValueNo;

  /// No description provided for @dailyCheckinPainValueMild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get dailyCheckinPainValueMild;

  /// No description provided for @dailyCheckinSemaforoGreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Today you\'re ready to train hard!'**
  String get dailyCheckinSemaforoGreenTitle;

  /// No description provided for @dailyCheckinSemaforoGreenDesc.
  ///
  /// In en, this message translates to:
  /// **'You slept well, you have energy and no discomfort. Perfect conditions for your running session.'**
  String get dailyCheckinSemaforoGreenDesc;

  /// No description provided for @dailyCheckinSemaforoGreenBadge.
  ///
  /// In en, this message translates to:
  /// **'✓ Full session · no changes'**
  String get dailyCheckinSemaforoGreenBadge;

  /// No description provided for @dailyCheckinSemaforoYellowTitle.
  ///
  /// In en, this message translates to:
  /// **'Today you\'re not at 100% — the AI adjusted your session'**
  String get dailyCheckinSemaforoYellowTitle;

  /// No description provided for @dailyCheckinSemaforoYellowDesc.
  ///
  /// In en, this message translates to:
  /// **'You slept little and energy is low. You can train, but with less load. Your plan is not affected.'**
  String get dailyCheckinSemaforoYellowDesc;

  /// No description provided for @dailyCheckinSemaforoYellowBadge.
  ///
  /// In en, this message translates to:
  /// **'⚡ Adjusted'**
  String get dailyCheckinSemaforoYellowBadge;

  /// No description provided for @dailyCheckinSemaforoRedTitle.
  ///
  /// In en, this message translates to:
  /// **'Today your body needs rest'**
  String get dailyCheckinSemaforoRedTitle;

  /// No description provided for @dailyCheckinSemaforoRedDesc.
  ///
  /// In en, this message translates to:
  /// **'Very little sleep, no energy and strong pain. Training today increases the risk of injury.'**
  String get dailyCheckinSemaforoRedDesc;

  /// No description provided for @dailyCheckinSemaforoRedBadge.
  ///
  /// In en, this message translates to:
  /// **'↔ Alternative'**
  String get dailyCheckinSemaforoRedBadge;

  /// No description provided for @dailyCheckinSessionTitleGreen.
  ///
  /// In en, this message translates to:
  /// **'Base run · Zone 2'**
  String get dailyCheckinSessionTitleGreen;

  /// No description provided for @dailyCheckinSessionSubGreen.
  ///
  /// In en, this message translates to:
  /// **'Tuesday · Week 3 of 18'**
  String get dailyCheckinSessionSubGreen;

  /// No description provided for @dailyCheckinSessionTitleYellow.
  ///
  /// In en, this message translates to:
  /// **'Base run · Zone 2 · Reduced'**
  String get dailyCheckinSessionTitleYellow;

  /// No description provided for @dailyCheckinSessionSubYellow.
  ///
  /// In en, this message translates to:
  /// **'Adjusted version by the AI for today'**
  String get dailyCheckinSessionSubYellow;

  /// No description provided for @dailyCheckinSessionTitleRed.
  ///
  /// In en, this message translates to:
  /// **'Mobility and breathing'**
  String get dailyCheckinSessionTitleRed;

  /// No description provided for @dailyCheckinSessionSubRed.
  ///
  /// In en, this message translates to:
  /// **'Recommended alternative · Active rest'**
  String get dailyCheckinSessionSubRed;

  /// No description provided for @dailyCheckinSessionChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'What did the AI change?'**
  String get dailyCheckinSessionChangeTitle;

  /// No description provided for @dailyCheckinSessionChangeDesc.
  ///
  /// In en, this message translates to:
  /// **'Reduced duration. Lower target HR. The volume lost today is redistributed to Thursday.'**
  String get dailyCheckinSessionChangeDesc;

  /// No description provided for @dailyCheckinSessionReducePct.
  ///
  /// In en, this message translates to:
  /// **'-30% intensity'**
  String get dailyCheckinSessionReducePct;

  /// No description provided for @dailyCheckinSessionNoFc.
  ///
  /// In en, this message translates to:
  /// **'No target HR'**
  String get dailyCheckinSessionNoFc;

  /// No description provided for @dailyCheckinPainAlertUrgent.
  ///
  /// In en, this message translates to:
  /// **'Strong pain · Recommended action'**
  String get dailyCheckinPainAlertUrgent;

  /// No description provided for @dailyCheckinPainAlertNormal.
  ///
  /// In en, this message translates to:
  /// **'Discomfort recorded · {zone}'**
  String dailyCheckinPainAlertNormal(String zone);

  /// No description provided for @dailyCheckinPainAlertUrgentDesc.
  ///
  /// In en, this message translates to:
  /// **'You reported strong pain. If it has lasted more than 2 days, consider consulting a sports specialist.'**
  String get dailyCheckinPainAlertUrgentDesc;

  /// No description provided for @dailyCheckinPainAlertNormalDesc.
  ///
  /// In en, this message translates to:
  /// **'The AI removed high-impact exercises. If the discomfort persists tomorrow, activate the injury protocol.'**
  String get dailyCheckinPainAlertNormalDesc;

  /// No description provided for @dailyCheckinInsightTitle.
  ///
  /// In en, this message translates to:
  /// **'The AI says'**
  String get dailyCheckinInsightTitle;

  /// No description provided for @dailyCheckinInsightGreen.
  ///
  /// In en, this message translates to:
  /// **'With good sleep and high energy, this is an ideal session to work on your aerobic base. Keep HR below 130 bpm. Hydration: 500ml before going out.'**
  String get dailyCheckinInsightGreen;

  /// No description provided for @dailyCheckinInsightYellow.
  ///
  /// In en, this message translates to:
  /// **'Poor sleep raises cortisol and reduces muscle recovery capacity. Today is not a day to push — 35 gentle minutes keep you active without risk.'**
  String get dailyCheckinInsightYellow;

  /// No description provided for @dailyCheckinInsightRed.
  ///
  /// In en, this message translates to:
  /// **'A rest day today doesn\'t ruin your 18 weeks — ignoring your body\'s signals does. The running session moves to Thursday.'**
  String get dailyCheckinInsightRed;

  /// No description provided for @dailyCheckinCtaGreen.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go! Start session →'**
  String get dailyCheckinCtaGreen;

  /// No description provided for @dailyCheckinCtaYellow.
  ///
  /// In en, this message translates to:
  /// **'Train the adjusted version'**
  String get dailyCheckinCtaYellow;

  /// No description provided for @dailyCheckinCtaRed.
  ///
  /// In en, this message translates to:
  /// **'Do the 20 min of mobility'**
  String get dailyCheckinCtaRed;

  /// No description provided for @dailyCheckinCtaRestRed.
  ///
  /// In en, this message translates to:
  /// **'Total rest today · Do not train'**
  String get dailyCheckinCtaRestRed;

  /// No description provided for @dailyCheckinCtaRestNormal.
  ///
  /// In en, this message translates to:
  /// **'Rest today · mark as free day'**
  String get dailyCheckinCtaRestNormal;

  /// No description provided for @dailyCheckinCtaBottomNote.
  ///
  /// In en, this message translates to:
  /// **'Your plan adjusts automatically · You are still on track'**
  String get dailyCheckinCtaBottomNote;

  /// No description provided for @dailyCheckinSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Daily status successfully recorded.'**
  String get dailyCheckinSaveSuccess;

  /// No description provided for @dailyCheckinSaveError.
  ///
  /// In en, this message translates to:
  /// **'Connection error or error recording status: {error}'**
  String dailyCheckinSaveError(String error);

  /// No description provided for @workoutDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout detail'**
  String get workoutDetailTitle;

  /// No description provided for @workoutDetailObj.
  ///
  /// In en, this message translates to:
  /// **'Objective'**
  String get workoutDetailObj;

  /// No description provided for @workoutDetailCal.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get workoutDetailCal;

  /// No description provided for @workoutDetailDes.
  ///
  /// In en, this message translates to:
  /// **'Cool-down'**
  String get workoutDetailDes;

  /// No description provided for @workoutDetailPrinc.
  ///
  /// In en, this message translates to:
  /// **'Main block'**
  String get workoutDetailPrinc;

  /// No description provided for @workoutDetailInt.
  ///
  /// In en, this message translates to:
  /// **'Intervals'**
  String get workoutDetailInt;

  /// No description provided for @workoutDetailMealPre.
  ///
  /// In en, this message translates to:
  /// **'Pre-workout meal'**
  String get workoutDetailMealPre;

  /// No description provided for @workoutDetailMealPost.
  ///
  /// In en, this message translates to:
  /// **'Post-workout meal'**
  String get workoutDetailMealPost;

  /// No description provided for @workoutDetailStart.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get workoutDetailStart;

  /// No description provided for @workoutDetailDuration.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String workoutDetailDuration(int minutes);

  /// No description provided for @workoutActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Active workout'**
  String get workoutActiveTitle;

  /// No description provided for @workoutActiveTimer.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get workoutActiveTimer;

  /// No description provided for @workoutActivePace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get workoutActivePace;

  /// No description provided for @workoutActiveHr.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get workoutActiveHr;

  /// No description provided for @workoutActiveDist.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get workoutActiveDist;

  /// No description provided for @workoutActivePause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get workoutActivePause;

  /// No description provided for @workoutActiveResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get workoutActiveResume;

  /// No description provided for @workoutActiveFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get workoutActiveFinish;

  /// No description provided for @workoutActiveCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get workoutActiveCancel;

  /// No description provided for @workoutActiveConfirmFinishTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish workout?'**
  String get workoutActiveConfirmFinishTitle;

  /// No description provided for @workoutActiveConfirmFinishDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to finish this session?'**
  String get workoutActiveConfirmFinishDesc;

  /// No description provided for @workoutFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout feedback'**
  String get workoutFeedbackTitle;

  /// No description provided for @workoutFeedbackFeelingQuestion.
  ///
  /// In en, this message translates to:
  /// **'How did you feel?'**
  String get workoutFeedbackFeelingQuestion;

  /// No description provided for @workoutFeedbackRpeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Perceived exertion (RPE)'**
  String get workoutFeedbackRpeQuestion;

  /// No description provided for @workoutFeedbackRpe1.
  ///
  /// In en, this message translates to:
  /// **'Very light'**
  String get workoutFeedbackRpe1;

  /// No description provided for @workoutFeedbackRpe2.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get workoutFeedbackRpe2;

  /// No description provided for @workoutFeedbackRpe3.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get workoutFeedbackRpe3;

  /// No description provided for @workoutFeedbackRpe4.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get workoutFeedbackRpe4;

  /// No description provided for @workoutFeedbackRpe5.
  ///
  /// In en, this message translates to:
  /// **'Maximal effort'**
  String get workoutFeedbackRpe5;

  /// No description provided for @workoutFeedbackFeeling1.
  ///
  /// In en, this message translates to:
  /// **'Exhausted'**
  String get workoutFeedbackFeeling1;

  /// No description provided for @workoutFeedbackFeeling2.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get workoutFeedbackFeeling2;

  /// No description provided for @workoutFeedbackFeeling3.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get workoutFeedbackFeeling3;

  /// No description provided for @workoutFeedbackFeeling4.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get workoutFeedbackFeeling4;

  /// No description provided for @workoutFeedbackFeeling5.
  ///
  /// In en, this message translates to:
  /// **'Invincible'**
  String get workoutFeedbackFeeling5;

  /// No description provided for @workoutFeedbackPainQuestion.
  ///
  /// In en, this message translates to:
  /// **'Did you feel any pain?'**
  String get workoutFeedbackPainQuestion;

  /// No description provided for @workoutFeedbackSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit feedback'**
  String get workoutFeedbackSubmit;

  /// No description provided for @dailyCheckinSleepOpt1.
  ///
  /// In en, this message translates to:
  /// **'Very bad'**
  String get dailyCheckinSleepOpt1;

  /// No description provided for @dailyCheckinSleepOpt2.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get dailyCheckinSleepOpt2;

  /// No description provided for @dailyCheckinSleepOpt3.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get dailyCheckinSleepOpt3;

  /// No description provided for @dailyCheckinSleepOpt4.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get dailyCheckinSleepOpt4;

  /// No description provided for @dailyCheckinSleepOpt5.
  ///
  /// In en, this message translates to:
  /// **'Very good'**
  String get dailyCheckinSleepOpt5;

  /// No description provided for @dailyCheckinEnergyOpt1.
  ///
  /// In en, this message translates to:
  /// **'No energy'**
  String get dailyCheckinEnergyOpt1;

  /// No description provided for @dailyCheckinEnergyOpt2.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get dailyCheckinEnergyOpt2;

  /// No description provided for @dailyCheckinEnergyOpt3.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get dailyCheckinEnergyOpt3;

  /// No description provided for @dailyCheckinEnergyOpt4.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get dailyCheckinEnergyOpt4;

  /// No description provided for @dailyCheckinEnergyOpt5.
  ///
  /// In en, this message translates to:
  /// **'Maxed out'**
  String get dailyCheckinEnergyOpt5;

  /// No description provided for @dailyCheckinTimeOpt1.
  ///
  /// In en, this message translates to:
  /// **'just right'**
  String get dailyCheckinTimeOpt1;

  /// No description provided for @dailyCheckinTimeOpt2.
  ///
  /// In en, this message translates to:
  /// **'normal'**
  String get dailyCheckinTimeOpt2;

  /// No description provided for @dailyCheckinTimeOpt3.
  ///
  /// In en, this message translates to:
  /// **'good'**
  String get dailyCheckinTimeOpt3;

  /// No description provided for @dailyCheckinTimeOpt4.
  ///
  /// In en, this message translates to:
  /// **'plenty'**
  String get dailyCheckinTimeOpt4;

  /// No description provided for @dailyCheckinTimeOpt5.
  ///
  /// In en, this message translates to:
  /// **'full'**
  String get dailyCheckinTimeOpt5;

  /// No description provided for @painZoneCuello.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get painZoneCuello;

  /// No description provided for @painZoneHombro.
  ///
  /// In en, this message translates to:
  /// **'Shoulder'**
  String get painZoneHombro;

  /// No description provided for @painZoneEspaldaAlta.
  ///
  /// In en, this message translates to:
  /// **'Upper back'**
  String get painZoneEspaldaAlta;

  /// No description provided for @painZoneLumbar.
  ///
  /// In en, this message translates to:
  /// **'Lower back'**
  String get painZoneLumbar;

  /// No description provided for @painZoneCadera.
  ///
  /// In en, this message translates to:
  /// **'Hip'**
  String get painZoneCadera;

  /// No description provided for @painZoneRodilla.
  ///
  /// In en, this message translates to:
  /// **'Knee'**
  String get painZoneRodilla;

  /// No description provided for @painZoneTobillo.
  ///
  /// In en, this message translates to:
  /// **'Ankle'**
  String get painZoneTobillo;

  /// No description provided for @painZoneOtro.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get painZoneOtro;

  /// No description provided for @workoutDetailDesc.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get workoutDetailDesc;

  /// No description provided for @workoutDetailNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get workoutDetailNotes;

  /// No description provided for @workoutDetailNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get workoutDetailNutrition;

  /// No description provided for @workoutDetailDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get workoutDetailDurationTitle;

  /// No description provided for @workoutDetailExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get workoutDetailExercises;

  /// No description provided for @workoutDetailNoExercises.
  ///
  /// In en, this message translates to:
  /// **'No exercises available'**
  String get workoutDetailNoExercises;

  /// No description provided for @workoutDetailDayNutrition.
  ///
  /// In en, this message translates to:
  /// **'Daily nutrition'**
  String get workoutDetailDayNutrition;

  /// No description provided for @workoutDetailCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get workoutDetailCompleted;

  /// No description provided for @workoutDetailCompletedBanner.
  ///
  /// In en, this message translates to:
  /// **'Workout completed!'**
  String get workoutDetailCompletedBanner;

  /// No description provided for @mealBreakfast.
  ///
  /// In en, this message translates to:
  /// **'BREAKFAST'**
  String get mealBreakfast;

  /// No description provided for @mealLunch.
  ///
  /// In en, this message translates to:
  /// **'LUNCH'**
  String get mealLunch;

  /// No description provided for @mealDinner.
  ///
  /// In en, this message translates to:
  /// **'DINNER'**
  String get mealDinner;

  /// No description provided for @mealPreWorkout.
  ///
  /// In en, this message translates to:
  /// **'PRE-WORKOUT · 30-60 MIN BEFORE'**
  String get mealPreWorkout;

  /// No description provided for @mealPostWorkout.
  ///
  /// In en, this message translates to:
  /// **'POST-WORKOUT · +30 MIN AFTER'**
  String get mealPostWorkout;

  /// No description provided for @mealSnack.
  ///
  /// In en, this message translates to:
  /// **'SNACK'**
  String get mealSnack;

  /// No description provided for @mealDuring.
  ///
  /// In en, this message translates to:
  /// **'DURING · IF +60 MIN'**
  String get mealDuring;

  /// No description provided for @statsSeriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sets'**
  String statsSeriesCount(int count);

  /// No description provided for @statsRepsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reps'**
  String statsRepsCount(int count);

  /// No description provided for @statsMinCount.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String statsMinCount(int count);

  /// No description provided for @workoutActiveExterior.
  ///
  /// In en, this message translates to:
  /// **'Exterior'**
  String get workoutActiveExterior;

  /// No description provided for @workoutActiveInterior.
  ///
  /// In en, this message translates to:
  /// **'Interior'**
  String get workoutActiveInterior;

  /// No description provided for @workoutActiveExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit workout?'**
  String get workoutActiveExitTitle;

  /// No description provided for @workoutActiveExitDesc.
  ///
  /// In en, this message translates to:
  /// **'Progress will be lost.'**
  String get workoutActiveExitDesc;

  /// No description provided for @workoutActiveExitContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get workoutActiveExitContinue;

  /// No description provided for @workoutActiveExitBtn.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get workoutActiveExitBtn;

  /// No description provided for @workoutActiveExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get workoutActiveExercises;

  /// No description provided for @workoutActiveNow.
  ///
  /// In en, this message translates to:
  /// **'NOW'**
  String get workoutActiveNow;

  /// No description provided for @workoutActiveModeQuestion.
  ///
  /// In en, this message translates to:
  /// **'This exercise can be done outdoors or indoors.\nWhere will you do it?'**
  String get workoutActiveModeQuestion;

  /// No description provided for @workoutActiveSets.
  ///
  /// In en, this message translates to:
  /// **'SETS'**
  String get workoutActiveSets;

  /// No description provided for @workoutActiveReps.
  ///
  /// In en, this message translates to:
  /// **'REPS'**
  String get workoutActiveReps;

  /// No description provided for @workoutActiveSpeed.
  ///
  /// In en, this message translates to:
  /// **'SPEED'**
  String get workoutActiveSpeed;

  /// No description provided for @workoutActiveSetLabel.
  ///
  /// In en, this message translates to:
  /// **'Set {number}'**
  String workoutActiveSetLabel(int number);

  /// No description provided for @workoutActivePosInicial.
  ///
  /// In en, this message translates to:
  /// **'Initial Position'**
  String get workoutActivePosInicial;

  /// No description provided for @workoutActiveEjecucion.
  ///
  /// In en, this message translates to:
  /// **'Execution'**
  String get workoutActiveEjecucion;

  /// No description provided for @workoutActiveConsejos.
  ///
  /// In en, this message translates to:
  /// **'Technical Tips'**
  String get workoutActiveConsejos;

  /// No description provided for @workoutActiveNoPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview not available'**
  String get workoutActiveNoPreview;

  /// No description provided for @workoutActiveStartBtn.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get workoutActiveStartBtn;

  /// No description provided for @workoutActiveCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get workoutActiveCompleted;

  /// No description provided for @workoutActiveCompleteSets.
  ///
  /// In en, this message translates to:
  /// **'Complete the sets'**
  String get workoutActiveCompleteSets;

  /// No description provided for @workoutActiveMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark done'**
  String get workoutActiveMarkDone;

  /// No description provided for @workoutActiveNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get workoutActiveNext;

  /// No description provided for @workoutActiveTapFinish.
  ///
  /// In en, this message translates to:
  /// **'Tap  🏁  to finish'**
  String get workoutActiveTapFinish;

  /// No description provided for @workoutActiveHoldFinish.
  ///
  /// In en, this message translates to:
  /// **'Hold  🏁  to finish'**
  String get workoutActiveHoldFinish;

  /// No description provided for @workoutFeedbackQuestion.
  ///
  /// In en, this message translates to:
  /// **'How was the workout?'**
  String get workoutFeedbackQuestion;

  /// No description provided for @workoutFeedbackFinished.
  ///
  /// In en, this message translates to:
  /// **'Routine finished!'**
  String get workoutFeedbackFinished;

  /// No description provided for @workoutFeedbackTime.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get workoutFeedbackTime;

  /// No description provided for @workoutFeedbackDistance.
  ///
  /// In en, this message translates to:
  /// **'DISTANCE'**
  String get workoutFeedbackDistance;

  /// No description provided for @workoutFeedbackMode.
  ///
  /// In en, this message translates to:
  /// **'MODE'**
  String get workoutFeedbackMode;

  /// No description provided for @workoutFeedbackOutdoor.
  ///
  /// In en, this message translates to:
  /// **'🌤 Outdoor'**
  String get workoutFeedbackOutdoor;

  /// No description provided for @workoutFeedbackIndoor.
  ///
  /// In en, this message translates to:
  /// **'🏠 Indoor'**
  String get workoutFeedbackIndoor;

  /// No description provided for @workoutFeedbackDidComplete.
  ///
  /// In en, this message translates to:
  /// **'Did you complete the routine?'**
  String get workoutFeedbackDidComplete;

  /// No description provided for @workoutFeedbackYesComplete.
  ///
  /// In en, this message translates to:
  /// **'Yes, complete'**
  String get workoutFeedbackYesComplete;

  /// No description provided for @workoutFeedbackPartially.
  ///
  /// In en, this message translates to:
  /// **'Partially'**
  String get workoutFeedbackPartially;

  /// No description provided for @workoutFeedbackEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get workoutFeedbackEasy;

  /// No description provided for @workoutFeedbackMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get workoutFeedbackMax;

  /// No description provided for @workoutFeedbackRpeEasy.
  ///
  /// In en, this message translates to:
  /// **'Very easy'**
  String get workoutFeedbackRpeEasy;

  /// No description provided for @workoutFeedbackRpeModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get workoutFeedbackRpeModerate;

  /// No description provided for @workoutFeedbackRpeSomewhatHard.
  ///
  /// In en, this message translates to:
  /// **'Somewhat hard'**
  String get workoutFeedbackRpeSomewhatHard;

  /// No description provided for @workoutFeedbackRpeHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get workoutFeedbackRpeHard;

  /// No description provided for @workoutFeedbackRpeMax.
  ///
  /// In en, this message translates to:
  /// **'Max effort'**
  String get workoutFeedbackRpeMax;

  /// No description provided for @workoutFeedbackFeelingVeryTired.
  ///
  /// In en, this message translates to:
  /// **'Very tired'**
  String get workoutFeedbackFeelingVeryTired;

  /// No description provided for @workoutFeedbackFeelingTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get workoutFeedbackFeelingTired;

  /// No description provided for @workoutFeedbackFeelingGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get workoutFeedbackFeelingGood;

  /// No description provided for @workoutFeedbackFeelingGreat.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get workoutFeedbackFeelingGreat;

  /// No description provided for @workoutFeedbackYesPain.
  ///
  /// In en, this message translates to:
  /// **'Yes, a little'**
  String get workoutFeedbackYesPain;

  /// No description provided for @workoutFeedbackNoPain.
  ///
  /// In en, this message translates to:
  /// **'No, none'**
  String get workoutFeedbackNoPain;

  /// No description provided for @workoutFeedbackPainHint.
  ///
  /// In en, this message translates to:
  /// **'Body part, type of pain...'**
  String get workoutFeedbackPainHint;

  /// No description provided for @workoutFeedbackAdditionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional notes'**
  String get workoutFeedbackAdditionalNotes;

  /// No description provided for @workoutFeedbackOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get workoutFeedbackOptional;

  /// No description provided for @workoutFeedbackNotesHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: the last sets were harder, my legs felt heavy...'**
  String get workoutFeedbackNotesHint;

  /// No description provided for @workoutFeedbackSaveFinish.
  ///
  /// In en, this message translates to:
  /// **'Save and finish'**
  String get workoutFeedbackSaveFinish;

  /// No description provided for @workoutFeedbackAnswerAll.
  ///
  /// In en, this message translates to:
  /// **'Answer all questions to continue'**
  String get workoutFeedbackAnswerAll;

  /// PARQ question 1
  ///
  /// In en, this message translates to:
  /// **'Has a doctor ever told you that you have a heart condition and that you should only do physical activity under medical supervision?'**
  String get parqQuestion1;

  /// Short label for PARQ question 1
  ///
  /// In en, this message translates to:
  /// **'Question 1 — Diagnosed heart condition.'**
  String get parqShortLabel1;

  /// PARQ question 2
  ///
  /// In en, this message translates to:
  /// **'Do you feel chest pain when doing physical activity?'**
  String get parqQuestion2;

  /// Short label for PARQ question 2
  ///
  /// In en, this message translates to:
  /// **'Question 2 — Chest pain during physical activity.'**
  String get parqShortLabel2;

  /// PARQ question 3
  ///
  /// In en, this message translates to:
  /// **'In the last month, have you felt chest pain at rest?'**
  String get parqQuestion3;

  /// Short label for PARQ question 3
  ///
  /// In en, this message translates to:
  /// **'Question 3 — Chest pain at rest.'**
  String get parqShortLabel3;

  /// PARQ question 4
  ///
  /// In en, this message translates to:
  /// **'Do you lose your balance due to dizziness or have you lost consciousness during or after exercise?'**
  String get parqQuestion4;

  /// Short label for PARQ question 4
  ///
  /// In en, this message translates to:
  /// **'Question 4 — Dizziness or loss of consciousness.'**
  String get parqShortLabel4;

  /// PARQ question 5
  ///
  /// In en, this message translates to:
  /// **'Do you have any bone or joint problems that could worsen with physical activity?'**
  String get parqQuestion5;

  /// Short label for PARQ question 5
  ///
  /// In en, this message translates to:
  /// **'Question 5 — Bone or joint problem.'**
  String get parqShortLabel5;

  /// PARQ question 6
  ///
  /// In en, this message translates to:
  /// **'Does a doctor prescribe medication for blood pressure or a heart condition?'**
  String get parqQuestion6;

  /// Short label for PARQ question 6
  ///
  /// In en, this message translates to:
  /// **'Question 6 — Medication for blood pressure or heart.'**
  String get parqShortLabel6;

  /// PARQ question 7
  ///
  /// In en, this message translates to:
  /// **'Do you know any other reason why you should not do physical activity now?'**
  String get parqQuestion7;

  /// Short label for PARQ question 7
  ///
  /// In en, this message translates to:
  /// **'Question 7 — Other medical reason.'**
  String get parqShortLabel7;

  /// Step label for onboarding, e.g. Step 4 of 6
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStepLabel(int current, int total);

  /// Completed tests count
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} completed'**
  String onboardingTestSelectionCompletedCount(int completed, int total);

  /// Completed title for test selection
  ///
  /// In en, this message translates to:
  /// **'Do you want to take more tests?'**
  String get onboardingTestSelectionCompletedTitle;

  /// Title for test selection
  ///
  /// In en, this message translates to:
  /// **'Functional test battery'**
  String get onboardingTestSelectionTitle;

  /// Completed description for test selection
  ///
  /// In en, this message translates to:
  /// **'Each additional test makes your plan more accurate.'**
  String get onboardingTestSelectionCompletedDesc;

  /// Description for test selection
  ///
  /// In en, this message translates to:
  /// **'We evaluate your actual physical condition. It only takes 20–30 min.'**
  String get onboardingTestSelectionDesc;

  /// Mandatory label
  ///
  /// In en, this message translates to:
  /// **'Mandatory'**
  String get onboardingTestSelectionObligatory;

  /// Completed badge
  ///
  /// In en, this message translates to:
  /// **'✅ Completed'**
  String get onboardingTestSelectionCompletedBadge;

  /// Completed info text
  ///
  /// In en, this message translates to:
  /// **'You can take the remaining tests now or later from \"My tests\" in your profile.'**
  String get onboardingTestSelectionCompletedInfo;

  /// Selection info text
  ///
  /// In en, this message translates to:
  /// **'The squats test is mandatory. The others enrich your profile and make your plan more accurate.'**
  String get onboardingTestSelectionInfo;

  /// Start button with test title
  ///
  /// In en, this message translates to:
  /// **'Start: {title}'**
  String onboardingTestSelectionStartBtn(String title);

  /// Continue to plan CTA
  ///
  /// In en, this message translates to:
  /// **'Continue to plan →'**
  String get onboardingTestSelectionContinueToPlan;

  /// Continue without tests CTA
  ///
  /// In en, this message translates to:
  /// **'Continue without doing more tests →'**
  String get onboardingTestSelectionContinueWithoutTests;

  /// Instruction tab label
  ///
  /// In en, this message translates to:
  /// **'Instruction'**
  String get onboardingTestInstructionTabInstruction;

  /// Record tab label
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get onboardingTestInstructionTabRecord;

  /// Feedback tab label
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get onboardingTestInstructionTabFeedback;

  /// How to title
  ///
  /// In en, this message translates to:
  /// **'How to do it correctly'**
  String get onboardingTestInstructionHowToTitle;

  /// Errors title
  ///
  /// In en, this message translates to:
  /// **'Common errors to avoid'**
  String get onboardingTestInstructionErrorsTitle;

  /// Measures title
  ///
  /// In en, this message translates to:
  /// **'What exactly does this test measure?'**
  String get onboardingTestInstructionMeasuresTitle;

  /// Greeting on instruction top bar
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String onboardingTestInstructionGreeting(String name);

  /// Date subtitle on instruction top bar
  ///
  /// In en, this message translates to:
  /// **'{day} · Week {week}'**
  String onboardingTestInstructionDateSubtitle(String day, int week);

  /// Squats title
  ///
  /// In en, this message translates to:
  /// **'Squats in 1 minute'**
  String get testSquatsTitle;

  /// Squats tag
  ///
  /// In en, this message translates to:
  /// **'Lower body strength'**
  String get testSquatsTag;

  /// Squats short desc
  ///
  /// In en, this message translates to:
  /// **'Stand up, feet shoulder-width apart. Lower down to 90° knee flexion.'**
  String get testSquatsDescShort;

  /// Squats long desc
  ///
  /// In en, this message translates to:
  /// **'Count how many squats you can do in 1 minute. It measures the functional strength of your legs and local muscular endurance — one of the best predictors of athletic performance.'**
  String get testSquatsDescLong;

  /// Squats duration label
  ///
  /// In en, this message translates to:
  /// **'1 min'**
  String get testSquatsDurationLabel;

  /// Squats start label
  ///
  /// In en, this message translates to:
  /// **'Start Squats'**
  String get testSquatsStartLabel;

  /// Squats prep hint
  ///
  /// In en, this message translates to:
  /// **'Stand up, feet shoulder-width apart'**
  String get testSquatsPrepHint;

  /// Squats result hint
  ///
  /// In en, this message translates to:
  /// **'Count complete repetitions'**
  String get testSquatsResultHint;

  /// Squats measures desc
  ///
  /// In en, this message translates to:
  /// **'Strength endurance of quadriceps, glutes, and hamstrings. Predicts your capacity to maintain posture on bike, running stride, and power in any sporting discipline.'**
  String get testSquatsMeasuresDesc;

  /// Squats step 1 main
  ///
  /// In en, this message translates to:
  /// **'Stand with feet shoulder-width apart. Toes slightly pointed outward (15–30°).'**
  String get testSquatsStep1Main;

  /// Squats step 1 tip
  ///
  /// In en, this message translates to:
  /// **'No special footwear is needed — barefoot works perfectly.'**
  String get testSquatsStep1Tip;

  /// Squats step 2 main
  ///
  /// In en, this message translates to:
  /// **'Lower down until thighs are parallel to the floor — or as close as possible. Straight back, chest up.'**
  String get testSquatsStep2Main;

  /// Squats step 2 tip
  ///
  /// In en, this message translates to:
  /// **'If you don\'t reach parallel, go as low as you can without pain.'**
  String get testSquatsStep2Tip;

  /// Squats step 3 main
  ///
  /// In en, this message translates to:
  /// **'Rise by pushing through your heels. Fully extend knees and hips when reaching the top.'**
  String get testSquatsStep3Main;

  /// Squats step 3 tip
  ///
  /// In en, this message translates to:
  /// **'Each rep counts only if you go all the way down AND all the way up.'**
  String get testSquatsStep3Tip;

  /// Squats step 4 main
  ///
  /// In en, this message translates to:
  /// **'Repeat at a pace you can maintain for the full 60 seconds. You can pause briefly if needed.'**
  String get testSquatsStep4Main;

  /// Squats step 4 tip
  ///
  /// In en, this message translates to:
  /// **'The timer does not stop.'**
  String get testSquatsStep4Tip;

  /// Squats error 1
  ///
  /// In en, this message translates to:
  /// **'Knees caving in — knees should always follow the direction of the feet.'**
  String get testSquatsError1;

  /// Squats error 2
  ///
  /// In en, this message translates to:
  /// **'Heels lifting — if this happens, widen stance or place something thin under heels.'**
  String get testSquatsError2;

  /// Squats error 3
  ///
  /// In en, this message translates to:
  /// **'Rounded back — keep chest high throughout the movement.'**
  String get testSquatsError3;

  /// Cooper title
  ///
  /// In en, this message translates to:
  /// **'Cooper Test'**
  String get testCooperTitle;

  /// Cooper tag
  ///
  /// In en, this message translates to:
  /// **'Cardiovascular endurance'**
  String get testCooperTag;

  /// Cooper short desc
  ///
  /// In en, this message translates to:
  /// **'Run or walk fast for 12 continuous minutes. Measure distance in meters.'**
  String get testCooperDescShort;

  /// Cooper long desc
  ///
  /// In en, this message translates to:
  /// **'Run or walk fast for 12 continuous minutes. Measure total distance covered in meters. It is one of the most widely used methods to estimate VO2 Max.'**
  String get testCooperDescLong;

  /// Cooper duration label
  ///
  /// In en, this message translates to:
  /// **'12 min'**
  String get testCooperDurationLabel;

  /// Cooper start label
  ///
  /// In en, this message translates to:
  /// **'Start Cooper Test'**
  String get testCooperStartLabel;

  /// Cooper prep hint
  ///
  /// In en, this message translates to:
  /// **'Position yourself at your starting point'**
  String get testCooperPrepHint;

  /// Cooper result hint
  ///
  /// In en, this message translates to:
  /// **'Record the distance covered when finished'**
  String get testCooperResultHint;

  /// Cooper measures desc
  ///
  /// In en, this message translates to:
  /// **'Maximal aerobic capacity (estimated VO2 Max). Predicts general endurance, recovery between sessions, and potential for cardiovascular improvement.'**
  String get testCooperMeasuresDesc;

  /// Cooper step 1 main
  ///
  /// In en, this message translates to:
  /// **'Look for a flat and measured track or path — ideally a 400m running track.'**
  String get testCooperStep1Main;

  /// Cooper step 1 tip
  ///
  /// In en, this message translates to:
  /// **'A flat street with GPS tracking also works.'**
  String get testCooperStep1Tip;

  /// Cooper step 2 main
  ///
  /// In en, this message translates to:
  /// **'Warm up for 5 minutes by walking or jogging gently before starting the timer.'**
  String get testCooperStep2Main;

  /// Cooper step 3 main
  ///
  /// In en, this message translates to:
  /// **'When starting, run or walk as fast as you can for exactly 12 minutes.'**
  String get testCooperStep3Main;

  /// Cooper step 3 tip
  ///
  /// In en, this message translates to:
  /// **'Maintain a pace you can sustain — do not start too fast.'**
  String get testCooperStep3Tip;

  /// Cooper step 4 main
  ///
  /// In en, this message translates to:
  /// **'When finished, record the total distance covered in meters.'**
  String get testCooperStep4Main;

  /// Cooper step 4 tip
  ///
  /// In en, this message translates to:
  /// **'FitnFlai will automatically calculate your estimated VO2 Max.'**
  String get testCooperStep4Tip;

  /// Cooper error 1
  ///
  /// In en, this message translates to:
  /// **'Starting too fast and exhausting yourself in the first few minutes.'**
  String get testCooperError1;

  /// Cooper error 2
  ///
  /// In en, this message translates to:
  /// **'Taking long breaks — if you need to walk, it\'s fine, but keep moving.'**
  String get testCooperError2;

  /// Cooper error 3
  ///
  /// In en, this message translates to:
  /// **'Not measuring distance accurately — use GPS or a known track.'**
  String get testCooperError3;

  /// Pushups title
  ///
  /// In en, this message translates to:
  /// **'Push-ups in 1 minute'**
  String get testPushupsTitle;

  /// Pushups tag
  ///
  /// In en, this message translates to:
  /// **'Upper body strength'**
  String get testPushupsTag;

  /// Pushups short desc
  ///
  /// In en, this message translates to:
  /// **'Full plank. Lower down until chest almost touches the floor.'**
  String get testPushupsDescShort;

  /// Pushups long desc
  ///
  /// In en, this message translates to:
  /// **'Count how many full push-ups you can do in 1 minute. Measures muscular strength and endurance of the chest, shoulders, and triceps.'**
  String get testPushupsDescLong;

  /// Pushups duration label
  ///
  /// In en, this message translates to:
  /// **'1 min'**
  String get testPushupsDurationLabel;

  /// Pushups start label
  ///
  /// In en, this message translates to:
  /// **'Start Push-ups'**
  String get testPushupsStartLabel;

  /// Pushups prep hint
  ///
  /// In en, this message translates to:
  /// **'Plank position, ready to start'**
  String get testPushupsPrepHint;

  /// Pushups result hint
  ///
  /// In en, this message translates to:
  /// **'Count complete repetitions'**
  String get testPushupsResultHint;

  /// Pushups measures desc
  ///
  /// In en, this message translates to:
  /// **'Chest, shoulders, and triceps strength-endurance. Predicts your capacity to maintain posture on bike, swimming stroke power, and general stability.'**
  String get testPushupsMeasuresDesc;

  /// Pushups step 1 main
  ///
  /// In en, this message translates to:
  /// **'Full plank position: hands shoulder-width apart, body straight from head to heels.'**
  String get testPushupsStep1Main;

  /// Pushups step 1 tip
  ///
  /// In en, this message translates to:
  /// **'Knees on the floor if you need to modify the difficulty.'**
  String get testPushupsStep1Tip;

  /// Pushups step 2 main
  ///
  /// In en, this message translates to:
  /// **'Lower down until chest almost touches the floor. Elbows at 45° to your body — neither too flared nor tucked.'**
  String get testPushupsStep2Main;

  /// Pushups step 2 tip
  ///
  /// In en, this message translates to:
  /// **'Keep your abdomen contracted throughout the movement.'**
  String get testPushupsStep2Tip;

  /// Pushups step 3 main
  ///
  /// In en, this message translates to:
  /// **'Rise by fully extending your elbows. Only full repetitions count: down AND up.'**
  String get testPushupsStep3Main;

  /// Pushups step 4 main
  ///
  /// In en, this message translates to:
  /// **'Repeat at a pace you can maintain for the full 60 seconds. You can pause briefly.'**
  String get testPushupsStep4Main;

  /// Pushups step 4 tip
  ///
  /// In en, this message translates to:
  /// **'The timer does not stop even if you pause.'**
  String get testPushupsStep4Tip;

  /// Pushups error 1
  ///
  /// In en, this message translates to:
  /// **'Lowering only halfway — chest must almost touch the floor.'**
  String get testPushupsError1;

  /// Pushups error 2
  ///
  /// In en, this message translates to:
  /// **'Hips up or down — body must remain straight.'**
  String get testPushupsError2;

  /// Pushups error 3
  ///
  /// In en, this message translates to:
  /// **'Elbows too wide (90°) — increases risk of shoulder injury.'**
  String get testPushupsError3;

  /// Plank title
  ///
  /// In en, this message translates to:
  /// **'Core Plank'**
  String get testPlankTitle;

  /// Plank tag
  ///
  /// In en, this message translates to:
  /// **'Core / Stability'**
  String get testPlankTag;

  /// Plank short desc
  ///
  /// In en, this message translates to:
  /// **'Plank on forearms and feet. Straight body. Maximum time possible.'**
  String get testPlankDescShort;

  /// Plank long desc
  ///
  /// In en, this message translates to:
  /// **'Maintain the plank position as long as possible. Measures core endurance, fundamental for efficiency in all sports.'**
  String get testPlankDescLong;

  /// Plank duration label
  ///
  /// In en, this message translates to:
  /// **'Max. time'**
  String get testPlankDurationLabel;

  /// Plank start label
  ///
  /// In en, this message translates to:
  /// **'Start Plank'**
  String get testPlankStartLabel;

  /// Plank prep hint
  ///
  /// In en, this message translates to:
  /// **'Position on forearms, straight body'**
  String get testPlankPrepHint;

  /// Plank result hint
  ///
  /// In en, this message translates to:
  /// **'Stop the timer when you cannot hold any longer'**
  String get testPlankResultHint;

  /// Plank measures desc
  ///
  /// In en, this message translates to:
  /// **'Isometric endurance of the core (abs, lower back, glutes). Predicts running and biking posture, lower back injury prevention, and force transfer efficiency.'**
  String get testPlankMeasuresDesc;

  /// Plank step 1 main
  ///
  /// In en, this message translates to:
  /// **'Position on forearms and feet: elbows right under shoulders, parallel forearms.'**
  String get testPlankStep1Main;

  /// Plank step 1 tip
  ///
  /// In en, this message translates to:
  /// **'You can interlock your hands or keep them flat.'**
  String get testPlankStep1Tip;

  /// Plank step 2 main
  ///
  /// In en, this message translates to:
  /// **'Body completely straight from head to heels. Activate your abs as if you were about to be punched.'**
  String get testPlankStep2Main;

  /// Plank step 2 tip
  ///
  /// In en, this message translates to:
  /// **'Do not let your hips rise or sag.'**
  String get testPlankStep2Tip;

  /// Plank step 3 main
  ///
  /// In en, this message translates to:
  /// **'Hold the fixed position looking down. Breathe continuously and in a controlled manner.'**
  String get testPlankStep3Main;

  /// Plank step 4 main
  ///
  /// In en, this message translates to:
  /// **'The test ends when hips sag, rise excessively, or the body stops being straight.'**
  String get testPlankStep4Main;

  /// Plank step 4 tip
  ///
  /// In en, this message translates to:
  /// **'FitnFlai records the time in seconds automatically.'**
  String get testPlankStep4Tip;

  /// Plank error 1
  ///
  /// In en, this message translates to:
  /// **'Hips too high — body loses its straight line.'**
  String get testPlankError1;

  /// Plank error 2
  ///
  /// In en, this message translates to:
  /// **'Hips towards floor — compensates for core weakness.'**
  String get testPlankError2;

  /// Plank error 3
  ///
  /// In en, this message translates to:
  /// **'Holding breath — breathe continuously during the entire test.'**
  String get testPlankError3;

  /// Plank error 4
  ///
  /// In en, this message translates to:
  /// **'Elbows too far from shoulders — reduces exercise effectiveness.'**
  String get testPlankError4;

  /// Flexibility title
  ///
  /// In en, this message translates to:
  /// **'Forward Bend'**
  String get testFlexibilityTitle;

  /// Flexibility tag
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get testFlexibilityTag;

  /// Flexibility short desc
  ///
  /// In en, this message translates to:
  /// **'Stand up, legs together. Lean forward as far as possible.'**
  String get testFlexibilityDescShort;

  /// Flexibility long desc
  ///
  /// In en, this message translates to:
  /// **'Measures your hamstring and lumbar flexibility. Flexibility directly impacts your pedaling technique, stride, and injury prevention.'**
  String get testFlexibilityDescLong;

  /// Flexibility duration label
  ///
  /// In en, this message translates to:
  /// **'1 attempt'**
  String get testFlexibilityDurationLabel;

  /// Flexibility start label
  ///
  /// In en, this message translates to:
  /// **'Start Flexibility'**
  String get testFlexibilityStartLabel;

  /// Flexibility prep hint
  ///
  /// In en, this message translates to:
  /// **'Stand up, legs together and extended'**
  String get testFlexibilityPrepHint;

  /// Flexibility result hint
  ///
  /// In en, this message translates to:
  /// **'Select how far your hands reached'**
  String get testFlexibilityResultHint;

  /// Flexibility measures desc
  ///
  /// In en, this message translates to:
  /// **'Flexibility of hamstrings and lower back. Predicts range of motion in pedaling, stride efficiency, and lower back injury risk.'**
  String get testFlexibilityMeasuresDesc;

  /// Flexibility step 1 main
  ///
  /// In en, this message translates to:
  /// **'Stand up, join your feet completely. Legs extended, without bending knees at any moment.'**
  String get testFlexibilityStep1Main;

  /// Flexibility step 1 tip
  ///
  /// In en, this message translates to:
  /// **'You can lean against a wall to maintain balance.'**
  String get testFlexibilityStep1Tip;

  /// Flexibility step 2 main
  ///
  /// In en, this message translates to:
  /// **'Inhale deeply. When exhaling, slowly bend forward bringing your hands towards the floor.'**
  String get testFlexibilityStep2Main;

  /// Flexibility step 2 tip
  ///
  /// In en, this message translates to:
  /// **'No bouncing — movement must be smooth and controlled.'**
  String get testFlexibilityStep2Tip;

  /// Flexibility step 3 main
  ///
  /// In en, this message translates to:
  /// **'Go as far as you can without bending knees or forcing. Hold position for 2–3 seconds.'**
  String get testFlexibilityStep3Main;

  /// Flexibility step 3 tip
  ///
  /// In en, this message translates to:
  /// **'FitnFlai records how far your hands reach.'**
  String get testFlexibilityStep3Tip;

  /// Flexibility step 4 main
  ///
  /// In en, this message translates to:
  /// **'Repeat twice and take the best result.'**
  String get testFlexibilityStep4Main;

  /// Flexibility step 4 tip
  ///
  /// In en, this message translates to:
  /// **'Body usually opens up a bit more on second attempt.'**
  String get testFlexibilityStep4Tip;

  /// Flexibility error 1
  ///
  /// In en, this message translates to:
  /// **'Bending knees — invalidates hamstring stretch.'**
  String get testFlexibilityError1;

  /// Flexibility error 2
  ///
  /// In en, this message translates to:
  /// **'Bouncing downwards — can cause muscle injury.'**
  String get testFlexibilityError2;

  /// Flexibility error 3
  ///
  /// In en, this message translates to:
  /// **'Forcing past the limit — there should be tension, not pain.'**
  String get testFlexibilityError3;

  /// Empty result error
  ///
  /// In en, this message translates to:
  /// **'Enter your result before continuing'**
  String get onboardingTestTimerErrorResultEmpty;

  /// Result save error
  ///
  /// In en, this message translates to:
  /// **'Error saving result. Try again.'**
  String get onboardingTestTimerErrorSave;

  /// Connection error
  ///
  /// In en, this message translates to:
  /// **'Connection error. Try again.'**
  String get onboardingTestTimerErrorConnection;

  /// Free time label
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get onboardingTestTimerBadgeFree;

  /// Completed timer status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get onboardingTestTimerStatusCompleted;

  /// Remaining label
  ///
  /// In en, this message translates to:
  /// **'Time remaining'**
  String get onboardingTestTimerLabelRemaining;

  /// Elapsed label
  ///
  /// In en, this message translates to:
  /// **'Time elapsed'**
  String get onboardingTestTimerLabelElapsed;

  /// Paused status
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get onboardingTestTimerStatusPaused;

  /// Ready status
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get onboardingTestTimerStatusReady;

  /// Reps hint label
  ///
  /// In en, this message translates to:
  /// **'count your reps'**
  String get onboardingTestTimerRepsHint;

  /// Start button
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardingTestTimerBtnStart;

  /// Pause button
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get onboardingTestTimerBtnPause;

  /// Resume button
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get onboardingTestTimerBtnResume;

  /// Finish now button
  ///
  /// In en, this message translates to:
  /// **'Finish now'**
  String get onboardingTestTimerBtnFinish;

  /// Reset from scratch button
  ///
  /// In en, this message translates to:
  /// **'Reset from scratch'**
  String get onboardingTestTimerBtnReset;

  /// Test completed title
  ///
  /// In en, this message translates to:
  /// **'Test completed!'**
  String get onboardingTestTimerSuccessTitle;

  /// Success time label
  ///
  /// In en, this message translates to:
  /// **'Time: {time}'**
  String onboardingTestTimerSuccessTime(String time);

  /// Flexibility question
  ///
  /// In en, this message translates to:
  /// **'How far did your hands reach?'**
  String get onboardingTestTimerFlexibilityQuestion;

  /// Doesn't reach knees
  ///
  /// In en, this message translates to:
  /// **'Doesn\'t reach knees'**
  String get onboardingTestTimerFlexibilityOpt1;

  /// Reaches feet
  ///
  /// In en, this message translates to:
  /// **'Reaches feet'**
  String get onboardingTestTimerFlexibilityOpt2;

  /// Past feet
  ///
  /// In en, this message translates to:
  /// **'Past feet'**
  String get onboardingTestTimerFlexibilityOpt3;

  /// Palms to floor
  ///
  /// In en, this message translates to:
  /// **'Palms to the floor'**
  String get onboardingTestTimerFlexibilityOpt4;

  /// Input result label
  ///
  /// In en, this message translates to:
  /// **'Enter your result in {unit}'**
  String onboardingTestTimerInputLabel(String unit);

  /// Save and continue button
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get onboardingTestTimerBtnSave;

  /// Borg scale question
  ///
  /// In en, this message translates to:
  /// **'How much effort did you perceive? (Borg 6–20)'**
  String get onboardingTestTimerBorgQuestion;

  /// None label
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get onboardingTestTimerBorgLabelNone;

  /// Somewhat hard label
  ///
  /// In en, this message translates to:
  /// **'Somewhat hard'**
  String get onboardingTestTimerBorgLabelHard;

  /// Maximal label
  ///
  /// In en, this message translates to:
  /// **'Maximal'**
  String get onboardingTestTimerBorgLabelMax;

  /// Borg level 6
  ///
  /// In en, this message translates to:
  /// **'No exertion'**
  String get onboardingTestTimerBorgLevel6;

  /// Borg level 7
  ///
  /// In en, this message translates to:
  /// **'Extremely light'**
  String get onboardingTestTimerBorgLevel7;

  /// Borg level 8
  ///
  /// In en, this message translates to:
  /// **'Very light'**
  String get onboardingTestTimerBorgLevel8;

  /// Borg level 9
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get onboardingTestTimerBorgLevel9;

  /// Borg level 10
  ///
  /// In en, this message translates to:
  /// **'Fairly light'**
  String get onboardingTestTimerBorgLevel10;

  /// Borg level 11
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get onboardingTestTimerBorgLevel11;

  /// Borg level 12
  ///
  /// In en, this message translates to:
  /// **'Somewhat hard'**
  String get onboardingTestTimerBorgLevel12;

  /// Borg level 13
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get onboardingTestTimerBorgLevel13;

  /// Borg level 14
  ///
  /// In en, this message translates to:
  /// **'Very hard'**
  String get onboardingTestTimerBorgLevel14;

  /// Borg level 15
  ///
  /// In en, this message translates to:
  /// **'Strenuous'**
  String get onboardingTestTimerBorgLevel15;

  /// Borg level 16
  ///
  /// In en, this message translates to:
  /// **'Very strenuous'**
  String get onboardingTestTimerBorgLevel16;

  /// Borg level 17
  ///
  /// In en, this message translates to:
  /// **'Extremely hard'**
  String get onboardingTestTimerBorgLevel17;

  /// Borg level 18
  ///
  /// In en, this message translates to:
  /// **'Nearly maximal'**
  String get onboardingTestTimerBorgLevel18;

  /// Borg level 19
  ///
  /// In en, this message translates to:
  /// **'Very close to maximal'**
  String get onboardingTestTimerBorgLevel19;

  /// Borg level 20
  ///
  /// In en, this message translates to:
  /// **'Maximal exertion'**
  String get onboardingTestTimerBorgLevel20;

  /// Feedback save error
  ///
  /// In en, this message translates to:
  /// **'Error saving feedback. Try again.'**
  String get onboardingTestFeedbackErrorSave;

  /// Button to save feedback
  ///
  /// In en, this message translates to:
  /// **'Save feedback'**
  String get onboardingTestFeedbackBtnSave;

  /// Prompt to answer all questions before continuing
  ///
  /// In en, this message translates to:
  /// **'Answer all questions to continue'**
  String get onboardingTestFeedbackAnswerAll;

  /// Feedback description
  ///
  /// In en, this message translates to:
  /// **'Tell us how it went — this customizes your plan.'**
  String get onboardingTestFeedbackDesc;

  /// Completion question
  ///
  /// In en, this message translates to:
  /// **'Did you complete the test 100%?'**
  String get onboardingTestFeedbackCompletionQuestion;

  /// Yes complete option
  ///
  /// In en, this message translates to:
  /// **'✓  Yes, complete'**
  String get onboardingTestFeedbackCompletionYes;

  /// Not entirely option
  ///
  /// In en, this message translates to:
  /// **'✗  Not entirely'**
  String get onboardingTestFeedbackCompletionNo;

  /// RPE question
  ///
  /// In en, this message translates to:
  /// **'Did you feel any pain or discomfort?'**
  String get onboardingTestFeedbackRpeQuestion;

  /// RPE scale sublabel
  ///
  /// In en, this message translates to:
  /// **'RPE Scale 1–10'**
  String get onboardingTestFeedbackRpeScale;

  /// Very easy RPE scale label
  ///
  /// In en, this message translates to:
  /// **'Very easy'**
  String get onboardingTestFeedbackRpeScaleEasy;

  /// Maximal effort RPE scale label
  ///
  /// In en, this message translates to:
  /// **'Maximal effort'**
  String get onboardingTestFeedbackRpeScaleMax;

  /// RPE 1-2 label
  ///
  /// In en, this message translates to:
  /// **'Very easy'**
  String get onboardingTestFeedbackRpeLabelVeryEasy;

  /// RPE 3-4 label
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get onboardingTestFeedbackRpeLabelModerate;

  /// RPE 5-6 label
  ///
  /// In en, this message translates to:
  /// **'Somewhat hard'**
  String get onboardingTestFeedbackRpeLabelSomewhatHard;

  /// RPE 7-8 label
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get onboardingTestFeedbackRpeLabelHard;

  /// RPE 9 label
  ///
  /// In en, this message translates to:
  /// **'Very hard'**
  String get onboardingTestFeedbackRpeLabelVeryHard;

  /// RPE 10 label
  ///
  /// In en, this message translates to:
  /// **'Maximal effort'**
  String get onboardingTestFeedbackRpeLabelMax;

  /// Feeling question
  ///
  /// In en, this message translates to:
  /// **'How did you feel during the test?'**
  String get onboardingTestFeedbackFeelingQuestion;

  /// Very tired feeling label
  ///
  /// In en, this message translates to:
  /// **'Very tired'**
  String get onboardingTestFeedbackFeelingVeryTired;

  /// Tired feeling label
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get onboardingTestFeedbackFeelingTired;

  /// Good feeling label
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get onboardingTestFeedbackFeelingGood;

  /// Great feeling label
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get onboardingTestFeedbackFeelingGreat;

  /// Own words input label
  ///
  /// In en, this message translates to:
  /// **'Tell us in your own words (optional)'**
  String get onboardingTestFeedbackFeelingOwnWords;

  /// Own words hint
  ///
  /// In en, this message translates to:
  /// **'E.g.: I felt energetic although it was hard at the end...'**
  String get onboardingTestFeedbackFeelingHint;

  /// Pain question
  ///
  /// In en, this message translates to:
  /// **'Did you feel any pain or discomfort?'**
  String get onboardingTestFeedbackPainQuestion;

  /// Yes some pain label
  ///
  /// In en, this message translates to:
  /// **'Yes, some'**
  String get onboardingTestFeedbackPainYes;

  /// No none pain label
  ///
  /// In en, this message translates to:
  /// **'No, none'**
  String get onboardingTestFeedbackPainNo;

  /// Pain description hint
  ///
  /// In en, this message translates to:
  /// **'Describe it: area of the body, type of pain...'**
  String get onboardingTestFeedbackPainDescHint;

  /// Notes question
  ///
  /// In en, this message translates to:
  /// **'Anything else you want to tell us?'**
  String get onboardingTestFeedbackNotesQuestion;

  /// Optional label
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get onboardingTestFeedbackOptional;

  /// Notes hint
  ///
  /// In en, this message translates to:
  /// **'E.g.: the last reps were harder, my legs felt heavy...'**
  String get onboardingTestFeedbackNotesHint;

  /// Label for stopwatch mode (free timer)
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get onboardingTestTimerModeFree;

  /// Section header for specialists in Profile
  ///
  /// In en, this message translates to:
  /// **'SPECIALIST'**
  String get profileSectionSpecialist;

  /// Menu button to book appointment
  ///
  /// In en, this message translates to:
  /// **'Book specialist session'**
  String get profileMenuBookSpecialist;

  /// Default specialist name
  ///
  /// In en, this message translates to:
  /// **'Dr. Sophia Rodriguez'**
  String get specialistBookingDefaultName;

  /// Default specialist biography
  ///
  /// In en, this message translates to:
  /// **'Sports nutrition and kinesiology specialist. She will guide you to reach your goals by optimizing your plan.'**
  String get specialistBookingDefaultBio;

  /// Price label in checkout
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get specialistBookingCheckoutPrice;

  /// Header for active booking card
  ///
  /// In en, this message translates to:
  /// **'Your scheduled session:'**
  String get profileActiveBookingHeader;

  /// Button to join active session
  ///
  /// In en, this message translates to:
  /// **'Join Session'**
  String get profileActiveBookingJoinBtn;

  /// Button to cancel active session
  ///
  /// In en, this message translates to:
  /// **'Cancel Session'**
  String get profileActiveBookingCancelBtn;

  /// No description provided for @dailyCheckinLabelPulse.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get dailyCheckinLabelPulse;

  /// No description provided for @dailyCheckinQuestionPulse.
  ///
  /// In en, this message translates to:
  /// **'Measure your pulse for 15 seconds with the stopwatch and enter it.'**
  String get dailyCheckinQuestionPulse;

  /// No description provided for @dailyCheckinPulseHint.
  ///
  /// In en, this message translates to:
  /// **'Pulses in 15 sec'**
  String get dailyCheckinPulseHint;

  /// No description provided for @dailyCheckinPulseCalculated.
  ///
  /// In en, this message translates to:
  /// **'Your estimated HR is {bpm} bpm'**
  String dailyCheckinPulseCalculated(String bpm);

  /// No description provided for @dailyCheckinScorePulse.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get dailyCheckinScorePulse;

  /// No description provided for @workoutAdjustmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust workout'**
  String get workoutAdjustmentTitle;

  /// Banner message when no specialist is assigned for booking
  ///
  /// In en, this message translates to:
  /// **'First, you need to select a specialist'**
  String get specialistBookingNoSpecialist;

  /// Message when the specialist has no availability in the next 30 days
  ///
  /// In en, this message translates to:
  /// **'This specialist has no appointments available in the next 30 days'**
  String get specialistBookingNo30DayAvailability;

  /// Message when no slots are available for the selected date
  ///
  /// In en, this message translates to:
  /// **'This specialist has no appointments available for the selected date'**
  String get specialistBookingNoSlotsForSelectedDate;

  /// Title for the Elite plan required message
  ///
  /// In en, this message translates to:
  /// **'Elite Plan Required'**
  String get specialistBookingEliteRequiredTitle;

  /// Description for the Elite plan required message
  ///
  /// In en, this message translates to:
  /// **'To access specialist booking, you need an Elite plan.'**
  String get specialistBookingEliteRequiredDesc;

  /// Button text to upgrade to Elite plan
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan'**
  String get specialistBookingUpgradeBtn;

  /// Message shown when device GPS is disabled on outdoor workout
  ///
  /// In en, this message translates to:
  /// **'Your device GPS is disabled. It is required to train outdoors.'**
  String get workoutActiveGpsDisabled;

  /// Message shown when location permissions are denied on outdoor workout
  ///
  /// In en, this message translates to:
  /// **'Location permissions were denied. Please enable them to train outdoors.'**
  String get workoutActiveGpsDenied;

  /// Message shown when location permissions are permanently denied on outdoor workout
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied. Please enable them in your system settings.'**
  String get workoutActiveGpsDeniedForever;

  /// Title for GPS mandatory dialog
  ///
  /// In en, this message translates to:
  /// **'GPS Required'**
  String get workoutActiveGpsRequired;

  /// Button text to switch to indoor workout mode
  ///
  /// In en, this message translates to:
  /// **'Switch to Indoor'**
  String get workoutActiveSwitchToIndoor;

  /// Button text to open location settings
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get workoutActiveGoToSettings;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// Submit button text
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitButton;

  /// Payment methods menu item on profile screen
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get profileMenuPaymentMethods;

  /// Membership screen: subscribe to plan title
  ///
  /// In en, this message translates to:
  /// **'Subscribe to {planName}'**
  String subscribeToPlan(String planName);

  /// Membership screen: pay with card ending message
  ///
  /// In en, this message translates to:
  /// **'Pay with {brand} ending in {lastFour}'**
  String payWithCardEnding(String brand, String lastFour);

  /// Membership screen: confirm and subscribe button
  ///
  /// In en, this message translates to:
  /// **'Confirm & Subscribe'**
  String get confirmAndSubscribe;

  /// Membership screen: associate card and subscribe button
  ///
  /// In en, this message translates to:
  /// **'Associate Card & Subscribe'**
  String get associateCardAndSubscribe;

  /// Membership screen: processing payment message
  ///
  /// In en, this message translates to:
  /// **'Processing your payment...'**
  String get processingYourPayment;

  /// Membership screen: Nuvei verification message
  ///
  /// In en, this message translates to:
  /// **'We are verifying the transaction with Nuvei. This will take a few seconds, please do not close the app.'**
  String get nuveiVerificationMessage;

  /// Membership screen: payment completed title
  ///
  /// In en, this message translates to:
  /// **'Payment Completed!'**
  String get paymentCompleted;

  /// Membership screen: membership activated message
  ///
  /// In en, this message translates to:
  /// **'Your membership has been successfully activated. You now have full access to all Fitnflai premium features.'**
  String get membershipActivatedMessage;

  /// Membership screen: start training button
  ///
  /// In en, this message translates to:
  /// **'Start Training'**
  String get startTraining;

  /// Loading message for cards
  ///
  /// In en, this message translates to:
  /// **'Loading cards...'**
  String get loadingCards;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
