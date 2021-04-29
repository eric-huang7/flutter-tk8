import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/video.model.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/util/log.util.dart';

class VideosRepository {
  final _api = getIt<Api>();
  final Map<String, Video> _videos = {};
  final _videosController = BehaviorSubject<Map<String, Video>>.seeded({});

  Stream<Map<String, Video>> get videosStream => _videosController.stream;

  Stream<Video> getVideoStream(String videoId) =>
      _videosController.stream.map((videos) => videos[videoId]);

  Future<void> rateVideo({
    @required Video video,
    @required int rating,
  }) async {
    assert(video != null);
    assert(rating != null && rating >= 0 && rating <= 5);

    final Map<String, dynamic> body = {
      'video_rating': {
        'rating': rating,
      }
    };
    try {
      await _api.put(
        path: 'videos/${video.id}/rating',
        body: body,
      );
      updateStreamWithVideos([video.copyWith(userRating: rating)]);
    } catch (e) {
      debugLogError('failed to set video rating', e);
      rethrow;
    }
  }

  Future<void> setViewDuration({
    @required Video video,
    @required Duration duration,
  }) async {
    assert(video != null);

    try {
      final Map<String, dynamic> body = {
        'view_duration': {
          'seconds': duration.inSeconds,
        }
      };
      await _api.put(
        path: 'videos/${video.id}/view_duration',
        body: body,
      );
      updateStreamWithVideos([video.copyWith(viewDuration: duration)]);
    } catch (e) {
      debugLogError('failed to set video view duration', e);
      rethrow;
    }
  }

  Future<Video> favoriteVideo({@required Video video}) async {
    assert(video != null);

    final response = await _api.put(
      path: 'videos/${video.id}/favorite',
    );

    updateStreamWithVideos([Video.fromMap(response['data'])]);
    return video;
  }

  Future<Video> unfavoriteVideo({@required Video video}) async {
    assert(video != null);

    final response = await _api.delete(
      path: 'videos/${video.id}/favorite',
    );

    updateStreamWithVideos([Video.fromMap(response['data'])]);
    return video;
  }

  void updateStreamWithVideos(List<Video> videos) {
    for (final video in videos.where((element) => element != null)) {
      _videos[video.id] = video;
    }
    _videosController.add(_videos);
  }
}
