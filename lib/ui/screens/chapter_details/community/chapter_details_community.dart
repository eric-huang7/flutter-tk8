import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/data/models/user_video.model.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import '../chapter_details.viewmodel.dart';
import 'community_my_video_card.dart';

class ChapterDetailsCommunity extends StatelessWidget {
  final _navigator = getIt<NavigationService>();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ChapterDetailsViewModel>(context);
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const Space.vertical(10),
                Text(
                  translate('screens.chapterDetails.community.myVideo.header'),
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontFamily: "RevxNeue",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0),
                ),
                const Space.vertical(10),
                if (model.userVideo == null)
                  _buildUploadUserVideo(context)
                else
                  CommunityUserVideoCard(),
                const Space.vertical(10),
              ],
            ),
          ),
        ),
        ..._buildCommunityVideos(context),
        SliverToBoxAdapter(
          child: SafeArea(
            top: false,
            child: model.isLoadingCommunityVideos
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: AdaptiveProgressIndicator(),
                    ),
                  )
                : const SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadUserVideo(BuildContext context) {
    final model = Provider.of<ChapterDetailsViewModel>(context);
    if (model.isUploadingVideo) {
      return const SizedBox(
        height: 171,
        child: Center(
          child: AdaptiveProgressIndicator(),
        ),
      );
    }
    return GestureDetector(
      onTap: model.selectAndUploadVideo,
      child: Container(
        height: 171,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2))),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: SvgPicture.asset('assets/svg/backgroundVideoUpload.svg',
                  fit: BoxFit.cover),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_rounded,
                  size: 54,
                  color: Colors.white,
                ),
                const Space.vertical(16),
                Text(
                  translate(
                      'screens.chapterDetails.community.myVideo.uploadButton.title'),
                  style: const TextStyle(
                      color: TK8Colors.superLightGrey,
                      fontWeight: FontWeight.bold,
                      fontFamily: "RevxNeue",
                      fontStyle: FontStyle.normal,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCommunityVideos(BuildContext context) {
    final model = Provider.of<ChapterDetailsViewModel>(context);
    if (!(model.isLoadingCommunityVideos || model.communityVideos.isNotEmpty)) {
      return [
        SliverToBoxAdapter(
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              width: 230,
              child: Text(
                translate(
                    'screens.chapterDetails.community.videosList.noVideosYet'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Gotham",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
              ),
            ),
          ),
        )
      ];
    }

    return [
      if (model.communityVideos.isNotEmpty)
        SliverPadding(
          padding: const EdgeInsets.all(15),
          sliver: SliverToBoxAdapter(
            child: Text(
              translate('screens.chapterDetails.community.videosList.title'),
              style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontFamily: "RevxNeue",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
            ),
          ),
        ),
      SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            model.checkNeedsLoadMoreCommunityVideosForIndex(index);
            final video = model.communityVideos[index];
            return GestureDetector(
              onTap: () {
                _navigator.openChapterCommunityVideoStreamScreen(model, index);
              },
              child: _CommunityVideoGridTile(video: video),
            );
          },
          childCount: model.communityVideos.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
      ),
    ];
  }
}

class _CommunityVideoGridTile extends StatelessWidget {
  final UserVideo video;

  const _CommunityVideoGridTile({Key key, @required this.video})
      : assert(video != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x260c2246),
            blurRadius: 15,
          )
        ],
      ),
      child: Stack(
        children: [
          _buildImage(),
          _buildGradientOverlay(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (video.previewImageUrl == null) {
      return const SizedBox();
    }
    return NetworkImageView(imageUrl: video.previewImageUrl);
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            Colors.transparent,
            Color(0x55000000),
          ],
        ),
      ),
    );
  }
}
