import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/ui/screens/academy/widgets/academy_chapter_card.viewmodel.dart';
import 'package:tk8/ui/widgets/network_image_view.dart';
import 'package:tk8/ui/widgets/space.dart';

const _cardSublineTextStyle = TextStyle(
    color: TK8Colors.superDarkBlue,
    fontWeight: FontWeight.normal,
    fontFamily: "Gotham",
    fontStyle: FontStyle.normal,
    fontSize: 14);

const _cardTitleTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontFamily: "RevxNeue",
    fontStyle: FontStyle.normal,
    fontSize: 21.0);

class AcademyChapterCard extends StatelessWidget {
  final ChapterCategoryItem chapterItem;

  const AcademyChapterCard({Key key, @required this.chapterItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AcademyChapterCardViewModel(chapterItem),
      child: _AcademyChapterCardView(),
    );
  }
}

class _AcademyChapterCardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AcademyChapterCardViewModel>(builder: (context, vm, child) {
      return SizedBox(
        height: 165,
        child: Stack(
          children: [
            NetworkImageView(imageUrl: vm.chapterItem.previewImageUrl),
            PositionedDirectional(
              start: 21,
              top: 32,
              end: MediaQuery.of(context).size.width / 3,
              child: Column(
                children: [
                  Text(
                    vm.chapterItem.title,
                    style: _cardTitleTextStyle,
                    maxLines: 2,
                  ),
                  const Space.vertical(8),
                  Row(
                    children: [
                      Text(
                        _getVideosCountText(vm.numberOfVideos),
                        style: _cardSublineTextStyle,
                      ),
                      const Space.horizontal(10),
                      Text(
                        _getNumberOfMinutesText(vm.numberOfMinutes),
                        style: _cardSublineTextStyle,
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  String _getVideosCountText(int numberOfVideos) {
    return translate('screens.academy.chapters.videos',
        args: {"value": numberOfVideos});
  }

  String _getNumberOfMinutesText(int numberOfMinutes) {
    return translate('screens.academy.chapters.minutes',
        args: {"value": numberOfMinutes});
  }
}
