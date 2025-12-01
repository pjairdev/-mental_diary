import 'package:flutter/material.dart';
import 'package:teste_flutter/terms/terms_text.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Termos de Uso"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            termsOfUse,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
