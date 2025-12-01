import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../widgets/custom_text_field.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  static final Uri usersUrl = Uri.https(
    "connect-8d1ed-default-rtdb.firebaseio.com",
    "/users.json",
  );

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _termsAccepted = false;
  bool _isValidForm = false;
  bool _isLoading = false;

  void _validateForm() {
    final valid = _formKey.currentState?.validate() ?? false;
    setState(() => _isValidForm = valid && _termsAccepted);
  }

  Future<bool> _emailExists(String email) async {
    final res = await http.get(CreateAccountPage.usersUrl);

    if (res.statusCode != 200) return false;

    final data = jsonDecode(res.body);
    if (data == null) return false;

    return data.values.any((user) => user["email"] == email);
  }

  /// ===========================================================
  /// 2️⃣ Criar usuário (FirebaseAuth) + salvar no RealtimeDatabase
  /// ===========================================================
  Future<void> _createAccount() async {
    try {
      setState(() => _isLoading = true);

      final email = _email.text.trim();
      final password = _password.text.trim();
      final name = _nameController.text.trim();

      // Verificar duplicação de email no database
      final exists = await _emailExists(email);
      if (exists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Este email já está cadastrado.')),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Criar usuário no FirebaseAuth
      final authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = authResult.user!.uid;

      // Monta os dados do usuário (inclui photoUrl vazio)
      final Map<String, dynamic> userPayload = {
        "uid": uid,
        "name": name,
        "email": email,
        "createdAt": DateTime.now().toIso8601String(),
        "photoUrl": ""
      };

      // Salvar usando PUT em /users/{uid}.json
      final Uri saveUrl = Uri.https(
        "connect-8d1ed-default-rtdb.firebaseio.com",
        "/users/$uid.json",
      );

      final http.Response saveRes = await http.put(
        saveUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userPayload),
      );

      if (saveRes.statusCode < 200 || saveRes.statusCode >= 300) {
        // Caso algo dê errado no DB, desfaz o cadastro no Auth (opcional)
        try {
          await authResult.user?.delete();
        } catch (_) {}
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Erro ao salvar dados do usuário (código: ${saveRes.statusCode}).')),
        );
        setState(() => _isLoading = false);
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta criada com sucesso!')),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String msg = "Erro ao criar conta";

      if (e.code == "email-already-in-use") {
        msg = "Email já cadastrado no FirebaseAuth.";
      } else if (e.code == "invalid-email") {
        msg = "Email inválido.";
      } else if (e.code == "weak-password") {
        msg = "Senha muito fraca.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro inesperado: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_termsAccepted) return;
      _createAccount();
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              onChanged: _validateForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  const SizedBox(height: 10),
                  const Text(
                    'Criar Conta',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'Nome Completo',
                    controller: _nameController,
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Informe seu nome completo'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Email',
                    controller: _email,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe seu email';
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(v)) return 'Email inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Criar Senha',
                    controller: _password,
                    isPassword: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Crie uma senha';
                      if (v.length < 6) return 'Mínimo 6 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Confirmar Senha',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Confirme a senha';
                      if (v != _password.text) return 'Senhas não coincidem';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (v) {
                          setState(() => _termsAccepted = v ?? false);
                          _validateForm();
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Li e aceito os termos de uso e a política de privacidade',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isValidForm && !_isLoading ? _submit : null,
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
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Cadastro',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
