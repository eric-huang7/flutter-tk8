import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/ui/screens/academy/widgets/academy_chapter_card.dart';
import 'package:tk8/ui/screens/academy/widgets/academy_section_row.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import 'academy.viewmodel.dart';
import 'widgets/academy_category_tile.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AcademyViewModel>(
      create: (_) => AcademyViewModel(),
      builder: (context, child) {
        return _AcademyScreenView();
      },
    );
  }
}

class _AcademyScreenView extends StatelessWidget {
  Widget _buildContent(BuildContext context, AcademyViewModel model) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Space.vertical(10),
          ),
          _buildGreeting(model),
          if (model.isLoading)
            const SliverFillRemaining(
              child: Center(child: AdaptiveProgressIndicator()),
            ),
          if (model.chapters.isNotEmpty) ..._buildChaptersSection(model),
          if (model.categories.isNotEmpty)
            _buildCategoriesList(model.categories),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(List<AcademyCategory> categories) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AcademyCategoryTile(category: category),
          );
        },
        childCount: categories.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AcademyViewModel>(
      builder: (context, model, child) {
        return _buildContent(context, model);
      },
    );
  }

  List<Widget> _buildChaptersSection(AcademyViewModel model) {
    return [
      SliverToBoxAdapter(
        child: AcademySectionRow(
            title: translate('screens.academy.chapters.allChapters'),
            onShowAll: () => model.openChapterOverview(model.chapterCategory)),
      ),
      _buildChaptersList(model),
    ];
  }

  Widget _buildChaptersList(AcademyViewModel model) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final chapter = model.chapters[index];
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 5),
            child: InkWell(
                onTap: () {
                  model.openChapter(chapter);
                },
                child: AcademyChapterCard(
                  chapterItem: chapter,
                )),
          );
        },
        childCount: model.chapters.length,
      ),
    );
  }

  Widget _buildGreeting(AcademyViewModel model) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getGreeting(model).toUpperCase(),
                style: const TextStyle(
                    color: TK8Colors.superDarkBlue,
                    fontWeight: FontWeight.w600,
                    fontFamily: "RevxNeue",
                    fontStyle: FontStyle.normal,
                    fontSize: 24.0)),
            Text(_getSubline(),
                style: const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Gotham",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0)),
          ],
        ),
      ),
    );
  }

  String _getGreeting(AcademyViewModel model) {
    return translate('screens.academy.greeting',
        args: {"name": model.userName});
  }

  String _getSubline() {
    return translate('screens.academy.subline');
  }
}
