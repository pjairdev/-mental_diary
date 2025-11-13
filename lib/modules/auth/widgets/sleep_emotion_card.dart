import 'package:flutter/material.dart';
import '/core/constants/app_colors.dart';

class SleepEmotionCard extends StatelessWidget {
  const SleepEmotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Padrão de sono e emoção",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            '*Alerta: Em dias com menos de 6h de sono, chance de registrar "tristeza" aumenta em 25%.',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
