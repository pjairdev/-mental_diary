import 'package:flutter/material.dart';
import '/core/constants/app_colors.dart';

class ThoughtFocusCard extends StatelessWidget {
  const ThoughtFocusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBeige,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Foco dos pensamentos",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text('Sua palavra mais frequente neste mês foi "Metas"'),
        ],
      ),
    );
  }
}
