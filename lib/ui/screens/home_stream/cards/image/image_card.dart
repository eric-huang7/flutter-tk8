import 'package:flutter/material.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import 'image_card.viewmodel.dart';

class HomeStreamImageCard extends StatelessWidget {
  final HomeStreamImageCardViewModel viewModel;

  const HomeStreamImageCard({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NetworkImageView(imageUrl: viewModel.homeStreamImage.imageUrl);
  }
}
