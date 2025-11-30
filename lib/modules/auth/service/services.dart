import 'dart:convert';
import 'package:flutter/services.dart';
import '../exercise_model.dart';

class ExerciseService {
  Future<List<ExerciseModel>> fetchExercises() async {
    //Substituir com a lógica do firebase
    final response = await rootBundle.loadString("assets/json/exercises.json");

    final List data = jsonDecode(response);
    return data.map((e) => ExerciseModel.fromJson(e)).toList();
  }
}
