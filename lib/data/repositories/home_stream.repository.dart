import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/home_stream.model.dart';
import 'package:tk8/services/services.dart';

class HomeStreamRepository {
  final _api = getIt<Api>();

  ///
  Future<PaginatedListResponse<HomeStream>> loadHomeStream({
    String nextCursor,
  }) async {
    return _api.getPaginatedList(
      path: 'home_stream',
      beforeCursor: nextCursor,
      itemParser: (item) => HomeStream.fromMap(item),
    );
  }
}
