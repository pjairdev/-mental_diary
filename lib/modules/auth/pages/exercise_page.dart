import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/profile_button.dart';
import '/core/constants/app_colors.dart';

import '../exercise_model.dart';
import 'package:teste_flutter/repository/repository.dart';
import '../service/services.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  late final ExerciseRepository repository;

  @override
  void initState() {
    super.initState();
    repository = ExerciseRepository(ExerciseService());
  }

  IconData _getIcon(String type) {
    switch (type) {
      case "audio":
        return Icons.play_circle_fill_rounded;
      case "music":
        return Icons.headphones;
      case "exercise":
        return Icons.fitness_center;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: FutureBuilder<List<ExerciseModel>>(
          future: repository.getExercises(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final exercises = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // topo com título e foto de perfil
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          "Mente em Ação",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      ProfileButton(),
                    ],
                  ),

                  const SizedBox(height: 5),
                  const Center(
                    child: Text(
                      "Encontre atividades para o seu bem-estar.",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // lista de exercícios
                  ...exercises.map((exercise) {
                    return Column(
                      children: [
                        _ExerciseCard(
                          title: exercise.title,
                          subtitle: exercise.subtitle,
                          backgroundColor: exercise.backgroundColor,
                          icon: _getIcon(exercise.type),
                          iconColor: Colors.black,
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),

                  const SizedBox(height: 120),
                ],
              ),
            );
          },
        ),
      ),

      // item “Exercícios” aparece selecionado
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}

/// Widget auxiliar para um card de exercício
/// IMPORTANTE: este widget está em top-level (fora de qualquer outra classe)
class _ExerciseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _ExerciseCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),

          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: iconColor),
          ),
        ],
      ),
    );
  }
}
