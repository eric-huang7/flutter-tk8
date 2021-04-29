import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import 'package:tk8/config/styles.config.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import 'academy/chapter_details_academy.dart';
import 'chapter_details.viewmodel.dart';
import 'community/chapter_details_community.dart';
import 'widgets/header/chapter_details_header.dart';

const _chapterDetailsTabbarHeight = 46.0;

class ChapterDetailsScreen extends StatelessWidget {
  final Chapter chapter;

  const ChapterDetailsScreen({
    Key key,
    @required this.chapter,
  })  : assert(chapter != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChapterDetailsViewModel(chapter),
      child: const _ChapterDetailsView(),
    );
  }
}

class _ChapterDetailsView extends StatelessWidget {
  const _ChapterDetailsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChapterDetailsViewModel>(
      builder: (context, model, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [_buildAppBar(model)];
              },
              body: TabBarView(
                children: [
                  CustomScrollView(
                    slivers: [
                      ChapterDetailsAcademy(),
                    ],
                  ),
                  ChapterDetailsCommunity(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  SliverAppBar _buildAppBar(ChapterDetailsViewModel model) {
    return SliverAppBar(
      expandedHeight: chapterDetailsAppBarHeight,
      floating: true,
      pinned: true,
      stretch: true,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Column(
          children: [
            const Expanded(
              child: ChapterDetailsHeader(),
            ),
            Container(
              height: _chapterDetailsTabbarHeight,
              color: Colors.white,
            ),
          ],
        ),
      ),
      bottom: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const LabelTagBackgroundDecoration(
          color: TK8Colors.ocean,
          insets: EdgeInsets.fromLTRB(0.0, 44.0, 0.0, 0.0),
        ),
        labelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: "RevxNeue",
            fontStyle: FontStyle.normal,
            fontSize: 16.0),
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(text: translate('screens.chapterDetails.academy.tab.title')),
          Tab(text: translate('screens.chapterDetails.community.tab.title')),
        ],
      ),
    );
  }
}
