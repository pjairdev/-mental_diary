import 'package:flutter/material.dart';
import 'package:teste_flutter/app_router.dart';
import '../widgets/custom_text_field.dart';

class LoggingPage extends StatefulWidget {
  const LoggingPage({super.key});

  @override
  State<LoggingPage> createState() => _LoggingPageState();
}

class _LoggingPageState extends State<LoggingPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isValidForm = false;

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => _isValidForm = isValid);
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9FB7D9), Color(0xFFD3DFE6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                /// 🔙 Botão voltar no topo
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black87,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                /// 🧩 Conteúdo central: título + inputs + botão
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// ------------------------
                      /// TÍTULO
                      /// Ajuste o SizedBox abaixo para elevar/baixar o título
                      /// ------------------------
                      const Text(
                        'Fazer Login',
                        style: TextStyle(
                          fontSize: 30,
                          height: 1.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(
                        height: 28,
                      ), // espaço entre título e inputs

                      Form(
                        key: _formKey,
                        onChanged: _validateForm,
                        child: Column(
                          children: [
                            /// ------------------------
                            /// INPUT EMAIL
                            /// Ajuste o SizedBox ENTRE inputs
                            /// ------------------------
                            CustomTextField(
                              label: 'Email',
                              controller: _emailController,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Informe seu email';
                                final emailRegex = RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                );
                                if (!emailRegex.hasMatch(v))
                                  return 'Email inválido';
                                return null;
                              },
                            ),

                            const SizedBox(height: 12),

                            /// ------------------------
                            /// INPUT SENHA
                            /// ------------------------
                            CustomTextField(
                              label: 'Senha',
                              controller: _passwordController,
                              isPassword: true,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Informe sua senha';
                                if (v.length < 6) return 'Mínimo 6 caracteres';
                                return null;
                              },
                            ),

                            /// ------------------------
                            /// BOTÃO "LOGAR"
                            /// Ajuste o SizedBox abaixo para aproximar/afastar
                            /// ------------------------
                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isValidForm ? _submit : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    127,
                                    189,
                                    156,
                                  ),
                                  disabledBackgroundColor: const Color.fromARGB(
                                    255,
                                    101,
                                    194,
                                    143,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text(
                                  'Logar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
