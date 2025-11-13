import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/core/constants/app_colors.dart';

class MoodChartCard extends StatelessWidget {
  const MoodChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Variação de Humor na Semana",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: const [
                      FlSpot(0, 2),
                      FlSpot(1, 2.1),
                      FlSpot(2, 2.5),
                      FlSpot(3, 2.3),
                      FlSpot(4, 2.8),
                      FlSpot(5, 3),
                      FlSpot(6, 2.9),
                    ],
                    color: Colors.white,
                    dotData: const FlDotData(show: true),
                    barWidth: 2,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Aos domingos, seu humor é em média, 15% mais feliz.",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
