import 'package:tk8/data/models/home_stream.model.dart';

import '../card_base.viewmodel.dart';

///
class HomeStreamImageCardViewModel extends HomeStreamCardViewModelBase {
  final HomeStreamImage homeStreamImage;

  @override
  HomeStreamCardType get type => HomeStreamCardType.image;

  HomeStreamImageCardViewModel(this.homeStreamImage);
}
