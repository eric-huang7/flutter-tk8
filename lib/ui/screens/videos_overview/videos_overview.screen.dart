import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/ui/screens/videos_overview/videos_overview.viewmodel.dart';
import 'package:tk8/ui/widgets/common_list_item.dart';
import 'package:tk8/ui/widgets/common_overview_screen.dart';

class VideosOverviewScreen extends StatelessWidget {
  final AcademyCategory category;

  const VideosOverviewScreen({Key key, @required this.category})
      : assert(category != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => VideosOverviewViewModel(category),
        child: const _VideosOverviewView());
  }
}

class _VideosOverviewView extends StatelessWidget {
  const _VideosOverviewView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<VideosOverviewViewModel>(
      builder: (context, vm, child) {
        return CommonOverviewScreen<VideoCategoryItem>(
          title: vm.title,
          loader: vm,
          builder: (item) => CommonListItem(
            title: item.title,
            previewImageUrl: item.previewImageUrl,
            overlayIcon: Icons.play_circle_fill,
            height: 240,
          ),
          onOpen: (item) => vm.openVideo(item),
        );
      },
    );
  }
}
