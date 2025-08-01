import 'package:go_router/go_router.dart';

import '../auth/presentation/biometric_page.dart';
import '../auth/presentation/login_page.dart';
import '../auth/presentation/pin_confirm_page.dart';
import '../auth/presentation/pin_enter_page.dart';
import '../auth/profil/presentation/profile_page.dart';
import '../splash/presentation/slash_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/pin-confirm', builder: (_, __) => const PinConfirmPage()),
      GoRoute(path: '/pin-enter', builder: (_, __) => const PinEnterPage()),
      GoRoute(path: '/biometric', builder: (_, __) => const BiometricPage()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
    ],
  );
}
