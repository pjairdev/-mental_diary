import 'package:flutter/material.dart';

import 'package:teste_flutter/modules/auth/pages/home_page.dart';
import 'package:teste_flutter/modules/auth/pages/login_page.dart';
import 'package:teste_flutter/modules/auth/pages/create_account_page.dart';
import 'package:teste_flutter/modules/auth/pages/logging_page.dart';
import 'package:teste_flutter/modules/auth/screen/google_login_screen.dart';
import 'package:teste_flutter/modules/auth/pages/exercise_page.dart';
import 'package:teste_flutter/modules/auth/pages/terms_page.dart';


// IMPORT CORRETO: a página de perfil (não o botão)
import 'package:teste_flutter/modules/auth/pages/profile_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String signup = '/signup';
  static const String logging = '/logging';
  static const String authGoogle = '/auth/google';
  static const String home = '/home';
  static const String authApple = '/auth/apple';
  static const String exercises = '/exercises';
  static const String profile = '/profile';
  static const String terms = '/terms';

}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const CreateAccountPage());

      case AppRoutes.logging:
        return MaterialPageRoute(builder: (_) => const LoggingPage());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.authGoogle:
        return MaterialPageRoute(builder: (_) => const GoogleLoginScreen());

      case AppRoutes.exercises:
        return MaterialPageRoute(builder: (_) => const ExercisesPage());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case AppRoutes.terms:
        return MaterialPageRoute(builder: (_) => const TermsPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Rota não encontrada'))),
        );
    }
  }
}
