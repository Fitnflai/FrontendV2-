import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'config/app_routes.dart';
import 'config/app_theme_extension.dart';
import 'providers/auth_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/notification_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/notification_service.dart';
import 'providers/theme_provider.dart';
import 'services/cached_http.dart';

import 'providers/nutrition_provider.dart';
import 'providers/wellness_index_provider.dart';
import 'providers/progress_report_provider.dart';
import 'services/progress_service.dart';
import 'package:fitnflaifrontendv2/providers/health_provider.dart';
import 'package:fitnflaifrontendv2/services/health/health_repository.dart';
import 'package:fitnflaifrontendv2/providers/specialist_provider.dart';
import 'package:fitnflaifrontendv2/services/specialist_service.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/onboarding/step1_parq_screen.dart';
import 'screens/onboarding/step1_parq_result_clear_screen.dart';
import 'screens/onboarding/step6_sport_screen.dart';
import 'screens/onboarding/step2_profile_screen.dart';
import 'screens/onboarding/step3_fitness_screen.dart';
import 'screens/onboarding/step4_body_screen.dart';
import 'screens/onboarding/step7_generating_screen.dart';
import 'screens/onboarding/step8_onboarding_feedback_screen.dart';
import 'screens/onboarding/step5_test_selection_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/plans/plan_screen.dart';
import 'screens/progress/progress_screen.dart';
import 'screens/nutrition/nutrition_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/reporte_config_screen.dart';
import 'screens/profile/notifications_panel_screen.dart';
import 'screens/profile/payment_methods_screen.dart';
import 'screens/legal/terms_and_conditions_screen.dart';
import 'screens/legal/privacy_policy_screen.dart';
import 'screens/membership/membership_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }

  final prefs = await SharedPreferences.getInstance();
  final String? selectedLanguageCode = prefs.getString('selected_language');
  final initialLocale = Locale(selectedLanguageCode ?? 'es');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider(authProvider: Provider.of<AuthProvider>(context, listen: false))),
        ChangeNotifierProvider(create: (_) => NotificationProvider(NotificationService())),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NutritionProvider()),
        ChangeNotifierProvider(create: (_) => WellnessIndexProvider()),
        ChangeNotifierProvider(create: (_) => ProgressReportProvider(ProgressService())),
        ChangeNotifierProvider<HealthProvider>(create: (_) => HealthProvider(HealthRepository())),
        ChangeNotifierProvider(create: (_) => SpecialistProvider(SpecialistService())),
      ],
      child: FitnflaiApp(initialLocale: initialLocale),
    ),
  );
}

class FitnflaiApp extends StatefulWidget {
  final Locale initialLocale;
  const FitnflaiApp({super.key, required this.initialLocale});

  static FitnflaiAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<FitnflaiAppState>();

  @override
  State<FitnflaiApp> createState() => FitnflaiAppState();
}

class FitnflaiAppState extends State<FitnflaiApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;

  }

  void setLocale(Locale newLocale) {
    if (newLocale.languageCode != 'en' && newLocale.languageCode != 'es') return;
    setState(() {
      _locale = newLocale;
    });

    CachedHttp.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Fitnflai',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [ 
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        extensions: const [AppThemeExtension.light],
        scaffoldBackgroundColor: AppThemeExtension.light.bg,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        extensions: const [AppThemeExtension.dark],
        scaffoldBackgroundColor: AppThemeExtension.dark.bg,
        fontFamily: 'Roboto',
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash:   (_) => const SplashScreen(),
        AppRoutes.welcome:  (_) => const WelcomeScreen(),
        AppRoutes.login:    (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.parq:     (_) => const PARQScreen(),
        AppRoutes.parqClear:  (_) => const PARQResultClearScreen(),
        AppRoutes.step6Sport:   (_) => const Step6SportScreen(),
        AppRoutes.step2Profile: (_) => const Step2ProfileScreen(),
        AppRoutes.step3Fitness: (_) => const Step3FitnessScreen(),
        AppRoutes.step4Body:  (_) => const Step4BodyScreen(),
                AppRoutes.generating: (_) => const GeneratingScreen(),
        AppRoutes.step5Test: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as List<int>?;
          return TestSelectionScreen(completedTests: args ?? const []);
        },
        AppRoutes.onboardingFeedback: (_) => OnboardingFeedbackScreen(),
        AppRoutes.home:        (_) => const HomeScreen(),
        AppRoutes.plan:        (_) => const PlanScreen(),
        AppRoutes.progress:    (_) => const ProgressScreen(),
        AppRoutes.nutrition:        (_) => const NutritionScreen(),
        AppRoutes.profile:       (_) => const ProfileScreen(),
        AppRoutes.editProfile:   (_) => const EditProfileScreen(),
        AppRoutes.reporteConfig: (_) => const ReporteConfigScreen(),
        AppRoutes.termsConditions: (_) => const TermsAndConditionsScreen(),
        AppRoutes.privacyPolicy: (_) => const PrivacyPolicyScreen(),
        AppRoutes.membership:    (_) => const MembershipScreen(),
        '/notifications':        (_) => const NotificationsPanelScreen(),
      },
      onGenerateRoute: (settings) {
        debugPrint('🔍 [DEEP LINK main.dart] onGenerateRoute called with settings.name: "${settings.name}"');
        if (settings.name != null && (settings.name!.contains('payment-methods') || settings.name!.contains('token='))) {
          final uri = Uri.parse(settings.name!);
          debugPrint('🔍 [DEEP LINK main.dart] Matched payment/token. Parsed URI: $uri');
          
          final isFromMembership = settings.name!.contains('membership');
          String? priceId;
          if (isFromMembership) {
            final segments = uri.pathSegments;
            debugPrint('🔍 [DEEP LINK main.dart] segments: $segments');
            final index = segments.indexOf('membership');
            if (index != -1 && index + 1 < segments.length) {
              priceId = segments[index + 1];
            }
          }
          debugPrint('🔍 [DEEP LINK main.dart] resolved priceId: "$priceId", isFromMembership: $isFromMembership');

          final initialToken = uri.queryParameters['token'];
          final initialLastFour = uri.queryParameters['last_four'];
          final initialBrand = uri.queryParameters['brand'];
          final initialExpMonth = uri.queryParameters['exp_month'];
          final initialExpYear = uri.queryParameters['exp_year'];

          return MaterialPageRoute(
            builder: (_) => PaymentMethodsScreen(
              initialToken: initialToken,
              initialLastFour: initialLastFour,
              initialBrand: initialBrand,
              initialExpMonth: initialExpMonth,
              initialExpYear: initialExpYear,
              isFromMembership: isFromMembership,
              priceId: priceId,
            ),
          );
        }
        return null; // Let onUnknownRoute handle it if not a payment-methods deep link
      },
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }
} 