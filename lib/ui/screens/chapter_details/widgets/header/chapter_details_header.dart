import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../chapter_details.viewmodel.dart';
import 'chapter_details_header.view.dart';
import 'chapter_details_header.viewmodel.dart';

export 'chapter_details_header.view.dart' show chapterDetailsAppBarHeight;

class ChapterDetailsHeader extends StatelessWidget {
  const ChapterDetailsHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChapterDetailsViewModel>(
      builder: (context, parentModel, child) {
        return ChangeNotifierProvider(
          create: (_) => ChapterDetailsHeaderViewModel(
            parentModel: parentModel,
          ),
          child: ChapterDetailsHeaderView(),
        );
      },
    );
  }
}
