import 'dart:ui';

class ExerciseModel {
  final String title;
  final String subtitle;
  final String type;
  final Color backgroundColor;

  ExerciseModel({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.backgroundColor,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      title: json["title"],
      subtitle: json["subtitle"],
      type: json["type"],
      backgroundColor: Color(int.parse("0xFF${json["color"]}")),
    );
  }
}
