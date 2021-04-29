import 'package:tk8/data/models/home_stream.model.dart';
import 'package:tk8/services/services.dart';

import 'base.api.dart';

extension HomeStreamApi on Api {
  Future<PaginatedListResponse<HomeStream>> getHomeStream({
    String nextCursor,
  }) async {
    final result = await getPaginatedList(
      path: 'home_stream',
      beforeCursor: nextCursor,
      itemParser: (item) => HomeStream.fromMap(item),
    );
    getIt<VideosRepository>().updateStreamWithVideos(
        result.list.whereType<HomeStreamVideo>().map((e) => e.video).toList());
    return result;
  }
}
