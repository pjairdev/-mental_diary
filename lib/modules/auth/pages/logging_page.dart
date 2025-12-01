import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:teste_flutter/app_router.dart';
import '../widgets/custom_text_field.dart';

class LoggingPage extends StatefulWidget {
  const LoggingPage({super.key});

  static final Uri dbUrl = Uri.https(
    "connect-8d1ed-default-rtdb.firebaseio.com",
    "/users.json",
  );

  @override
  State<LoggingPage> createState() => _LoggingPageState();
}

class _LoggingPageState extends State<LoggingPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isValidForm = false;
  bool _isLoading = false;

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => _isValidForm = isValid);
  }

  Future<bool> _emailExists(String email) async {
    final res = await http.get(LoggingPage.dbUrl);

    if (res.statusCode != 200) return false;

    final data = jsonDecode(res.body);
    if (data == null) return false;

    return data.values.any((entry) {
      return entry['email'] == email;
    });
  }

  Future<void> _loginUser() async {
    try {
      setState(() => _isLoading = true);

      final email = _email.text.trim();
      final password = _password.text.trim();

      final exists = await _emailExists(email);

      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email não cadastrado.")),
        );
        setState(() => _isLoading = false);
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      String msg = "Erro ao fazer login";

      if (e.code == "wrong-password") msg = "Senha incorreta";
      if (e.code == "invalid-email") msg = "Email inválido";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _loginUser();
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Fazer Login',
                        style: TextStyle(
                          fontSize: 30,
                          height: 1.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Form(
                        key: _formKey,
                        onChanged: _validateForm,
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'Email',
                              controller: _email,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Informe seu email';
                                }
                                final emailRegex =
                                    RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                if (!emailRegex.hasMatch(v)) {
                                  return 'Email inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Senha',
                              controller: _password,
                              isPassword: true,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Informe sua senha';
                                }
                                if (v.length < 6) {
                                  return 'Mínimo 6 caracteres';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isValidForm && !_isLoading
                                    ? _submit
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 127, 189, 156),
                                  disabledBackgroundColor:
                                      const Color.fromARGB(255, 101, 194, 143),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
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
