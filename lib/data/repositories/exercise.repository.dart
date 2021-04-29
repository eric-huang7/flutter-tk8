import 'package:tk8/data/api/api.dart';
import 'package:tk8/services/services_injection.dart';

class ExerciseRepository {
  final _api = getIt<Api>();

  int _timeTrainedMinutes;

  int getTrainedTime() => _timeTrainedMinutes;

  Future<void> performTraining(String exerciseId, Duration timeTrained) async {
    _timeTrainedMinutes = timeTrained.inMinutes;
    final body = {'training_duration': timeTrained.inSeconds};
    await _api.put(path: 'exercises/$exerciseId', body: body);
  }
}
