import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/ui/screens/academy/widgets/academy_chapter_card.dart';
import 'package:tk8/ui/screens/chapters_overview/chapters_overview.viewmodel.dart';
import 'package:tk8/ui/widgets/common_overview_screen.dart';

class ChaptersOverviewScreen extends StatelessWidget {
  final AcademyCategory category;

  const ChaptersOverviewScreen({Key key, @required this.category})
      : assert(category != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ChaptersOverviewViewModel(category),
        child: const _ChaptersOverviewView());
  }
}

class _ChaptersOverviewView extends StatelessWidget {
  const _ChaptersOverviewView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChaptersOverviewViewModel>(
      builder: (context, vm, child) {
        return CommonOverviewScreen<ChapterCategoryItem>(
          title: vm.title,
          loader: vm,
          builder: (item) => AcademyChapterCard(chapterItem: item),
          onOpen: (item) => vm.openChapter(item),
        );
      },
    );
  }
}
