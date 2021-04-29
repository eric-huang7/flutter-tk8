///
enum HomeStreamCardType {
  image,
  video,
}

///
abstract class HomeStreamCardViewModelBase {
  HomeStreamCardType get type;

  void onWarmup() {}
  void onActivate() {}
  void onDeactivate() {}
}
