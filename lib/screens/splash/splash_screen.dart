import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/onboarding_router.dart'; // Added
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/welcome_screen.dart';
import '../home/home_screen.dart';
import '../onboarding/step1_parq_screen.dart';
import '../onboarding/step2_profile_screen.dart';
import '../onboarding/step3_fitness_screen.dart';
import '../onboarding/step4_body_screen.dart';
import '../onboarding/step5_test_selection_screen.dart';
import '../onboarding/step6_sport_screen.dart';
import '../onboarding/step7_generating_screen.dart';
import '../onboarding/step8_onboarding_feedback_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;


  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim  = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
    _scaleAnim = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );

    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    // Esperar al menos el delay de la animación del splash
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    debugPrint('🔍 [DEEP LINK splash] _navigate started. Initial auth.status: ${auth.status}');

    // Esperar a que el estado de autenticación termine de inicializarse
    while (auth.status == AuthStatus.uninitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    debugPrint('🔍 [DEEP LINK splash] Auth initialized. auth.status: ${auth.status}, token present: ${auth.token != null}');

    if (!mounted) return;
    final route = await OnboardingRouter.getOnboardingTargetRoute(context);
    debugPrint('🔍 [DEEP LINK splash] getOnboardingTargetRoute returned: "$route"');
    if (!mounted) return;

    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    debugPrint('🔍 [DEEP LINK splash] isCurrent (Splash is topmost): $isCurrent');
    if (isCurrent) {
      debugPrint('🔍 [DEEP LINK splash] Splash is topmost. Replacing with: "$route"');
      Navigator.pushReplacementNamed(context, route);
    } else {
      debugPrint('🔍 [DEEP LINK splash] Splash is NOT topmost (Deep-linked route is active). Replacing background splash with: "$route"');
      // Si hay una pantalla encima (como la de pasarela por deep link),
      // reemplazamos el splash screen que está debajo de forma silenciosa
      Widget targetWidget;
      switch (route) {
        case AppRoutes.welcome:
          targetWidget = const WelcomeScreen();
          break;
        case AppRoutes.home:
          targetWidget = const HomeScreen();
          break;
        case AppRoutes.parq:
          targetWidget = const PARQScreen();
          break;
        case AppRoutes.step2Profile:
          targetWidget = const Step2ProfileScreen();
          break;
        case AppRoutes.step3Fitness:
          targetWidget = const Step3FitnessScreen();
          break;
        case AppRoutes.step4Body:
          targetWidget = const Step4BodyScreen();
          break;
        case AppRoutes.step5Test:
          targetWidget = const TestSelectionScreen(completedTests: []);
          break;
        case AppRoutes.step6Sport:
          targetWidget = const Step6SportScreen();
          break;
        case AppRoutes.generating:
          targetWidget = const GeneratingScreen();
          break;
        case AppRoutes.onboardingFeedback:
          targetWidget = OnboardingFeedbackScreen();
          break;
        default:
          targetWidget = const HomeScreen();
      }
      Navigator.of(context).replace(
        oldRoute: ModalRoute.of(context)!,
        newRoute: MaterialPageRoute(builder: (_) => targetWidget),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precarga el asset para evitar freeze en debug
    precacheImage(const AssetImage('assets/images/logo.png'), context);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 60,
                  fit: BoxFit.contain,
                  // Fallback por si el asset no carga
                  errorBuilder: (_, __, ___) => const Text(
                    'Fitnflai',
                    style: TextStyle(
                      color: AppColors.orange,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '"Wellness completo, a tu ritmo."',
                  style: TextStyle(
                      color: AppColors.grey, fontSize: 14),
                ),
                const SizedBox(height: 48),
                const SizedBox(
                  width: 28, height: 28,
                  child: CircularProgressIndicator(
                    color: AppColors.orange,
                    strokeWidth: 2.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
