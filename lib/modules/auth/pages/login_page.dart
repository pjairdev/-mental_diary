import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/social_button.dart';
import '../../../app_router.dart';
import '../../../modules/auth/service/google_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      // Carrega tela de progresso
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      final UserCredential? credential =
          await GoogleSignInService.signInWithGoogle();

      Navigator.pop(context); // Remove o loading

      if (credential != null) {
        // Login OK → Vai para página principal
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        // Falha inesperada
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Falha ao autenticar com o Google.")),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Remove loading

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao fazer login: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 140,
                          height: 140,
                        ),

                        const SizedBox(height: 16),
                        const Text(
                          'Diário Mental',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2933),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            'Sua jornada de autoconhecimento começa agora.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1F2933),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // BOTOES
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28.0,
                        vertical: 32.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: FractionallySizedBox(
                              widthFactor: 0.49,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.logging,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 28,
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FractionallySizedBox(
                              widthFactor: 0.49,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.signup,
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 28,
                                  ),
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text(
                                  'Criar Nova Conta',
                                  style: TextStyle(
                                    color: Color(0xFF1F2933),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Redes Sociais
                          Column(
                            children: [
                              Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    77,
                                    121,
                                    118,
                                    118,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Ou entre com',
                                style: TextStyle(color: Color(0xFF1F2933)),
                              ),
                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 🔥 LOGIN COM O GOOGLE (COM LÓGICA REAL)
                                  SocialButton(
                                    assetName: 'assets/images/google.png',
                                    onPressed: () => _loginWithGoogle(context),
                                  ),

                                  const SizedBox(width: 20),

                                  // Botão iOS
                                  SocialButton(
                                    assetName: 'assets/images/ios.png',
                                    onPressed: () => Navigator.pushNamed(
                                      context,
                                      AppRoutes.logging,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
