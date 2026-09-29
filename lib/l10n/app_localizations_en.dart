// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabHome => 'Home';

  @override
  String get tabPlan => 'Plan';

  @override
  String get tabProgress => 'Progress';

  @override
  String get tabNutrition => 'Nutrition';

  @override
  String get tabProfile => 'Profile';

  @override
  String get onboardingParqTitle => 'PAR-Q Assessment';

  @override
  String get onboardingParqSubtitle => 'Cardiovascular fitness';

  @override
  String get onboardingParqDesc =>
      'Answer honestly. These 7 questions determine if it\'s safe for you to start training without medical supervision.';

  @override
  String get onboardingParqValidated => 'Internationally validated · Mandatory';

  @override
  String onboardingParqQuestionLabel(int index, int total) {
    return 'Question $index of $total';
  }

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get onboardingSportSelectionHeader => 'Select your main discipline';

  @override
  String get settingsTitle => 'General';

  @override
  String get settingsSectionAppearance => 'APPEARANCE';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get settingsSectionLanguageUnits => 'LANGUAGE AND UNITS';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsDistance => 'Distance';

  @override
  String get settingsSectionPrivacy => 'PRIVACY';

  @override
  String get settingsPrivacyPolicy => 'Privacy policy';

  @override
  String get settingsTermsConditions => 'Terms and conditions';

  @override
  String get settingsSaveChanges => 'Save changes';

  @override
  String get settingsSavedSuccess => 'Settings saved';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String onboardingSaveError(int statusCode) {
    return 'Error saving ($statusCode)';
  }

  @override
  String get onboardingParqClearTitle => 'You\'re ready to train!';

  @override
  String get onboardingParqClearDesc =>
      'You answered No to all questions. You can safely start your training plan.';

  @override
  String get onboardingParqClearBullet1 =>
      'No cardiovascular contraindications detected';

  @override
  String get onboardingParqClearBullet2 => 'No joint or muscle risk factors';

  @override
  String get onboardingParqClearBullet3 =>
      'No active cardiovascular medication';

  @override
  String get onboardingParqClearConfirmTitle => 'Responsibility confirmation';

  @override
  String get onboardingParqClearConfirmDesc =>
      'By continuing, you confirm that the information provided is correct and that you are fit to start a physical training program.';

  @override
  String get onboardingParqClearCheckboxLabel =>
      'I confirm that the information is correct and I am fit to train.';

  @override
  String get onboardingParqWarningTitle => 'Medical consultation required';

  @override
  String get onboardingParqWarningSubtitle => 'Before starting your plan';

  @override
  String get onboardingParqWarningDesc =>
      'One or more of your answers indicates that you must speak with a doctor before starting an exercise program. This is for your safety — it does not mean you cannot train.';

  @override
  String get onboardingParqWarningAlertTitle =>
      'Answers that triggered the alert';

  @override
  String get onboardingParqWarningHelpTitle => 'What should you do?';

  @override
  String get onboardingParqWarningHelpDesc =>
      'Consult a doctor before starting. Show them this result. Once you get their authorization, you will be able to activate your plan from Fitnflai.';

  @override
  String get onboardingParqWarningUnderstoodButton =>
      'Understood · I will consult with my doctor';

  @override
  String get onboardingParqWarningOverrideTitle =>
      'Do you want to continue anyway?';

  @override
  String get onboardingParqWarningOverrideDesc =>
      'If you already have medical authorization or consider that your answer was an error, you can declare it here. Fitnflai is not responsible if you continue without consulting a professional.';

  @override
  String get onboardingParqWarningOverrideCheckboxLabel =>
      'I have medical authorization and assume the responsibility to continue with the program';

  @override
  String onboardingSportSelected(String sport) {
    return '$sport selected';
  }

  @override
  String get onboardingSportWeeksDurationTitle =>
      'How many weeks\ndo you want your plan to last';

  @override
  String get onboardingSportObligatory => 'Mandatory';

  @override
  String onboardingSportWeeks(int weeks) {
    return '$weeks weeks';
  }

  @override
  String onboardingSportWeeksLabel(int weeks) {
    return '$weeks wk';
  }

  @override
  String onboardingSportMinRecommended(int weeks) {
    return 'min. recommended: $weeks wk';
  }

  @override
  String get onboardingSportTimeTight => 'Very tight schedule';

  @override
  String onboardingSportTimeTightDesc(int weeks) {
    return 'For your level and discipline, we recommend at least $weeks weeks. With less time, the risk of overtraining and injuries increases considerably.';
  }

  @override
  String get onboardingSportTimeTightCheckbox =>
      'I understand the risk and wish to continue under my own responsibility.';

  @override
  String get onboardingSportObligatoryBanner =>
      'This step is mandatory — it defines the structure of your plan.';

  @override
  String get onboardingSportTrailRunning => 'Trail running';

  @override
  String get onboardingSportTrailRunningSubtitle =>
      'Mountain and trail running.';

  @override
  String get onboardingSportTriathlon => 'Triathlon';

  @override
  String get onboardingSportTriathlonSubtitle => 'Swim, bike, run.';

  @override
  String get onboardingSportRoadCycling => 'Road cycling';

  @override
  String get onboardingSportRoadCyclingSubtitle => 'Road and speed.';

  @override
  String get onboardingSportMtb => 'MTB';

  @override
  String get onboardingSportMtbSubtitle => 'Mountain biking.';

  @override
  String get onboardingSportHiking => 'Hiking';

  @override
  String get onboardingSportHikingSubtitle => 'Hiking and trekking.';

  @override
  String get onboardingSportConditioning => 'Conditioning';

  @override
  String get onboardingSportConditioningSubtitle =>
      'Fitness and general strength.';

  @override
  String get onboardingSportPrepRace => 'Prepare for a competition';

  @override
  String get onboardingSportPrepRaceSubtitle => 'I have a target date in mind';

  @override
  String get onboardingSportImproveTime => 'Improve my personal time';

  @override
  String get onboardingSportImproveTimeSubtitle =>
      'I already compete, I want to be faster';

  @override
  String get onboardingSportImproveCondition => 'Improve my general condition';

  @override
  String get onboardingSportImproveConditionSubtitle =>
      'No specific competition for now';

  @override
  String get onboardingSportFormRaceData => 'Give us your competition details';

  @override
  String get onboardingSportFormRaceDataDesc =>
      'Your plan will be structured in phases so that you arrive in your best shape on the day of the competition.';

  @override
  String get onboardingSportFormTimeImprove =>
      'What time do you want to improve';

  @override
  String get onboardingSportFormImprove => 'What do you want to improve';

  @override
  String get onboardingSportDropdownRace => 'Competition';

  @override
  String get onboardingSportDropdownSelectRace => 'Select your competition';

  @override
  String get onboardingSportDropdownSelectSportFirst =>
      'Select a discipline first';

  @override
  String get onboardingSportRaceName => 'Competition name';

  @override
  String get onboardingSportRaceNameHint => 'E.g.: Ultra Trail del Sur';

  @override
  String get onboardingSportDate => 'Date';

  @override
  String get onboardingSportSelectDate => 'Select date';

  @override
  String get onboardingSportDistance => 'Distance';

  @override
  String get onboardingSportDistanceHint => 'E.g.: 15';

  @override
  String onboardingSportRaceWeeksAvailable(int weeks) {
    return '$weeks weeks available · Adjusted plan';
  }

  @override
  String get onboardingSportRaceWeeksRequiredTitle =>
      'Insufficient time to prepare';

  @override
  String onboardingSportRaceWeeksRequiredDesc(
    int weeksAvailable,
    int weeksRequired,
  ) {
    return 'You have $weeksAvailable weeks until one day before your competition, but for your level you need at least $weeksRequired. With this time the risk of injury is high and we cannot guarantee that you will arrive in the best conditions.';
  }

  @override
  String get onboardingSportRaceWeeksRequiredNote =>
      'Even so, we can help you prepare in the best possible way within the available time. 💪';

  @override
  String get onboardingSportRaceWeeksRequiredCheckbox =>
      'I understand the risks and assume responsibility. I want to continue with the preparation on my own.';

  @override
  String get onboardingSportActualTime => 'Actual time';

  @override
  String get onboardingSportTargetTime => 'Target time';

  @override
  String get onboardingSportActualTimeDesc =>
      'Your plan will be structured in phases so you improve your time progressively.';

  @override
  String get onboardingSportTargetTimeError =>
      'Target time must be less than actual time. Your goal is to improve your record.';

  @override
  String get onboardingSportWhatToImprove => 'What do you want to improve?';

  @override
  String get onboardingSportSelectCategory => 'Select a category';

  @override
  String get onboardingSportSpecificGoal => 'What is your specific goal?';

  @override
  String get onboardingSportSelectGoal => 'Select a goal';

  @override
  String get onboardingSportGeneralConditionDesc =>
      'Your plan will be structured in phases to achieve your goal progressively.';

  @override
  String get onboardingProfileBasicTitle => 'Basic profile';

  @override
  String get onboardingProfileBirthdate => 'Date of birth';

  @override
  String get onboardingProfileBirthdateHint => 'DD / MM / YYYY';

  @override
  String get onboardingProfileGender => 'Gender';

  @override
  String get onboardingProfileGenderMale => 'Male';

  @override
  String get onboardingProfileGenderFemale => 'Female';

  @override
  String get onboardingProfileMetricsTitle => 'Body metrics';

  @override
  String get onboardingProfileWeight => 'Current weight';

  @override
  String get onboardingProfileHeight => 'Height';

  @override
  String get onboardingProfileCityTitle => 'City and altitude';

  @override
  String get onboardingProfileCity => 'City';

  @override
  String get onboardingProfileCityHint => 'Search city...';

  @override
  String get onboardingProfileCitySearching => 'Calculating...';

  @override
  String get onboardingProfileAltitude => 'Altitude';

  @override
  String get onboardingProfileAltitudeHint => 'E.g.: 2850';

  @override
  String get onboardingProfileAltitudeActiveTitle => 'Smart altitude activated';

  @override
  String onboardingProfileAltitudeActiveDesc(String altitude) {
    return 'Your plan adjusts HR zones, hydration, and recovery for ${altitude}m a.s.l.';
  }

  @override
  String get onboardingProfileAltitudeActiveDescSimple =>
      'Your plan adjusts HR zones, hydration, and recovery according to your altitude.';

  @override
  String onboardingProfileAltitudeCorrection(String altitude) {
    return '🏔️  $altitude m a.s.l. · Active correction';
  }

  @override
  String get onboardingProfileAltitudeCorrectionSimple =>
      '🏔️  Active correction';

  @override
  String get onboardingProfileMenstrualTitle => 'Female cycle';

  @override
  String get onboardingProfileMenstrualToggle => 'Activate load adaptation';

  @override
  String get onboardingProfileMenstrualDesc =>
      'If you activate it, Fitnflai will adapt the intensity of the plan according to the phases of your menstrual cycle.';

  @override
  String get onboardingProfileMenstrualLastCycle => 'Last cycle';

  @override
  String get onboardingProfileMenstrualCycleStart => 'Start';

  @override
  String get onboardingProfileMenstrualCycleEnd => 'End';

  @override
  String get onboardingProfileMenstrualSelect => 'Select';

  @override
  String get onboardingProfileMenstrualSelectDates => 'Select dates';

  @override
  String onboardingProfileMenstrualRange(int start, int end, String month) {
    return 'From $start to $end of $month';
  }

  @override
  String get onboardingProfileOptional => 'Optional';

  @override
  String get onboardingFitnessActivityTitle => 'Current activity level';

  @override
  String get onboardingFitnessSessionTitle => 'Time per session';

  @override
  String get onboardingFitnessEquipmentTitle => 'Available equipment';

  @override
  String get onboardingFitnessDaysTitle => 'Available days';

  @override
  String get onboardingFitnessDaysSelectAtLeastOne => 'Select at least one day';

  @override
  String onboardingFitnessDaysSelected(int count) {
    return '$count day selected';
  }

  @override
  String onboardingFitnessDaysSelectedPlural(int count) {
    return '$count days selected';
  }

  @override
  String get onboardingFitnessStartTitle => 'When do you want to start';

  @override
  String get onboardingFitnessStartDate => 'Start date';

  @override
  String get onboardingFitnessSelect => 'Select';

  @override
  String get onboardingFitnessExperienceTitle => 'Sports experience';

  @override
  String get onboardingFitnessExercisingNow => 'Do you exercise currently?';

  @override
  String get onboardingFitnessYearsTraining => 'Years training';

  @override
  String get onboardingFitnessInactivityDuration =>
      'Since when do you not exercise?';

  @override
  String get onboardingFitnessCompetedBefore => 'Have you competed before?';

  @override
  String get onboardingBodyInjuriesTitle => 'Injuries and conditions';

  @override
  String get onboardingBodyInjuryActive => 'Active injuries?';

  @override
  String get onboardingBodyInjuryDesc => 'Description of the discomfort';

  @override
  String get onboardingBodyInjuryDescHint =>
      'E.g.: Patellofemoral pain syndrome, hurts when going down slopes';

  @override
  String get onboardingBodyInjuryZone => 'Affected area';

  @override
  String get onboardingBodyInjuryZoneHint => 'E.g.: Right Knee';

  @override
  String get onboardingBodyInjuryType => 'Type of injury';

  @override
  String get onboardingBodyInjuryTypeActive => 'Active';

  @override
  String get onboardingBodyInjuryTypeChronic => 'Chronic';

  @override
  String get onboardingBodyInjuryPainLevel => 'Pain level (VAS: 1–10)';

  @override
  String get onboardingBodySurgery => 'Recent surgeries (last year)?';

  @override
  String get onboardingBodySurgeryHint =>
      'Which one? E.g.: meniscus, shoulder...';

  @override
  String get onboardingBodyPainChronic => 'Chronic or recurring pain?';

  @override
  String get onboardingBodyPainChronicHint => 'Where? E.g.: lumbar, hip...';

  @override
  String get onboardingBodyCardio => 'Diagnosed cardiovascular condition?';

  @override
  String get onboardingBodyCardioHint =>
      'Which one? E.g.: hypertension, arrhythmia...';

  @override
  String get onboardingBodyCompositionTitle =>
      'Do you have body composition data?';

  @override
  String get onboardingBodyCompositionDesc =>
      'If you have a smart scale or bioimpedance report, Fitnflai automatically extracts the data to better customize your plan.';

  @override
  String get onboardingBodyUploadTitle => 'Upload report';

  @override
  String get onboardingBodyUploadProcessing => 'Processing report...';

  @override
  String get onboardingBodyUploadScaleHint => 'Upload your scale report';

  @override
  String get onboardingBodyUploadScaleDesc =>
      'Fitnflai extracts % fat, muscle, body water and BMR to better calibrate your plan.';

  @override
  String get onboardingBodyUploadImageBtn => 'Upload photo';

  @override
  String get onboardingBodyUploadPdfBtn => 'Upload PDF';

  @override
  String get onboardingBodyUploadDeleteBtn => '✕  Delete file';

  @override
  String get onboardingBodyOptionalNote =>
      'This step is completely optional. You can add these details later from your profile.';

  @override
  String get onboardingBodyUploadSuccess => '✅ File uploaded successfully';

  @override
  String get onboardingBodyUploadProcessedSuccess =>
      'Report processed successfully';

  @override
  String get onboardingBodyUploadScaleDataExtracted =>
      'Data extracted from your scale:';

  @override
  String get onboardingBodyUploadSuccessDialogTitle =>
      'Report processed successfully';

  @override
  String get onboardingBodyUploadErrorDialogTitle => 'Could not process';

  @override
  String get onboardingBodyUploadErrorDialogDesc =>
      'It was not possible to extract the data from the report. Make sure the file is readable and try again.';

  @override
  String get onboardingBodyUploadErrorDialogCancel => 'Cancel';

  @override
  String get onboardingBodyUploadErrorDialogRetry => 'Retry';

  @override
  String get onboardingGeneratingPlanTitle => 'Generating your custom plan';

  @override
  String get onboardingGeneratingWorking => 'We are working on your plan.';

  @override
  String get onboardingGeneratingAnalyzing =>
      'Analyzing your data and structuring your plan';

  @override
  String get onboardingGeneratingStepParq => '✓ PAR-Q saved\nsuccessfully';

  @override
  String get onboardingGeneratingStepUserProfile =>
      '✓ User data\nsaved successfully';

  @override
  String get onboardingGeneratingStepPhysical =>
      '✓ Physical data\nsaved successfully';

  @override
  String get onboardingGeneratingStepFitness =>
      '✓ Physical state and availability\nsaved successfully';

  @override
  String get onboardingGeneratingStepMedical =>
      '✓ Medical history and injuries\nsaved successfully';

  @override
  String get onboardingGeneratingStepFunctionalTest =>
      '✓ Functional test\nsaved successfully';

  @override
  String get onboardingGeneratingStepStructuring =>
      'Structuring phases of your plan...';

  @override
  String get onboardingGeneratingStepWeeklySessions =>
      'Generating weekly sessions';

  @override
  String onboardingFeedbackReadyTitle(String name) {
    return 'Ready, $name!';
  }

  @override
  String get onboardingFeedbackReadySubtitle =>
      'Your plan is customized, start and\nachieve your goals.';

  @override
  String get onboardingFeedbackDetailTitle => 'Your plan in detail';

  @override
  String get onboardingFeedbackEcosystemTitle =>
      'What you see here is just the surface. Behind your plan is a ';

  @override
  String get onboardingFeedbackEcosystemHighlight => 'wellness ecosystem';

  @override
  String get onboardingFeedbackWorkingForYou =>
      ' working for you — each session, each intensity, each rest ';

  @override
  String get onboardingFeedbackHasReason => 'has a reason.';

  @override
  String get onboardingFeedbackStartFreeTrial => 'Start my 21 days free';

  @override
  String get onboardingFeedbackDurationLabel => 'Duration';

  @override
  String get onboardingFeedbackStartLabel => 'Start';

  @override
  String get onboardingFeedbackZonesTitle => 'Your training zones';

  @override
  String get onboardingFeedbackZonesDesc =>
      'Each zone indicates exactly how hard to go in each session. Without this, you train blind.';

  @override
  String get onboardingFeedbackZonesHighlight =>
      'Your plan specifies which zone each session goes into.';

  @override
  String get onboardingFeedbackZonesDisclaimer =>
      'As you train, your body improves and these zones change. ';

  @override
  String get onboardingFeedbackZonesDisclaimerAction =>
      'Repeating tests periodically allows adjusting them.';

  @override
  String get authDividerOr => 'or continue with';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get authEmailHint => 'email@example.com';

  @override
  String get authPasswordHint => 'Your password';

  @override
  String get authGoogleButton => 'Continue with Google';

  @override
  String get authAppleButton => 'Continue with Apple';

  @override
  String get authMetaButton => 'Continue with Meta';

  @override
  String get welcomeTitle => 'Choose your language';

  @override
  String get welcomeSubtitle => 'You can change this later in settings';

  @override
  String get welcomeButton => 'Continue';

  @override
  String get welcomeMarketingText => 'Complete wellness, at your pace.';

  @override
  String get loginTitle => 'Log in';

  @override
  String get loginWelcomeBack => 'Welcome back';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get loginNoAccount => 'Don\'t have an account? ';

  @override
  String get loginSignUpLink => 'Sign up →';

  @override
  String get loginButton => 'Log in';

  @override
  String get loginEmailRequired => 'Enter your email';

  @override
  String get loginEmailInvalid => 'Invalid email';

  @override
  String get loginPasswordRequired => 'Enter your password';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Create your account to start';

  @override
  String get registerNameLabel => 'Full name';

  @override
  String get registerNameHint => 'Your name';

  @override
  String get registerNameRequired => 'Enter your name';

  @override
  String get registerUsernameLabel => 'Username';

  @override
  String get registerUsernameHint => '@username';

  @override
  String get registerUsernameRequired => 'Enter a username';

  @override
  String get registerUsernameNoSpaces => 'No spaces';

  @override
  String get registerUsernameTooShort => 'Minimum 3 characters';

  @override
  String get registerEmailInvalid =>
      'Enter a valid email (e.g.: name@gmail.com)';

  @override
  String get registerPasswordRequired => 'Enter a password';

  @override
  String get registerPasswordTooShort => 'Minimum 8 characters';

  @override
  String get registerConfirmPasswordRequired => 'Confirm your password';

  @override
  String get registerPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get registerTermsAccept => 'I accept the ';

  @override
  String get registerTermsLink => 'Terms and Conditions';

  @override
  String get registerAnd => ' and the ';

  @override
  String get registerPrivacyLink => 'Privacy Policy';

  @override
  String get registerAlreadyHaveAccount => 'Already have an account? ';

  @override
  String get registerLoginLink => 'Log in →';

  @override
  String get registerTermsSnackBarError =>
      'You must accept the terms and conditions';

  @override
  String get forgotPasswordTitle => 'Recover password';

  @override
  String get forgotPasswordInstruction =>
      'Enter your email and we will send you\na link to reset your password.';

  @override
  String get forgotPasswordSendButton => 'Send link';

  @override
  String get forgotPasswordBackToLogin => 'Back to login';

  @override
  String get forgotPasswordHasCode => 'I already have a code';

  @override
  String get forgotPasswordErrorSending =>
      'Could not send the link. Verify your email.';

  @override
  String get forgotPasswordConnectionError => 'Connection error. Try again.';

  @override
  String get forgotPasswordSuccessTitle => 'Email sent!';

  @override
  String forgotPasswordSuccessDesc(String email) {
    return 'We sent a recovery link to\n$email';
  }

  @override
  String get forgotPasswordEnterCodeButton => 'Enter code / token';

  @override
  String get resetPasswordTitle => 'New password';

  @override
  String get resetPasswordInstruction =>
      'Enter the token you received by email and your new password.';

  @override
  String get resetPasswordErrorDefault => 'Invalid or expired token.';

  @override
  String get resetPasswordConnectionError => 'Connection error. Try again.';

  @override
  String get resetPasswordTokenLabel => 'Recovery token';

  @override
  String get resetPasswordTokenHint => 'Paste the token from your email';

  @override
  String get resetPasswordTokenRequired => 'Enter the token';

  @override
  String get resetPasswordNewLabel => 'New password';

  @override
  String get resetPasswordNewHint => 'Minimum 8 characters';

  @override
  String get resetPasswordNewRequired => 'Enter your new password';

  @override
  String get resetPasswordNewTooShort => 'Minimum 8 characters';

  @override
  String get resetPasswordConfirmLabel => 'Confirm password';

  @override
  String get resetPasswordConfirmHint => 'Repeat the password';

  @override
  String get resetPasswordConfirmRequired => 'Confirm your password';

  @override
  String get resetPasswordConfirmMismatch => 'Passwords do not match';

  @override
  String get resetPasswordChangeButton => 'Change password';

  @override
  String get resetPasswordBackLink => 'Back';

  @override
  String get resetPasswordSuccessTitle => 'Password updated!';

  @override
  String get resetPasswordSuccessDesc =>
      'Your password was successfully changed.\nYou can now log in.';

  @override
  String get resetPasswordGoToLoginButton => 'Go to login';

  @override
  String get homeHeaderSection => 'Home';

  @override
  String get homeKeySessionNoteHeader => 'Key session of the week';

  @override
  String get homeConnectDevicesTitle => 'Connect your devices';

  @override
  String get homeConnectDevicesDesc =>
      'Optional but recommended. With your wearable data, Fitnflai adapts your plan in real-time: steps, sleep, HR and more.';

  @override
  String get homeDeviceConnectedTitle => 'Device connected';

  @override
  String get homeDeviceConnectedDesc =>
      'Fitnflai is receiving your data in real-time.';

  @override
  String get homeSleepLabel => 'Sleep\nlast night';

  @override
  String get homeRestHRLabel => 'Rest HR';

  @override
  String get homeTemperatureLabel => 'Temperature\nnow';

  @override
  String get homeWeatherLabel => 'Weather\ncondition';

  @override
  String get homeDailyCheckinTitle => 'How are you today?';

  @override
  String get homeDailyCheckinDesc =>
      'Answer 4 quick questions so Fitnflai can adjust your session.';

  @override
  String get homeSectionWeeklyDist => 'WEEKLY DISTRIBUTION';

  @override
  String get homeSectionWeeklyIntensity => 'WEEKLY INTENSITY';

  @override
  String get homeSectionWeeklyAdherence => 'ADHERENCE TO PLAN';

  @override
  String homeSessionCompleted(int completed, int total) {
    return '$completed of $total sessions completed';
  }

  @override
  String homeRestDayTitle(String name) {
    return 'Rest, $name';
  }

  @override
  String get homeRestDayDesc =>
      'Recovery is part of training.\nEnjoy this rest day!';

  @override
  String get homeRestDayActiveSection => 'ACTIVE REST';

  @override
  String get homeRestTipWalkTitle => 'Easy walk';

  @override
  String get homeRestTipWalkDesc => '20–30 min at conversational pace';

  @override
  String get homeRestTipMobilityTitle => 'Mobility';

  @override
  String get homeRestTipMobilityDesc => '10 min of dynamic stretching';

  @override
  String get homeRestTipHydrationTitle => 'Hydration';

  @override
  String get homeRestTipHydrationDesc =>
      'Maintain a good hydration level today';

  @override
  String get homeRestTipSleepTitle => 'Sleep';

  @override
  String get homeRestTipSleepDesc => 'Prioritize 7–9 hours of rest';

  @override
  String get homeSessionMissed => 'Not completed';

  @override
  String get homeWorkoutStartButton => 'Start training';

  @override
  String get homeWorkoutAdjustButton => 'Tired or bad weather? Adjust';

  @override
  String get homeWorkoutDetailButton => 'See workout detail';

  @override
  String homeAdherencePct(int percentage) {
    return '$percentage%';
  }

  @override
  String get homeTipOfTheDayTitle => 'Tip of the day';

  @override
  String get homeTipOfTheDayDesc =>
      'Remember to hydrate well before your next high-intensity session.';

  @override
  String homeNoWorkoutTitle(String name) {
    return 'No workout today, $name';
  }

  @override
  String get homeNoWorkoutDesc =>
      'Today is a free day. Use it to rest or do light activity.';

  @override
  String get settingsRefundRequest => 'Request refund';

  @override
  String get membershipNuveiInstructions =>
      'We have opened the secure Nuvei payment gateway in your browser. Please complete your payment there. Once finished, return to Fitnflai and click the \'Verify Payment\' button to update your subscription. DO NOT CLOSE this window until you have completed the process.';

  @override
  String get membershipNuveiVerifyButton => 'Verify Payment';

  @override
  String get membershipNuveiCloseButton => 'Close';

  @override
  String get refundReferenceLabel => 'Payment reference (order number)';

  @override
  String get refundReasonLabel => 'Reason for refund';

  @override
  String get refundEmptyFieldsError => 'Please enter the reference and reason.';

  @override
  String get refundSuccess =>
      'Refund request successfully submitted. We will contact you soon.';

  @override
  String get workoutAdjustmentReasonLabel => 'Reason for adjustment';

  @override
  String get workoutAdjustmentReasonSelect => 'Select a reason';

  @override
  String get workoutAdjustmentReasonWeather => 'Bad weather';

  @override
  String get workoutAdjustmentReasonTired => 'Tired';

  @override
  String get workoutAdjustmentReasonInjury => 'Injury';

  @override
  String get workoutAdjustmentReasonOther => 'Other';

  @override
  String get workoutAdjustmentSeverityLabel => 'Injury severity';

  @override
  String get workoutAdjustmentSeveritySelect => 'Select severity';

  @override
  String get workoutAdjustmentSeverityMild => 'Mild';

  @override
  String get workoutAdjustmentSeverityModerate => 'Moderate';

  @override
  String get workoutAdjustmentSeveritySevere => 'Severe';

  @override
  String get workoutAdjustmentDescLabel => 'Additional details (optional)';

  @override
  String get workoutAdjustmentDescPlaceholder =>
      'Describe how you feel here...';

  @override
  String get workoutAdjustmentValidationRequired => 'This field is required';

  @override
  String get workoutAdjustmentBtnSubmit => 'Send';

  @override
  String get workoutAdjustmentBtnCancel => 'Cancel';

  @override
  String get workoutAdjustmentSuccessMessage =>
      'Adjustment submitted successfully!';

  @override
  String get specialistBookingTitle => 'Book Appointment';

  @override
  String get specialistBookingSelectDate => 'Select Date';

  @override
  String get specialistBookingSelectTime => 'Select Time Slot';

  @override
  String get specialistBookingConfirmBtn => 'Schedule Appointment (\$19.99)';

  @override
  String get specialistBookingDuration => '45 min Session';

  @override
  String get specialistBookingCheckoutTitle => 'Confirm Booking';

  @override
  String get specialistBookingCheckoutSummary => 'Specialist Session (45 min)';

  @override
  String get specialistBookingCheckoutConfirmBtn => 'Confirm & Pay';

  @override
  String get specialistBookingSuccessTitle => 'Appointment Scheduled!';

  @override
  String specialistBookingSuccessDesc(String date, String time) {
    return 'Your appointment has been successfully scheduled for $date at $time.';
  }

  @override
  String get specialistBookingSuccessClose => 'Got it';

  @override
  String get specialistBookingErrorMissingData =>
      'Missing data for booking. Please ensure a specialist and time are selected.';

  @override
  String get specialistBookingProfileReloadFailed =>
      'Appointment scheduled, but profile could not be updated immediately.';

  @override
  String get specialistBookingGenericError =>
      'Failed to schedule appointment. Please try again.';

  @override
  String get specialistBookingDefaultDescription => 'Online consultation';

  @override
  String get testTimerBorgQuestion =>
      'How much effort did you perceive? (Borg 6–20)';

  @override
  String get testTimerBorgLevel6 => 'No effort';

  @override
  String get testTimerBorgLevel7 => 'Very, very light';

  @override
  String get testTimerBorgLevel8 => 'Very light';

  @override
  String get testTimerBorgLevel9 => 'Fairly light';

  @override
  String get testTimerBorgLevel10 => 'Light';

  @override
  String get testTimerBorgLevel11 => 'Moderately light';

  @override
  String get testTimerBorgLevel12 => 'Moderate';

  @override
  String get testTimerBorgLevel13 => 'Somewhat hard';

  @override
  String get testTimerBorgLevel14 => 'Hard';

  @override
  String get testTimerBorgLevel15 => 'Very hard';

  @override
  String get testTimerBorgLevel16 => 'Very, very hard';

  @override
  String get testTimerBorgLevel17 => 'Extremely hard';

  @override
  String get testTimerBorgLevel18 => 'Almost maximal';

  @override
  String get testTimerBorgLevel19 => 'Very near maximal';

  @override
  String get testTimerBorgLevel20 => 'Maximal effort';

  @override
  String get testTimerBorgMinLabel => 'None';

  @override
  String get testTimerBorgMidLabel => 'Somewhat hard';

  @override
  String get testTimerBorgMaxLabel => 'Maximal';

  @override
  String get testTimerEnterResultPrompt =>
      'Enter your result before continuing';

  @override
  String get testTimerSaveError => 'Error saving result. Try again.';

  @override
  String get testTimerConnectionError => 'Connection error. Try again.';

  @override
  String get testTimerModeFree => 'Free';

  @override
  String get testTimerStatusCompleted => 'Completed';

  @override
  String get testTimerButtonFinishNow => 'Finish now';

  @override
  String get testTimerButtonReset => 'Reset from scratch';

  @override
  String get testTimerCompletionTitle => 'Test completed!';

  @override
  String testTimerCompletionTime(String time) {
    return 'Time: $time';
  }

  @override
  String get testTimerFlexibilityQuestion => 'How far did your hands reach?';

  @override
  String get testTimerFlexOptionKnees => 'Doesn\'t reach knees';

  @override
  String get testTimerFlexOptionFeet => 'Reaches feet';

  @override
  String get testTimerFlexOptionPastFeet => 'Past feet';

  @override
  String get testTimerFlexOptionGround => 'Palms to the ground';

  @override
  String testTimerEnterResultWithUnit(String unit) {
    return 'Enter your result in $unit';
  }

  @override
  String get testTimerSaveAndContinue => 'Save and continue';

  @override
  String get homeCalendarToday => 'Today';

  @override
  String get weatherRain => 'Rain';

  @override
  String get weatherClear => 'Clear';

  @override
  String get weatherPartlyCloudy => 'Partly cloudy';

  @override
  String get weatherCloudy => 'Cloudy';

  @override
  String get weatherFog => 'Fog';

  @override
  String get weatherSnow => 'Snow';

  @override
  String get weatherShowers => 'Showers';

  @override
  String get weatherThunderstorm => 'Thunderstorm';

  @override
  String get planHeaderSection => 'Plan';

  @override
  String get planContextPast => 'Last week';

  @override
  String get planContextFuture => 'Next week';

  @override
  String get planContextCurrent => 'Current week';

  @override
  String get planSessionsLabel => 'sessions';

  @override
  String get planCompletedLabel => 'completed';

  @override
  String get planEmptyFutureTitle => 'Your plan for this week is not ready yet';

  @override
  String get planEmptyFutureDesc =>
      'The AI will generate your plan when the time comes.';

  @override
  String get planEmptyPastTitle => 'No workouts this week';

  @override
  String get planEmptyPastDesc =>
      'The AI will generate your plan when the time comes.';

  @override
  String get planLoadError => 'Error loading plan';

  @override
  String get planConnError => 'Connection error';

  @override
  String get planRetry => 'Retry';

  @override
  String get planActiveRestLabel => 'REST DAY';

  @override
  String get planActiveRestToday => 'Today · Rest';

  @override
  String get planActiveRestActive => 'Active rest';

  @override
  String get planActiveRestDefaultMsg =>
      'Recovery is part of training.\nEnjoy this rest day!';

  @override
  String get planActiveRestRecs => 'RECOMMENDATIONS';

  @override
  String get planActiveRestTipWalk => 'Walk';

  @override
  String get planActiveRestTipMobility => 'Mobility';

  @override
  String get planActiveRestTipHydration => 'Hydration';

  @override
  String get planActiveRestTipSleep => 'Sleep';

  @override
  String get planActiveRestTipWalkDesc => 'Easy walk';

  @override
  String get planActiveRestTipMobilityDesc => 'Dynamic stretches';

  @override
  String get planActiveRestTipHydrationDesc => 'Stay hydrated';

  @override
  String get planActiveRestTipSleepDesc => 'Sleep well';

  @override
  String get planSessionCardTodayHeader => 'TODAY\'S WORKOUT';

  @override
  String get planSessionCardTodayBadge => 'Today';

  @override
  String get planSessionCardCompletedBadge => 'Completed';

  @override
  String get planSessionCardMissedBadge => 'Missed';

  @override
  String get planSessionCardStartBtn => 'Start workout';

  @override
  String get planSessionCardAdjustBtn => 'Tired or bad weather? Adjust';

  @override
  String get planSessionCardDetailBtn => 'See detail';

  @override
  String get planSessionCardLockDesc => 'Available when the week arrives';

  @override
  String get progressHeaderSection => 'Progress';

  @override
  String progressSummaryTitle(int months) {
    return 'In these $months months you achieved:';
  }

  @override
  String get progressSummaryCompleted => 'sessions completed';

  @override
  String get progressSummaryHours => 'hours training';

  @override
  String get progressSummaryFat => 'body fat';

  @override
  String get progressWellnessAgeTitle => 'Wellness age';

  @override
  String progressWellnessAgeDesc(int years, int startAge) {
    return 'Your body is $years years younger than your actual age. You started with $startAge.';
  }

  @override
  String progressWellnessAgeDiff(int years) {
    return '$years years since you started';
  }

  @override
  String get progressClaveBadge => 'Key';

  @override
  String get progressClaveDesc =>
      'Maintain cardiovascular conditions. Strength, mobility and body composition are the metrics that \"go\" with quality training. The more you train, the easier everything becomes.';

  @override
  String get progressSectionHealthComp => 'Health and composition';

  @override
  String get progressIndicatorsSubtitle => 'The 3 key indicators';

  @override
  String progressIndicatorBefore(String before) {
    return 'before: $before';
  }

  @override
  String progressIndicatorTarget(String target) {
    return 'target: $target';
  }

  @override
  String get progressSectionPerformance => 'Performance and training';

  @override
  String get progressComplianceTitle => 'Plan compliance';

  @override
  String get progressComplianceSubtitle => 'Last 4 weeks';

  @override
  String get progressComplianceDesc =>
      'Consistency is the factor that most predicts progress. Completing the plan week by week is as important as the training itself.';

  @override
  String get progressLoadTitle => 'Weekly load';

  @override
  String get progressLoadSubtitle => 'for same load';

  @override
  String get progressLoadDesc =>
      'More hours progressively is the sign that your body adapts and can handle more. Low weeks are planned deloads, not setbacks.';

  @override
  String get progressLoadThisWeek => 'this week';

  @override
  String get progressLoadVsPrevious => 'vs previous month';

  @override
  String get progressLoadAverage => 'average';

  @override
  String get progressLoadDescNote => '= weeks marked with planned deloads';

  @override
  String get progressRpeTitle => 'Perceived exertion (RPE)';

  @override
  String get progressRpeSubtitle => '#2 hours · # sessions';

  @override
  String get progressRpeDesc =>
      'If you do the workout with less effort, your body is becoming more efficient. Lower bars are proof that you are improving.';

  @override
  String get progressAITendencyTitle => 'General trend · Fitnflai';

  @override
  String get progressAITendencySubtitle => 'Last 3 months analysis';

  @override
  String get progressAITendencyDesc =>
      'You have had a positive trend in all key metrics for 3 months. Nico, your body recomposition is progressing consistently and your cardiovascular capacity is at an excellent level for your age.';

  @override
  String get nutritionHeaderSection => 'Nutrition';

  @override
  String get nutritionAIBannerTitle => 'Smart nutrition for your training';

  @override
  String get nutritionAIBannerDesc =>
      'Your weekly nutritional plan, personalized macros and type of diet before each session. Generated by Fitnflai according to your training load.';

  @override
  String get nutritionAIBannerProTitle => 'With the Pro plan you unlock:';

  @override
  String get nutritionAIBannerProBtn => 'See Pro plan';

  @override
  String get nutritionAIBannerProNote => 'No credit card · Cancel anytime';

  @override
  String get nutritionRestDayBanner =>
      'Rest day · Eat light and stay well hydrated.';

  @override
  String get nutritionMacrosTitle => 'Daily Macros';

  @override
  String nutritionMacrosKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get nutritionMacrosCarbs => 'Carbohydrates';

  @override
  String get nutritionMacrosProtein => 'Protein';

  @override
  String get nutritionMacrosFat => 'Fats';

  @override
  String nutritionSectionPlanTitle(String title) {
    return 'DAILY PLAN · $title';
  }

  @override
  String get nutritionHydrationTitle => 'Basic hydration';

  @override
  String nutritionHydrationValue(double current, double total) {
    return '${current}L / ${total}L';
  }

  @override
  String nutritionHydrationInfo(int altitude, int pct) {
    return 'At ${altitude}m your hydration needs increase by $pct% vs sea level';
  }

  @override
  String get profileButtonEdit => 'EDIT PROFILE';

  @override
  String profilePremiumTitle(String name) {
    return '$name, join Fitnflai Premium';
  }

  @override
  String get profilePremiumDesc =>
      'Unlock your full plan and reach your full potential.';

  @override
  String get profilePremiumSubscribe => 'SUBSCRIBE';

  @override
  String get profilePremiumRestore => 'RESTORE';

  @override
  String get profilePlanActiveHeader => 'ACTIVE PLAN';

  @override
  String profilePlanActiveProgress(int completed, int total) {
    return '$completed / $total sessions';
  }

  @override
  String profileJoinDate(String month, int year) {
    return 'Joined: $month $year';
  }

  @override
  String get profileSectionMyStuff => 'MY STUFF';

  @override
  String get profileMenuConnectedApps => 'Connected apps and devices';

  @override
  String get profileMenuPersonalInfo => 'Personal info';

  @override
  String get profileMenuNotifications => 'Notifications';

  @override
  String get profileMenuWeeklyReport => 'Configure weekly report';

  @override
  String get profileSectionPreferences => 'MY PREFERENCES';

  @override
  String get profileMenuGeneral => 'General';

  @override
  String get profileMenuMyPlan => 'My plan';

  @override
  String get profileMenuMyTests => 'My tests';

  @override
  String get profileMenuPeriodicEval => 'Periodic evaluation';

  @override
  String get profileSectionAccount => 'ACCOUNT';

  @override
  String get profileMenuDeleteAccount => 'Delete account';

  @override
  String get profileButtonLogout => 'Log out';

  @override
  String get profileConfirmDeleteTitle => 'Delete account?';

  @override
  String get profileConfirmDeleteDesc =>
      'This action is irreversible. All your data, plan and history will be deleted.';

  @override
  String get profileConfirmDeleteCancel => 'Cancel';

  @override
  String get profileConfirmDeleteConfirm => 'Delete';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get editProfileChangePhoto => 'Change profile photo';

  @override
  String get editProfileTakePhoto => 'Take photo';

  @override
  String get editProfileChooseGallery => 'Choose from gallery';

  @override
  String get editProfileDeletePhoto => 'Delete photo';

  @override
  String get editProfileSuccess => 'Profile updated';

  @override
  String get editProfileError => 'Error saving. Try again.';

  @override
  String get editProfileTapToChange => 'Tap to change photo';

  @override
  String get editProfileUsername => 'Username';

  @override
  String get editProfileUsernameHint => '@username';

  @override
  String get editProfileUsernameError => 'Enter a username';

  @override
  String get editProfileEmail => 'Email';

  @override
  String get editProfileEmailHint => 'email@example.com';

  @override
  String get editProfileEmailEmpty => 'Enter your email';

  @override
  String get editProfileEmailInvalid => 'Invalid email';

  @override
  String get editProfileCity => 'City';

  @override
  String get editProfileCitySearchHint => 'Search city...';

  @override
  String get editProfileAltitude => 'Altitude (m.a.s.l.)';

  @override
  String get editProfileAltitudeHint => 'Detected when selecting city';

  @override
  String get editProfileMembership => 'Membership';

  @override
  String get editProfileMembershipPlan => 'Essential Plan';

  @override
  String get editProfileMembershipDays => '21 free days active';

  @override
  String get editProfileMembershipChange => 'Change';

  @override
  String get editProfileSaving => 'Saving...';

  @override
  String get editProfileSave => 'Save changes';

  @override
  String get trainingSettingsTitle => 'Plan';

  @override
  String get trainingSettingsSmartAdaptations => 'SMART ADAPTATIONS';

  @override
  String get trainingSettingsSmartAltitude => 'Smart altitude';

  @override
  String get trainingSettingsSmartAltitudeDesc =>
      'Adjusts HR zones and hydration according to your altitude';

  @override
  String get trainingSettingsInjuryAlerts => 'Injury alerts';

  @override
  String get trainingSettingsInjuryAlertsDesc =>
      'Warns when there is risk of overtraining';

  @override
  String get trainingSettingsPlanPrefs => 'PLAN PREFERENCES';

  @override
  String get trainingSettingsDiscipline => 'Discipline';

  @override
  String get trainingSettingsDifficulty => 'Difficulty level';

  @override
  String get trainingSettingsTimePerSession => 'Time per session';

  @override
  String trainingSettingsMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get trainingSettingsTrainingDays => 'TRAINING DAYS';

  @override
  String get trainingSettingsSelectDays => 'Select the days you train';

  @override
  String get trainingSettingsCompetitions => 'COMPETITIONS AND EVENTS';

  @override
  String get trainingSettingsMyCompetitions => 'My competitions and events';

  @override
  String get trainingSettingsSaved => 'Preferences saved';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyModerate => 'Moderate';

  @override
  String get difficultyChallenging => 'Challenging';

  @override
  String get difficultyCompetitive => 'Competitive';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get supportTitle => 'Support';

  @override
  String get supportHelpHeader => 'How can we help you?';

  @override
  String get supportHelpSub =>
      'We are here to help you get the most out of your training.';

  @override
  String get supportContact => 'CONTACT';

  @override
  String get supportLiveChat => 'Live chat';

  @override
  String get supportLiveChatSub => 'Response in less than 2 hours';

  @override
  String get supportAvailable => 'Available';

  @override
  String get supportEmail => 'Email';

  @override
  String get supportHelpCenter => 'Help Center';

  @override
  String get supportHelpCenterSub => 'Detailed guides and tutorials';

  @override
  String get supportFaqs => 'FREQUENTLY ASKED QUESTIONS';

  @override
  String get supportFollowUs => 'FOLLOW US';

  @override
  String supportVersion(String version) {
    return 'Version $version';
  }

  @override
  String get supportFaqQ1 => 'How does the training plan work?';

  @override
  String get supportFaqA1 =>
      'Fitnflai analyzes your profile, history, functional tests and objectives to generate a personalized week-by-week plan. The plan automatically adjusts according to your progress and daily feedback.';

  @override
  String get supportFaqQ2 => 'Can I change my training days?';

  @override
  String get supportFaqA2 =>
      'Yes. Go to Profile → My plan → Training days and select the days that best suit your week. The plan will automatically reorganize.';

  @override
  String get supportFaqQ3 => 'What if I skip a workout?';

  @override
  String get supportFaqA3 =>
      'No problem. Fitnflai detects the missed session and adjusts the weekly load so as not to compromise your progress. You can mark the reason in the daily check-in.';

  @override
  String get supportFaqQ4 => 'How do I connect my Garmin or Strava?';

  @override
  String get supportFaqA4 =>
      'Go to Profile → Apps and devices. From there you can connect Garmin, Strava or your health app. Once connected, your activity data will automatically sync.';

  @override
  String get supportFaqQ5 => 'Can I use Fitnflai without a wearable device?';

  @override
  String get supportFaqA5 =>
      'Yes, completely. The wearable enriches the plan with real-time data, but it is not mandatory. You can enter your status manually through the daily check-in.';

  @override
  String get supportFaqQ6 => 'How do I cancel my subscription?';

  @override
  String get supportFaqA6 =>
      'You can cancel from the store where you subscribed (App Store or Google Play). Your active plan will continue until the end of the billed period.';

  @override
  String get connectedAppsTitle => 'Apps and devices';

  @override
  String get connectedAppsDesc =>
      'Track your workouts on compatible devices and sync completed sessions with your favorite applications.';

  @override
  String get connectedAppsSectionApps => 'APPLICATIONS';

  @override
  String get connectedAppsConnected => 'Connected';

  @override
  String get connectedAppsSectionCalendars => 'CALENDARS';

  @override
  String get connectedAppsConnectCalendar => 'Connect a calendar';

  @override
  String get connectedAppsCalendarDesc =>
      'Sync your workouts with Google Calendar, Apple Calendar or others.';

  @override
  String get connectedAppsSectionWearables => 'WEARABLE DEVICES';

  @override
  String get connectedAppsConnectWearable => 'Connect another wearable device';

  @override
  String connectedAppsDisconnectTitle(String name) {
    return 'Disconnect $name';
  }

  @override
  String connectedAppsDisconnectDesc(String name) {
    return 'Are you sure you want to disconnect $name?';
  }

  @override
  String get connectedAppsCancel => 'Cancel';

  @override
  String get connectedAppsDisconnect => 'Disconnect';

  @override
  String connectedAppsDisconnectedToast(String name) {
    return '$name disconnected';
  }

  @override
  String connectedAppsConnectedToast(String name) {
    return '$name connected';
  }

  @override
  String get connectedAppsActionPrompt => 'What do you want to do?';

  @override
  String get connectedAppsSync => 'Sync';

  @override
  String get connectedAppsStravaSynced => 'Strava synced';

  @override
  String get connectedAppsStravaSyncError => 'Error syncing';

  @override
  String connectedAppsComingSoon(String feature) {
    return '$feature — coming soon';
  }

  @override
  String get connectedAppsNullUserError =>
      'Could not load user profile. Please try again.';

  @override
  String get connectedAppsStravaSyncPrompt =>
      'Do you want to sync all your workouts?';

  @override
  String get connectedAppsAccept => 'Accept';

  @override
  String get connectedAppsSkip => 'Skip';

  @override
  String get competitionsTitle => 'Competitions and events';

  @override
  String get competitionsAddEvent => 'Add event';

  @override
  String get competitionsEditEvent => 'Edit event';

  @override
  String get competitionsFieldName => 'Event name';

  @override
  String get competitionsFieldNameHint => 'E.g.: Bogotá Marathon 2026';

  @override
  String get competitionsFieldType => 'Event type';

  @override
  String get competitionsFieldLocation => 'Location (optional)';

  @override
  String get competitionsFieldLocationHint => 'City or venue of the event';

  @override
  String get competitionsFieldDate => 'Event date';

  @override
  String get competitionsSelectDate => 'Select date';

  @override
  String get competitionsSaveButton => 'Save changes';

  @override
  String get competitionsDeleteTitle => 'Delete event?';

  @override
  String competitionsDeleteDesc(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get competitionsCancel => 'Cancel';

  @override
  String get competitionsDelete => 'Delete';

  @override
  String get shortMonths => 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';

  @override
  String get competitionsStatusPast => 'Past';

  @override
  String get competitionsStatusToday => 'Today!';

  @override
  String competitionsStatusDays(int days) {
    return '$days days';
  }

  @override
  String get competitionsType5k => '5K Race';

  @override
  String get competitionsType10k => '10K Race';

  @override
  String get competitionsTypeHalfMarathon => 'Half Marathon';

  @override
  String get competitionsTypeMarathon => 'Marathon';

  @override
  String get competitionsTypeTrail => 'Trail';

  @override
  String get competitionsTypeTriathlon => 'Triathlon';

  @override
  String get competitionsTypeCycling => 'Cycling';

  @override
  String get competitionsTypeSwimming => 'Swimming';

  @override
  String get competitionsTypeOther => 'Other';

  @override
  String get competitionsEmptyTitle => 'No competitions yet';

  @override
  String get competitionsEmptyDesc =>
      'Add the races, triathlons or events you plan to participate in. Your plan will adapt to your dates.';

  @override
  String get competitionsAddFirst => 'Add first event';

  @override
  String get periodicEvalTitle => 'Periodic test';

  @override
  String get periodicEvalBanner =>
      'Record your weight and height every week. This data helps Fitnflai calculate your BMI, effort zones and keep your plan always updated.';

  @override
  String get periodicEvalMetrics => 'Body measurements';

  @override
  String get periodicEvalWeight => 'Current weight';

  @override
  String get periodicEvalHeight => 'Height';

  @override
  String get periodicEvalCompTitle => 'Do you have body\ncomposition data?';

  @override
  String get periodicEvalCompDesc =>
      'If you have a smart scale or bioimpedance report, Fitnflai automatically extracts the data to better customize your plan.';

  @override
  String get periodicEvalUploadTitle => 'Upload report';

  @override
  String get periodicEvalOptional => 'Optional';

  @override
  String get periodicEvalUploadHint => 'Upload your scale report';

  @override
  String get periodicEvalUploadDesc =>
      'Fitnflai extracts % fat, muscle, body water and BMR to better calibrate your plan.';

  @override
  String get periodicEvalUploadPhoto => 'Upload photo';

  @override
  String get periodicEvalUploadPdf => 'Upload PDF';

  @override
  String get periodicEvalSave => 'Save';

  @override
  String get myTestsTitle => 'My tests';

  @override
  String get myTestsBannerTitle => 'Periodic tests = more precise plan';

  @override
  String get myTestsBannerDesc =>
      'Perform each test every 30 days so Fitnflai can adjust your plan to your real level.';

  @override
  String get myTestsSection => 'YOUR TESTS';

  @override
  String get myTestsSquatsName => 'Squats 1 min';

  @override
  String get myTestsSquatsCategory => 'Lower body strength';

  @override
  String get myTestsCooperName => 'Cooper Test';

  @override
  String get myTestsCooperCategory => 'Cardiovascular endurance';

  @override
  String get myTestsPushupsName => 'Push-ups 1 min';

  @override
  String get myTestsPushupsCategory => 'Upper body strength';

  @override
  String get myTestsPlankName => 'Plank';

  @override
  String get myTestsPlankCategory => 'Core / Stability';

  @override
  String get myTestsFlexName => 'Forward bend';

  @override
  String get myTestsFlexCategory => 'Flexibility';

  @override
  String get myTestsStatusPending => 'Pending';

  @override
  String get myTestsStatusRepeat => 'Repeat';

  @override
  String myTestsStatusDays(int days) {
    return 'In $days days';
  }

  @override
  String myTestsLastTime(String date) {
    return 'Last time: $date';
  }

  @override
  String get myTestsBtnRetake => 'Retake';

  @override
  String get myTestsBtnStart => 'Do test';

  @override
  String get notificationsSettingsTitle => 'Notifications';

  @override
  String get notificationsSettingsIntensityHeader => 'GENERAL INTENSITY';

  @override
  String get notificationsSettingsIntensityLabel => 'Notification frequency';

  @override
  String get notificationsSettingsIntensityDesc =>
      'Control how many notifications you receive in total';

  @override
  String get notificationsIntensityLow => 'Low';

  @override
  String get notificationsIntensityMedium => 'Medium';

  @override
  String get notificationsIntensityHigh => 'High';

  @override
  String get notificationsSettingsTypesHeader => 'NOTIFICATION TYPES';

  @override
  String get notificationsSettingsWorkoutsLabel => 'Workouts';

  @override
  String get notificationsSettingsWorkoutsDesc =>
      'Reminder of your daily session';

  @override
  String get notificationsSettingsRemindersLabel => 'Reminders';

  @override
  String get notificationsSettingsRemindersDesc =>
      'Alerts before your scheduled session';

  @override
  String get notificationsSettingsProgressLabel => 'Weekly progress';

  @override
  String get notificationsSettingsProgressDesc =>
      'Summary of your progress each week';

  @override
  String get notificationsSettingsNutritionLabel => 'Nutrition and hydration';

  @override
  String get notificationsSettingsNutritionDesc => 'Meal and water reminders';

  @override
  String get notificationsSettingsOffersLabel => 'Offers and news';

  @override
  String get notificationsSettingsOffersDesc => 'Fitnflai news and promotions';

  @override
  String get notificationsSettingsSaving => 'Saving...';

  @override
  String get notificationsSettingsSave => 'Save';

  @override
  String get notificationsSettingsSaveSuccess => 'Notifications saved';

  @override
  String get notificationsSettingsSaveError => 'Error saving. Try again.';

  @override
  String get notificationsPanelTitle => 'Notifications';

  @override
  String get notificationsPanelMarkAll => 'Mark all';

  @override
  String get notificationsPanelEmptyTitle => 'No notifications';

  @override
  String get notificationsPanelEmptyDesc =>
      'Your alerts and news will appear here.';

  @override
  String get timeAgoJustNow => 'Just now';

  @override
  String timeAgoMinutes(int minutes) {
    return '$minutes min ago';
  }

  @override
  String timeAgoHours(int hours) {
    return '${hours}h ago';
  }

  @override
  String timeAgoDays(int days) {
    return '$days day ago';
  }

  @override
  String timeAgoDaysPlural(int days) {
    return '$days days ago';
  }

  @override
  String dailyCheckinGreeting(String name) {
    return 'Good morning, $name 👋';
  }

  @override
  String get dailyCheckinSubtitle => 'Tuesday · Today\'s session: Zone 2 Run';

  @override
  String get dailyCheckinHeaderDesc =>
      'Answer 4 quick questions so the AI can adjust your session today.';

  @override
  String dailyCheckinQuestionLabel(int index, String label) {
    return 'Question $index · $label';
  }

  @override
  String get dailyCheckinLabelSleep => 'Sleep';

  @override
  String get dailyCheckinLabelEnergy => 'Energy';

  @override
  String get dailyCheckinLabelPain => 'Pain or discomfort';

  @override
  String get dailyCheckinLabelTime => 'Time available';

  @override
  String get dailyCheckinQuestionSleep => 'How did you sleep last night?';

  @override
  String get dailyCheckinQuestionEnergy => 'How is your energy right now?';

  @override
  String get dailyCheckinQuestionPain =>
      'Do you have any pain or discomfort today?';

  @override
  String get dailyCheckinQuestionTime =>
      'How much time do you have to train today?';

  @override
  String get dailyCheckinPainNo => '✓ No, I\'m fine';

  @override
  String get dailyCheckinPainYes => 'Yes, a little';

  @override
  String get dailyCheckinPainWhere => 'Where?';

  @override
  String get dailyCheckinPainDetailsHint => 'Additional details (optional)';

  @override
  String get dailyCheckinBtnResult => 'See my adjusted session →';

  @override
  String get dailyCheckinBtnAnswerAll => 'Answer all questions';

  @override
  String dailyCheckinProgressStatus(int answered, int total) {
    return '$answered of $total answered';
  }

  @override
  String get dailyCheckinScoreSleep => 'Sleep';

  @override
  String get dailyCheckinScoreEnergy => 'Energy';

  @override
  String get dailyCheckinScorePain => 'Pain';

  @override
  String get dailyCheckinScoreTime => 'Time';

  @override
  String get dailyCheckinPainValueNo => 'No';

  @override
  String get dailyCheckinPainValueMild => 'Mild';

  @override
  String get dailyCheckinSemaforoGreenTitle =>
      'Today you\'re ready to train hard!';

  @override
  String get dailyCheckinSemaforoGreenDesc =>
      'You slept well, you have energy and no discomfort. Perfect conditions for your running session.';

  @override
  String get dailyCheckinSemaforoGreenBadge => '✓ Full session · no changes';

  @override
  String get dailyCheckinSemaforoYellowTitle =>
      'Today you\'re not at 100% — the AI adjusted your session';

  @override
  String get dailyCheckinSemaforoYellowDesc =>
      'You slept little and energy is low. You can train, but with less load. Your plan is not affected.';

  @override
  String get dailyCheckinSemaforoYellowBadge => '⚡ Adjusted';

  @override
  String get dailyCheckinSemaforoRedTitle => 'Today your body needs rest';

  @override
  String get dailyCheckinSemaforoRedDesc =>
      'Very little sleep, no energy and strong pain. Training today increases the risk of injury.';

  @override
  String get dailyCheckinSemaforoRedBadge => '↔ Alternative';

  @override
  String get dailyCheckinSessionTitleGreen => 'Base run · Zone 2';

  @override
  String get dailyCheckinSessionSubGreen => 'Tuesday · Week 3 of 18';

  @override
  String get dailyCheckinSessionTitleYellow => 'Base run · Zone 2 · Reduced';

  @override
  String get dailyCheckinSessionSubYellow =>
      'Adjusted version by the AI for today';

  @override
  String get dailyCheckinSessionTitleRed => 'Mobility and breathing';

  @override
  String get dailyCheckinSessionSubRed =>
      'Recommended alternative · Active rest';

  @override
  String get dailyCheckinSessionChangeTitle => 'What did the AI change?';

  @override
  String get dailyCheckinSessionChangeDesc =>
      'Reduced duration. Lower target HR. The volume lost today is redistributed to Thursday.';

  @override
  String get dailyCheckinSessionReducePct => '-30% intensity';

  @override
  String get dailyCheckinSessionNoFc => 'No target HR';

  @override
  String get dailyCheckinPainAlertUrgent => 'Strong pain · Recommended action';

  @override
  String dailyCheckinPainAlertNormal(String zone) {
    return 'Discomfort recorded · $zone';
  }

  @override
  String get dailyCheckinPainAlertUrgentDesc =>
      'You reported strong pain. If it has lasted more than 2 days, consider consulting a sports specialist.';

  @override
  String get dailyCheckinPainAlertNormalDesc =>
      'The AI removed high-impact exercises. If the discomfort persists tomorrow, activate the injury protocol.';

  @override
  String get dailyCheckinInsightTitle => 'The AI says';

  @override
  String get dailyCheckinInsightGreen =>
      'With good sleep and high energy, this is an ideal session to work on your aerobic base. Keep HR below 130 bpm. Hydration: 500ml before going out.';

  @override
  String get dailyCheckinInsightYellow =>
      'Poor sleep raises cortisol and reduces muscle recovery capacity. Today is not a day to push — 35 gentle minutes keep you active without risk.';

  @override
  String get dailyCheckinInsightRed =>
      'A rest day today doesn\'t ruin your 18 weeks — ignoring your body\'s signals does. The running session moves to Thursday.';

  @override
  String get dailyCheckinCtaGreen => 'Let\'s go! Start session →';

  @override
  String get dailyCheckinCtaYellow => 'Train the adjusted version';

  @override
  String get dailyCheckinCtaRed => 'Do the 20 min of mobility';

  @override
  String get dailyCheckinCtaRestRed => 'Total rest today · Do not train';

  @override
  String get dailyCheckinCtaRestNormal => 'Rest today · mark as free day';

  @override
  String get dailyCheckinCtaBottomNote =>
      'Your plan adjusts automatically · You are still on track';

  @override
  String get dailyCheckinSaveSuccess => 'Daily status successfully recorded.';

  @override
  String dailyCheckinSaveError(String error) {
    return 'Connection error or error recording status: $error';
  }

  @override
  String get workoutDetailTitle => 'Workout detail';

  @override
  String get workoutDetailObj => 'Objective';

  @override
  String get workoutDetailCal => 'Warm-up';

  @override
  String get workoutDetailDes => 'Cool-down';

  @override
  String get workoutDetailPrinc => 'Main block';

  @override
  String get workoutDetailInt => 'Intervals';

  @override
  String get workoutDetailMealPre => 'Pre-workout meal';

  @override
  String get workoutDetailMealPost => 'Post-workout meal';

  @override
  String get workoutDetailStart => 'Start workout';

  @override
  String workoutDetailDuration(int minutes) {
    return '$minutes min';
  }

  @override
  String get workoutActiveTitle => 'Active workout';

  @override
  String get workoutActiveTimer => 'Time';

  @override
  String get workoutActivePace => 'Pace';

  @override
  String get workoutActiveHr => 'Heart Rate';

  @override
  String get workoutActiveDist => 'Distance';

  @override
  String get workoutActivePause => 'Pause';

  @override
  String get workoutActiveResume => 'Resume';

  @override
  String get workoutActiveFinish => 'Finish';

  @override
  String get workoutActiveCancel => 'Cancel';

  @override
  String get workoutActiveConfirmFinishTitle => 'Finish workout?';

  @override
  String get workoutActiveConfirmFinishDesc =>
      'Are you sure you want to finish this session?';

  @override
  String get workoutFeedbackTitle => 'Workout feedback';

  @override
  String get workoutFeedbackFeelingQuestion => 'How did you feel?';

  @override
  String get workoutFeedbackRpeQuestion => 'Perceived exertion (RPE)';

  @override
  String get workoutFeedbackRpe1 => 'Very light';

  @override
  String get workoutFeedbackRpe2 => 'Light';

  @override
  String get workoutFeedbackRpe3 => 'Moderate';

  @override
  String get workoutFeedbackRpe4 => 'Hard';

  @override
  String get workoutFeedbackRpe5 => 'Maximal effort';

  @override
  String get workoutFeedbackFeeling1 => 'Exhausted';

  @override
  String get workoutFeedbackFeeling2 => 'Tired';

  @override
  String get workoutFeedbackFeeling3 => 'Good';

  @override
  String get workoutFeedbackFeeling4 => 'Strong';

  @override
  String get workoutFeedbackFeeling5 => 'Invincible';

  @override
  String get workoutFeedbackPainQuestion => 'Did you feel any pain?';

  @override
  String get workoutFeedbackSubmit => 'Submit feedback';

  @override
  String get dailyCheckinSleepOpt1 => 'Very bad';

  @override
  String get dailyCheckinSleepOpt2 => 'Bad';

  @override
  String get dailyCheckinSleepOpt3 => 'Regular';

  @override
  String get dailyCheckinSleepOpt4 => 'Good';

  @override
  String get dailyCheckinSleepOpt5 => 'Very good';

  @override
  String get dailyCheckinEnergyOpt1 => 'No energy';

  @override
  String get dailyCheckinEnergyOpt2 => 'Low';

  @override
  String get dailyCheckinEnergyOpt3 => 'Normal';

  @override
  String get dailyCheckinEnergyOpt4 => 'High';

  @override
  String get dailyCheckinEnergyOpt5 => 'Maxed out';

  @override
  String get dailyCheckinTimeOpt1 => 'just right';

  @override
  String get dailyCheckinTimeOpt2 => 'normal';

  @override
  String get dailyCheckinTimeOpt3 => 'good';

  @override
  String get dailyCheckinTimeOpt4 => 'plenty';

  @override
  String get dailyCheckinTimeOpt5 => 'full';

  @override
  String get painZoneCuello => 'Neck';

  @override
  String get painZoneHombro => 'Shoulder';

  @override
  String get painZoneEspaldaAlta => 'Upper back';

  @override
  String get painZoneLumbar => 'Lower back';

  @override
  String get painZoneCadera => 'Hip';

  @override
  String get painZoneRodilla => 'Knee';

  @override
  String get painZoneTobillo => 'Ankle';

  @override
  String get painZoneOtro => 'Other';

  @override
  String get workoutDetailDesc => 'Description';

  @override
  String get workoutDetailNotes => 'Notes';

  @override
  String get workoutDetailNutrition => 'Nutrition';

  @override
  String get workoutDetailDurationTitle => 'Duration';

  @override
  String get workoutDetailExercises => 'Exercises';

  @override
  String get workoutDetailNoExercises => 'No exercises available';

  @override
  String get workoutDetailDayNutrition => 'Daily nutrition';

  @override
  String get workoutDetailCompleted => 'Completed';

  @override
  String get workoutDetailCompletedBanner => 'Workout completed!';

  @override
  String get mealBreakfast => 'BREAKFAST';

  @override
  String get mealLunch => 'LUNCH';

  @override
  String get mealDinner => 'DINNER';

  @override
  String get mealPreWorkout => 'PRE-WORKOUT · 30-60 MIN BEFORE';

  @override
  String get mealPostWorkout => 'POST-WORKOUT · +30 MIN AFTER';

  @override
  String get mealSnack => 'SNACK';

  @override
  String get mealDuring => 'DURING · IF +60 MIN';

  @override
  String statsSeriesCount(int count) {
    return '$count sets';
  }

  @override
  String statsRepsCount(int count) {
    return '$count reps';
  }

  @override
  String statsMinCount(int count) {
    return '$count min';
  }

  @override
  String get workoutActiveExterior => 'Exterior';

  @override
  String get workoutActiveInterior => 'Interior';

  @override
  String get workoutActiveExitTitle => 'Exit workout?';

  @override
  String get workoutActiveExitDesc => 'Progress will be lost.';

  @override
  String get workoutActiveExitContinue => 'Continue';

  @override
  String get workoutActiveExitBtn => 'Exit';

  @override
  String get workoutActiveExercises => 'Exercises';

  @override
  String get workoutActiveNow => 'NOW';

  @override
  String get workoutActiveModeQuestion =>
      'This exercise can be done outdoors or indoors.\nWhere will you do it?';

  @override
  String get workoutActiveSets => 'SETS';

  @override
  String get workoutActiveReps => 'REPS';

  @override
  String get workoutActiveSpeed => 'SPEED';

  @override
  String workoutActiveSetLabel(int number) {
    return 'Set $number';
  }

  @override
  String get workoutActivePosInicial => 'Initial Position';

  @override
  String get workoutActiveEjecucion => 'Execution';

  @override
  String get workoutActiveConsejos => 'Technical Tips';

  @override
  String get workoutActiveNoPreview => 'Preview not available';

  @override
  String get workoutActiveStartBtn => 'Start workout';

  @override
  String get workoutActiveCompleted => 'Completed';

  @override
  String get workoutActiveCompleteSets => 'Complete the sets';

  @override
  String get workoutActiveMarkDone => 'Mark done';

  @override
  String get workoutActiveNext => 'Next';

  @override
  String get workoutActiveTapFinish => 'Tap  🏁  to finish';

  @override
  String get workoutActiveHoldFinish => 'Hold  🏁  to finish';

  @override
  String get workoutFeedbackQuestion => 'How was the workout?';

  @override
  String get workoutFeedbackFinished => 'Routine finished!';

  @override
  String get workoutFeedbackTime => 'TIME';

  @override
  String get workoutFeedbackDistance => 'DISTANCE';

  @override
  String get workoutFeedbackMode => 'MODE';

  @override
  String get workoutFeedbackOutdoor => '🌤 Outdoor';

  @override
  String get workoutFeedbackIndoor => '🏠 Indoor';

  @override
  String get workoutFeedbackDidComplete => 'Did you complete the routine?';

  @override
  String get workoutFeedbackYesComplete => 'Yes, complete';

  @override
  String get workoutFeedbackPartially => 'Partially';

  @override
  String get workoutFeedbackEasy => 'Easy';

  @override
  String get workoutFeedbackMax => 'Max';

  @override
  String get workoutFeedbackRpeEasy => 'Very easy';

  @override
  String get workoutFeedbackRpeModerate => 'Moderate';

  @override
  String get workoutFeedbackRpeSomewhatHard => 'Somewhat hard';

  @override
  String get workoutFeedbackRpeHard => 'Hard';

  @override
  String get workoutFeedbackRpeMax => 'Max effort';

  @override
  String get workoutFeedbackFeelingVeryTired => 'Very tired';

  @override
  String get workoutFeedbackFeelingTired => 'Tired';

  @override
  String get workoutFeedbackFeelingGood => 'Good';

  @override
  String get workoutFeedbackFeelingGreat => 'Great';

  @override
  String get workoutFeedbackYesPain => 'Yes, a little';

  @override
  String get workoutFeedbackNoPain => 'No, none';

  @override
  String get workoutFeedbackPainHint => 'Body part, type of pain...';

  @override
  String get workoutFeedbackAdditionalNotes => 'Additional notes';

  @override
  String get workoutFeedbackOptional => 'Optional';

  @override
  String get workoutFeedbackNotesHint =>
      'E.g.: the last sets were harder, my legs felt heavy...';

  @override
  String get workoutFeedbackSaveFinish => 'Save and finish';

  @override
  String get workoutFeedbackAnswerAll => 'Answer all questions to continue';

  @override
  String get parqQuestion1 =>
      'Has a doctor ever told you that you have a heart condition and that you should only do physical activity under medical supervision?';

  @override
  String get parqShortLabel1 => 'Question 1 — Diagnosed heart condition.';

  @override
  String get parqQuestion2 =>
      'Do you feel chest pain when doing physical activity?';

  @override
  String get parqShortLabel2 =>
      'Question 2 — Chest pain during physical activity.';

  @override
  String get parqQuestion3 =>
      'In the last month, have you felt chest pain at rest?';

  @override
  String get parqShortLabel3 => 'Question 3 — Chest pain at rest.';

  @override
  String get parqQuestion4 =>
      'Do you lose your balance due to dizziness or have you lost consciousness during or after exercise?';

  @override
  String get parqShortLabel4 =>
      'Question 4 — Dizziness or loss of consciousness.';

  @override
  String get parqQuestion5 =>
      'Do you have any bone or joint problems that could worsen with physical activity?';

  @override
  String get parqShortLabel5 => 'Question 5 — Bone or joint problem.';

  @override
  String get parqQuestion6 =>
      'Does a doctor prescribe medication for blood pressure or a heart condition?';

  @override
  String get parqShortLabel6 =>
      'Question 6 — Medication for blood pressure or heart.';

  @override
  String get parqQuestion7 =>
      'Do you know any other reason why you should not do physical activity now?';

  @override
  String get parqShortLabel7 => 'Question 7 — Other medical reason.';

  @override
  String onboardingStepLabel(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String onboardingTestSelectionCompletedCount(int completed, int total) {
    return '$completed/$total completed';
  }

  @override
  String get onboardingTestSelectionCompletedTitle =>
      'Do you want to take more tests?';

  @override
  String get onboardingTestSelectionTitle => 'Functional test battery';

  @override
  String get onboardingTestSelectionCompletedDesc =>
      'Each additional test makes your plan more accurate.';

  @override
  String get onboardingTestSelectionDesc =>
      'We evaluate your actual physical condition. It only takes 20–30 min.';

  @override
  String get onboardingTestSelectionObligatory => 'Mandatory';

  @override
  String get onboardingTestSelectionCompletedBadge => '✅ Completed';

  @override
  String get onboardingTestSelectionCompletedInfo =>
      'You can take the remaining tests now or later from \"My tests\" in your profile.';

  @override
  String get onboardingTestSelectionInfo =>
      'The squats test is mandatory. The others enrich your profile and make your plan more accurate.';

  @override
  String onboardingTestSelectionStartBtn(String title) {
    return 'Start: $title';
  }

  @override
  String get onboardingTestSelectionContinueToPlan => 'Continue to plan →';

  @override
  String get onboardingTestSelectionContinueWithoutTests =>
      'Continue without doing more tests →';

  @override
  String get onboardingTestInstructionTabInstruction => 'Instruction';

  @override
  String get onboardingTestInstructionTabRecord => 'Record';

  @override
  String get onboardingTestInstructionTabFeedback => 'Feedback';

  @override
  String get onboardingTestInstructionHowToTitle => 'How to do it correctly';

  @override
  String get onboardingTestInstructionErrorsTitle => 'Common errors to avoid';

  @override
  String get onboardingTestInstructionMeasuresTitle =>
      'What exactly does this test measure?';

  @override
  String onboardingTestInstructionGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String onboardingTestInstructionDateSubtitle(String day, int week) {
    return '$day · Week $week';
  }

  @override
  String get testSquatsTitle => 'Squats in 1 minute';

  @override
  String get testSquatsTag => 'Lower body strength';

  @override
  String get testSquatsDescShort =>
      'Stand up, feet shoulder-width apart. Lower down to 90° knee flexion.';

  @override
  String get testSquatsDescLong =>
      'Count how many squats you can do in 1 minute. It measures the functional strength of your legs and local muscular endurance — one of the best predictors of athletic performance.';

  @override
  String get testSquatsDurationLabel => '1 min';

  @override
  String get testSquatsStartLabel => 'Start Squats';

  @override
  String get testSquatsPrepHint => 'Stand up, feet shoulder-width apart';

  @override
  String get testSquatsResultHint => 'Count complete repetitions';

  @override
  String get testSquatsMeasuresDesc =>
      'Strength endurance of quadriceps, glutes, and hamstrings. Predicts your capacity to maintain posture on bike, running stride, and power in any sporting discipline.';

  @override
  String get testSquatsStep1Main =>
      'Stand with feet shoulder-width apart. Toes slightly pointed outward (15–30°).';

  @override
  String get testSquatsStep1Tip =>
      'No special footwear is needed — barefoot works perfectly.';

  @override
  String get testSquatsStep2Main =>
      'Lower down until thighs are parallel to the floor — or as close as possible. Straight back, chest up.';

  @override
  String get testSquatsStep2Tip =>
      'If you don\'t reach parallel, go as low as you can without pain.';

  @override
  String get testSquatsStep3Main =>
      'Rise by pushing through your heels. Fully extend knees and hips when reaching the top.';

  @override
  String get testSquatsStep3Tip =>
      'Each rep counts only if you go all the way down AND all the way up.';

  @override
  String get testSquatsStep4Main =>
      'Repeat at a pace you can maintain for the full 60 seconds. You can pause briefly if needed.';

  @override
  String get testSquatsStep4Tip => 'The timer does not stop.';

  @override
  String get testSquatsError1 =>
      'Knees caving in — knees should always follow the direction of the feet.';

  @override
  String get testSquatsError2 =>
      'Heels lifting — if this happens, widen stance or place something thin under heels.';

  @override
  String get testSquatsError3 =>
      'Rounded back — keep chest high throughout the movement.';

  @override
  String get testCooperTitle => 'Cooper Test';

  @override
  String get testCooperTag => 'Cardiovascular endurance';

  @override
  String get testCooperDescShort =>
      'Run or walk fast for 12 continuous minutes. Measure distance in meters.';

  @override
  String get testCooperDescLong =>
      'Run or walk fast for 12 continuous minutes. Measure total distance covered in meters. It is one of the most widely used methods to estimate VO2 Max.';

  @override
  String get testCooperDurationLabel => '12 min';

  @override
  String get testCooperStartLabel => 'Start Cooper Test';

  @override
  String get testCooperPrepHint => 'Position yourself at your starting point';

  @override
  String get testCooperResultHint =>
      'Record the distance covered when finished';

  @override
  String get testCooperMeasuresDesc =>
      'Maximal aerobic capacity (estimated VO2 Max). Predicts general endurance, recovery between sessions, and potential for cardiovascular improvement.';

  @override
  String get testCooperStep1Main =>
      'Look for a flat and measured track or path — ideally a 400m running track.';

  @override
  String get testCooperStep1Tip =>
      'A flat street with GPS tracking also works.';

  @override
  String get testCooperStep2Main =>
      'Warm up for 5 minutes by walking or jogging gently before starting the timer.';

  @override
  String get testCooperStep3Main =>
      'When starting, run or walk as fast as you can for exactly 12 minutes.';

  @override
  String get testCooperStep3Tip =>
      'Maintain a pace you can sustain — do not start too fast.';

  @override
  String get testCooperStep4Main =>
      'When finished, record the total distance covered in meters.';

  @override
  String get testCooperStep4Tip =>
      'FitnFlai will automatically calculate your estimated VO2 Max.';

  @override
  String get testCooperError1 =>
      'Starting too fast and exhausting yourself in the first few minutes.';

  @override
  String get testCooperError2 =>
      'Taking long breaks — if you need to walk, it\'s fine, but keep moving.';

  @override
  String get testCooperError3 =>
      'Not measuring distance accurately — use GPS or a known track.';

  @override
  String get testPushupsTitle => 'Push-ups in 1 minute';

  @override
  String get testPushupsTag => 'Upper body strength';

  @override
  String get testPushupsDescShort =>
      'Full plank. Lower down until chest almost touches the floor.';

  @override
  String get testPushupsDescLong =>
      'Count how many full push-ups you can do in 1 minute. Measures muscular strength and endurance of the chest, shoulders, and triceps.';

  @override
  String get testPushupsDurationLabel => '1 min';

  @override
  String get testPushupsStartLabel => 'Start Push-ups';

  @override
  String get testPushupsPrepHint => 'Plank position, ready to start';

  @override
  String get testPushupsResultHint => 'Count complete repetitions';

  @override
  String get testPushupsMeasuresDesc =>
      'Chest, shoulders, and triceps strength-endurance. Predicts your capacity to maintain posture on bike, swimming stroke power, and general stability.';

  @override
  String get testPushupsStep1Main =>
      'Full plank position: hands shoulder-width apart, body straight from head to heels.';

  @override
  String get testPushupsStep1Tip =>
      'Knees on the floor if you need to modify the difficulty.';

  @override
  String get testPushupsStep2Main =>
      'Lower down until chest almost touches the floor. Elbows at 45° to your body — neither too flared nor tucked.';

  @override
  String get testPushupsStep2Tip =>
      'Keep your abdomen contracted throughout the movement.';

  @override
  String get testPushupsStep3Main =>
      'Rise by fully extending your elbows. Only full repetitions count: down AND up.';

  @override
  String get testPushupsStep4Main =>
      'Repeat at a pace you can maintain for the full 60 seconds. You can pause briefly.';

  @override
  String get testPushupsStep4Tip =>
      'The timer does not stop even if you pause.';

  @override
  String get testPushupsError1 =>
      'Lowering only halfway — chest must almost touch the floor.';

  @override
  String get testPushupsError2 =>
      'Hips up or down — body must remain straight.';

  @override
  String get testPushupsError3 =>
      'Elbows too wide (90°) — increases risk of shoulder injury.';

  @override
  String get testPlankTitle => 'Core Plank';

  @override
  String get testPlankTag => 'Core / Stability';

  @override
  String get testPlankDescShort =>
      'Plank on forearms and feet. Straight body. Maximum time possible.';

  @override
  String get testPlankDescLong =>
      'Maintain the plank position as long as possible. Measures core endurance, fundamental for efficiency in all sports.';

  @override
  String get testPlankDurationLabel => 'Max. time';

  @override
  String get testPlankStartLabel => 'Start Plank';

  @override
  String get testPlankPrepHint => 'Position on forearms, straight body';

  @override
  String get testPlankResultHint =>
      'Stop the timer when you cannot hold any longer';

  @override
  String get testPlankMeasuresDesc =>
      'Isometric endurance of the core (abs, lower back, glutes). Predicts running and biking posture, lower back injury prevention, and force transfer efficiency.';

  @override
  String get testPlankStep1Main =>
      'Position on forearms and feet: elbows right under shoulders, parallel forearms.';

  @override
  String get testPlankStep1Tip =>
      'You can interlock your hands or keep them flat.';

  @override
  String get testPlankStep2Main =>
      'Body completely straight from head to heels. Activate your abs as if you were about to be punched.';

  @override
  String get testPlankStep2Tip => 'Do not let your hips rise or sag.';

  @override
  String get testPlankStep3Main =>
      'Hold the fixed position looking down. Breathe continuously and in a controlled manner.';

  @override
  String get testPlankStep4Main =>
      'The test ends when hips sag, rise excessively, or the body stops being straight.';

  @override
  String get testPlankStep4Tip =>
      'FitnFlai records the time in seconds automatically.';

  @override
  String get testPlankError1 => 'Hips too high — body loses its straight line.';

  @override
  String get testPlankError2 =>
      'Hips towards floor — compensates for core weakness.';

  @override
  String get testPlankError3 =>
      'Holding breath — breathe continuously during the entire test.';

  @override
  String get testPlankError4 =>
      'Elbows too far from shoulders — reduces exercise effectiveness.';

  @override
  String get testFlexibilityTitle => 'Forward Bend';

  @override
  String get testFlexibilityTag => 'Flexibility';

  @override
  String get testFlexibilityDescShort =>
      'Stand up, legs together. Lean forward as far as possible.';

  @override
  String get testFlexibilityDescLong =>
      'Measures your hamstring and lumbar flexibility. Flexibility directly impacts your pedaling technique, stride, and injury prevention.';

  @override
  String get testFlexibilityDurationLabel => '1 attempt';

  @override
  String get testFlexibilityStartLabel => 'Start Flexibility';

  @override
  String get testFlexibilityPrepHint => 'Stand up, legs together and extended';

  @override
  String get testFlexibilityResultHint => 'Select how far your hands reached';

  @override
  String get testFlexibilityMeasuresDesc =>
      'Flexibility of hamstrings and lower back. Predicts range of motion in pedaling, stride efficiency, and lower back injury risk.';

  @override
  String get testFlexibilityStep1Main =>
      'Stand up, join your feet completely. Legs extended, without bending knees at any moment.';

  @override
  String get testFlexibilityStep1Tip =>
      'You can lean against a wall to maintain balance.';

  @override
  String get testFlexibilityStep2Main =>
      'Inhale deeply. When exhaling, slowly bend forward bringing your hands towards the floor.';

  @override
  String get testFlexibilityStep2Tip =>
      'No bouncing — movement must be smooth and controlled.';

  @override
  String get testFlexibilityStep3Main =>
      'Go as far as you can without bending knees or forcing. Hold position for 2–3 seconds.';

  @override
  String get testFlexibilityStep3Tip =>
      'FitnFlai records how far your hands reach.';

  @override
  String get testFlexibilityStep4Main =>
      'Repeat twice and take the best result.';

  @override
  String get testFlexibilityStep4Tip =>
      'Body usually opens up a bit more on second attempt.';

  @override
  String get testFlexibilityError1 =>
      'Bending knees — invalidates hamstring stretch.';

  @override
  String get testFlexibilityError2 =>
      'Bouncing downwards — can cause muscle injury.';

  @override
  String get testFlexibilityError3 =>
      'Forcing past the limit — there should be tension, not pain.';

  @override
  String get onboardingTestTimerErrorResultEmpty =>
      'Enter your result before continuing';

  @override
  String get onboardingTestTimerErrorSave => 'Error saving result. Try again.';

  @override
  String get onboardingTestTimerErrorConnection =>
      'Connection error. Try again.';

  @override
  String get onboardingTestTimerBadgeFree => 'Free';

  @override
  String get onboardingTestTimerStatusCompleted => 'Completed';

  @override
  String get onboardingTestTimerLabelRemaining => 'Time remaining';

  @override
  String get onboardingTestTimerLabelElapsed => 'Time elapsed';

  @override
  String get onboardingTestTimerStatusPaused => 'Paused';

  @override
  String get onboardingTestTimerStatusReady => 'Ready';

  @override
  String get onboardingTestTimerRepsHint => 'count your reps';

  @override
  String get onboardingTestTimerBtnStart => 'Start';

  @override
  String get onboardingTestTimerBtnPause => 'Pause';

  @override
  String get onboardingTestTimerBtnResume => 'Resume';

  @override
  String get onboardingTestTimerBtnFinish => 'Finish now';

  @override
  String get onboardingTestTimerBtnReset => 'Reset from scratch';

  @override
  String get onboardingTestTimerSuccessTitle => 'Test completed!';

  @override
  String onboardingTestTimerSuccessTime(String time) {
    return 'Time: $time';
  }

  @override
  String get onboardingTestTimerFlexibilityQuestion =>
      'How far did your hands reach?';

  @override
  String get onboardingTestTimerFlexibilityOpt1 => 'Doesn\'t reach knees';

  @override
  String get onboardingTestTimerFlexibilityOpt2 => 'Reaches feet';

  @override
  String get onboardingTestTimerFlexibilityOpt3 => 'Past feet';

  @override
  String get onboardingTestTimerFlexibilityOpt4 => 'Palms to the floor';

  @override
  String onboardingTestTimerInputLabel(String unit) {
    return 'Enter your result in $unit';
  }

  @override
  String get onboardingTestTimerBtnSave => 'Save and continue';

  @override
  String get onboardingTestTimerBorgQuestion =>
      'How much effort did you perceive? (Borg 6–20)';

  @override
  String get onboardingTestTimerBorgLabelNone => 'None';

  @override
  String get onboardingTestTimerBorgLabelHard => 'Somewhat hard';

  @override
  String get onboardingTestTimerBorgLabelMax => 'Maximal';

  @override
  String get onboardingTestTimerBorgLevel6 => 'No exertion';

  @override
  String get onboardingTestTimerBorgLevel7 => 'Extremely light';

  @override
  String get onboardingTestTimerBorgLevel8 => 'Very light';

  @override
  String get onboardingTestTimerBorgLevel9 => 'Light';

  @override
  String get onboardingTestTimerBorgLevel10 => 'Fairly light';

  @override
  String get onboardingTestTimerBorgLevel11 => 'Mild';

  @override
  String get onboardingTestTimerBorgLevel12 => 'Somewhat hard';

  @override
  String get onboardingTestTimerBorgLevel13 => 'Hard';

  @override
  String get onboardingTestTimerBorgLevel14 => 'Very hard';

  @override
  String get onboardingTestTimerBorgLevel15 => 'Strenuous';

  @override
  String get onboardingTestTimerBorgLevel16 => 'Very strenuous';

  @override
  String get onboardingTestTimerBorgLevel17 => 'Extremely hard';

  @override
  String get onboardingTestTimerBorgLevel18 => 'Nearly maximal';

  @override
  String get onboardingTestTimerBorgLevel19 => 'Very close to maximal';

  @override
  String get onboardingTestTimerBorgLevel20 => 'Maximal exertion';

  @override
  String get onboardingTestFeedbackErrorSave =>
      'Error saving feedback. Try again.';

  @override
  String get onboardingTestFeedbackBtnSave => 'Save feedback';

  @override
  String get onboardingTestFeedbackAnswerAll =>
      'Answer all questions to continue';

  @override
  String get onboardingTestFeedbackDesc =>
      'Tell us how it went — this customizes your plan.';

  @override
  String get onboardingTestFeedbackCompletionQuestion =>
      'Did you complete the test 100%?';

  @override
  String get onboardingTestFeedbackCompletionYes => '✓  Yes, complete';

  @override
  String get onboardingTestFeedbackCompletionNo => '✗  Not entirely';

  @override
  String get onboardingTestFeedbackRpeQuestion =>
      'Did you feel any pain or discomfort?';

  @override
  String get onboardingTestFeedbackRpeScale => 'RPE Scale 1–10';

  @override
  String get onboardingTestFeedbackRpeScaleEasy => 'Very easy';

  @override
  String get onboardingTestFeedbackRpeScaleMax => 'Maximal effort';

  @override
  String get onboardingTestFeedbackRpeLabelVeryEasy => 'Very easy';

  @override
  String get onboardingTestFeedbackRpeLabelModerate => 'Moderate';

  @override
  String get onboardingTestFeedbackRpeLabelSomewhatHard => 'Somewhat hard';

  @override
  String get onboardingTestFeedbackRpeLabelHard => 'Hard';

  @override
  String get onboardingTestFeedbackRpeLabelVeryHard => 'Very hard';

  @override
  String get onboardingTestFeedbackRpeLabelMax => 'Maximal effort';

  @override
  String get onboardingTestFeedbackFeelingQuestion =>
      'How did you feel during the test?';

  @override
  String get onboardingTestFeedbackFeelingVeryTired => 'Very tired';

  @override
  String get onboardingTestFeedbackFeelingTired => 'Tired';

  @override
  String get onboardingTestFeedbackFeelingGood => 'Good';

  @override
  String get onboardingTestFeedbackFeelingGreat => 'Great';

  @override
  String get onboardingTestFeedbackFeelingOwnWords =>
      'Tell us in your own words (optional)';

  @override
  String get onboardingTestFeedbackFeelingHint =>
      'E.g.: I felt energetic although it was hard at the end...';

  @override
  String get onboardingTestFeedbackPainQuestion =>
      'Did you feel any pain or discomfort?';

  @override
  String get onboardingTestFeedbackPainYes => 'Yes, some';

  @override
  String get onboardingTestFeedbackPainNo => 'No, none';

  @override
  String get onboardingTestFeedbackPainDescHint =>
      'Describe it: area of the body, type of pain...';

  @override
  String get onboardingTestFeedbackNotesQuestion =>
      'Anything else you want to tell us?';

  @override
  String get onboardingTestFeedbackOptional => 'Optional';

  @override
  String get onboardingTestFeedbackNotesHint =>
      'E.g.: the last reps were harder, my legs felt heavy...';

  @override
  String get onboardingTestTimerModeFree => 'Free';

  @override
  String get profileSectionSpecialist => 'SPECIALIST';

  @override
  String get profileMenuBookSpecialist => 'Book specialist session';

  @override
  String get specialistBookingDefaultName => 'Dr. Sophia Rodriguez';

  @override
  String get specialistBookingDefaultBio =>
      'Sports nutrition and kinesiology specialist. She will guide you to reach your goals by optimizing your plan.';

  @override
  String get specialistBookingCheckoutPrice => 'Price';

  @override
  String get profileActiveBookingHeader => 'Your scheduled session:';

  @override
  String get profileActiveBookingJoinBtn => 'Join Session';

  @override
  String get profileActiveBookingCancelBtn => 'Cancel Session';

  @override
  String get dailyCheckinLabelPulse => 'Heart Rate';

  @override
  String get dailyCheckinQuestionPulse =>
      'Measure your pulse for 15 seconds with the stopwatch and enter it.';

  @override
  String get dailyCheckinPulseHint => 'Pulses in 15 sec';

  @override
  String dailyCheckinPulseCalculated(String bpm) {
    return 'Your estimated HR is $bpm bpm';
  }

  @override
  String get dailyCheckinScorePulse => 'Pulse';

  @override
  String get workoutAdjustmentTitle => 'Adjust workout';

  @override
  String get specialistBookingNoSpecialist =>
      'First, you need to select a specialist';

  @override
  String get specialistBookingNo30DayAvailability =>
      'This specialist has no appointments available in the next 30 days';

  @override
  String get specialistBookingNoSlotsForSelectedDate =>
      'This specialist has no appointments available for the selected date';

  @override
  String get specialistBookingEliteRequiredTitle => 'Elite Plan Required';

  @override
  String get specialistBookingEliteRequiredDesc =>
      'To access specialist booking, you need an Elite plan.';

  @override
  String get specialistBookingUpgradeBtn => 'Upgrade Plan';

  @override
  String get workoutActiveGpsDisabled =>
      'Your device GPS is disabled. It is required to train outdoors.';

  @override
  String get workoutActiveGpsDenied =>
      'Location permissions were denied. Please enable them to train outdoors.';

  @override
  String get workoutActiveGpsDeniedForever =>
      'Location permissions are permanently denied. Please enable them in your system settings.';

  @override
  String get workoutActiveGpsRequired => 'GPS Required';

  @override
  String get workoutActiveSwitchToIndoor => 'Switch to Indoor';

  @override
  String get workoutActiveGoToSettings => 'Go to Settings';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get submitButton => 'Submit';

  @override
  String get profileMenuPaymentMethods => 'Payment Methods';

  @override
  String subscribeToPlan(String planName) {
    return 'Subscribe to $planName';
  }

  @override
  String payWithCardEnding(String brand, String lastFour) {
    return 'Pay with $brand ending in $lastFour';
  }

  @override
  String get confirmAndSubscribe => 'Confirm & Subscribe';

  @override
  String get associateCardAndSubscribe => 'Associate Card & Subscribe';

  @override
  String get processingYourPayment => 'Processing your payment...';

  @override
  String get nuveiVerificationMessage =>
      'We are verifying the transaction with Nuvei. This will take a few seconds, please do not close the app.';

  @override
  String get paymentCompleted => 'Payment Completed!';

  @override
  String get membershipActivatedMessage =>
      'Your membership has been successfully activated. You now have full access to all Fitnflai premium features.';

  @override
  String get startTraining => 'Start Training';

  @override
  String get loadingCards => 'Loading cards...';

  @override
  String get errorTitle => 'Error';

  @override
  String get retryButton => 'Retry';
}
