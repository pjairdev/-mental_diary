import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // Define a cor do texto/ícone (foreground color)
          foregroundColor: const Color.fromARGB(255, 255, 244, 244),

          // Mantém a cor de fundo (background color) se você quiser especificar uma:
          // backgroundColor: Colors.blue,
        ),
        child: Text(label),
      ),
    );
  }
}
