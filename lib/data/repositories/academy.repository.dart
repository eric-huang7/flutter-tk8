import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/user_video.model.dart';
import 'package:tk8/services/services.dart';

// TODO: Split into different repositories
class AcademyRepository {
  final _api = getIt<Api>();

  Future<Chapter> getChapterDetails(String chapterId) async {
    final response = await _api.get(path: 'chapters/$chapterId');
    final chapter = Chapter.fromMap(response['data']);
    getIt<VideosRepository>().updateStreamWithVideos(chapter.videos);
    return chapter;
  }

  Future<PaginatedListResponse<UserVideo>> getChapterCommunityVideos(
    String chapterId, {
    String nextCursor,
  }) async {
    return _api.getPaginatedList(
      path: 'chapters/$chapterId/user_videos',
      beforeCursor: nextCursor,
      itemParser: (item) => UserVideo.fromMap(item),
    );
  }
}
