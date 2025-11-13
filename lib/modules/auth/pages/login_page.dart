import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/social_button.dart';
import '../widgets/primary_button.dart';
import '../../../app_router.dart';

// O widget 'OutlinedButtonCustom' não é mais necessário,
// pois implementamos o OutlinedButton diretamente.
// import '../widgets/outlined_button_custom.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                            color: Color(
                              0xFF1F2933,
                            ), // Garantindo que o título também seja branco no gradiente
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
                              color: Color(
                                0xFF1F2933,
                              ), // Cor mais clara para o texto
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                  foregroundColor:
                                      Colors.white, // 🔹 Texto branco
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
                                ), // Usando AppRoutes.signup, conforme lógica anterior
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
                                    // Cor já definida por foregroundColor no styleFrom, mas mantemos aqui por segurança
                                    color: Color(0xFF1F2933),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
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
                                  SocialButton(
                                    assetName: 'assets/images/google.png',
                                    onPressed: () => Navigator.pushNamed(
                                      context,
                                      AppRoutes.authGoogle,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
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
