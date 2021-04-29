import 'package:tk8/data/models/video.model.dart';

const _countForNextRating = 5;

class VideosService {
  int _countSinceLastRating = 0;

  bool shouldShowRatingForVideo(Video video, {bool updateCounter = true}) {
    if (video.userRating != null) return false;

    if (_countSinceLastRating >= _countForNextRating) {
      _countSinceLastRating = 0;
      return true;
    }

    if (updateCounter) _countSinceLastRating++;

    return false;
  }

  String get chapterCompletedCongratulationsVideoUrl =>
      'https://tk8-staging.s3.eu-central-1.amazonaws.com/videos/toni_congrats.mp4';
}
