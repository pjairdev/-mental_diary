import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String assetName;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.assetName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(assetName),
        ),
      ),
    );
  }
}
