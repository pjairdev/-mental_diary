import 'package:flutter/material.dart';
import '../widgets/mood_chart.dart';
import '../widgets/thought_focus_card.dart';
import '../widgets/sleep_emotion_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '/core/constants/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                "Seus Insights",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              const Text("Padrões identificados de 1 a 30 Junho"),
              const SizedBox(height: 24),
              const MoodChartCard(),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(child: ThoughtFocusCard()),
                  SizedBox(width: 12),
                  Expanded(child: SleepEmotionCard()),
                ],
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Use a seção "Exercícios" para ajustar seus hábitos.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
