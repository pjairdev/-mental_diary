import '../modules/auth/exercise_model.dart';
import '../modules/auth/service/services.dart';

class ExerciseRepository {
  final ExerciseService service;

  ExerciseRepository(this.service);

  Future<List<ExerciseModel>> getExercises() async {
    return await service.fetchExercises();
  }
}
