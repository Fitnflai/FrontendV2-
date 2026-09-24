import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/onboarding_router.dart'; // Added
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

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

    // Esperar a que el estado de autenticación termine de inicializarse
    while (auth.status == AuthStatus.uninitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (!mounted) return;
    final route = await OnboardingRouter.getOnboardingTargetRoute(context);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
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
