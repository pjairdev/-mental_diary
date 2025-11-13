import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;
  bool _isValidForm = false;

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => _isValidForm = isValid && _termsAccepted);
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_termsAccepted) return;
      // TODO: Implementar lógica de criação de conta (Firebase, API etc)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );
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
                // 💡 ADICIONADO: Estique a Column verticalmente
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Ocupar a altura máxima do pai (o SafeArea)
                mainAxisSize: MainAxisSize.max,

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

                  // Campos de formulário
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
                    controller: _emailController,
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
                    controller: _passwordController,
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
                      if (v != _passwordController.text) {
                        return 'Senhas não coincidem';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Checkbox termos
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
                  const SizedBox(height: 24),

                  // Botão principal
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isValidForm ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8EC3A7),
                        disabledBackgroundColor: const Color(0xFFBFDACB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Começar Jornada',
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
