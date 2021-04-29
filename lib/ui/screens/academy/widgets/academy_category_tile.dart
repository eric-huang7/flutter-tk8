import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/ui/widgets/common_list_item.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import 'academy_category_tile.viewmodel.dart';
import 'academy_section_row.dart';

const _padding = 15.0;

class AcademyCategoryTile extends StatelessWidget {
  final AcademyCategory category;

  const AcademyCategoryTile({
    Key key,
    @required this.category,
  })  : assert(category != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AcademyCategoryTileViewModel(category),
      builder: (context, child) => _AcademyCategoryTileView(),
    );
  }
}

class _AcademyCategoryTileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AcademyCategoryTileViewModel>(
      builder: (context, model, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AcademySectionRow(
                title: model.title, onShowAll: model.openOverview),
            SizedBox(
              height: 232,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: _padding / 2),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (index == model.items.length) {
                    if (model.canLoadMore) {
                      if (!model.isLoading && !model.hasError) model.loadMore();
                      return _buildLoadingMore();
                    }
                    return const Space.horizontal(15);
                  }
                  final item = model.items[index];
                  return buildItemTile(model, item, index);
                },
                itemCount: model.items.length + 1,
              ),
            )
          ],
        );
      },
    );
  }

  Padding buildItemTile(
      AcademyCategoryTileViewModel model, AcademyCategoryItem item, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: _padding / 2),
      child: GestureDetector(
        onTap: () => model.openItem(item, index),
        child: CommonListItem(
          title: item.title,
          previewImageUrl: item.previewImageUrl,
          overlayIcon: item is VideoCategoryItem ? Icons.play_circle_fill : null,
        ),
      ),
    );
  }

  Widget _buildLoadingMore() {
    return const Padding(
      padding: EdgeInsets.all(25.0),
      child: Center(child: AdaptiveProgressIndicator()),
    );
  }
}
