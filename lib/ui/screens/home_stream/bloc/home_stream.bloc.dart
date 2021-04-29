import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/home_stream.model.dart';
import 'package:tk8/services/services.dart';

import '../cards/card_base.viewmodel.dart';
import '../cards/image/image_card.viewmodel.dart';
import '../cards/video/video_card.viewmodel.dart';

///
class HomeStreamState extends Equatable {
  final bool isBusy;
  final List<HomeStreamCardViewModelBase> homeStreamItems;

  const HomeStreamState({
    this.isBusy,
    this.homeStreamItems,
  });

  const HomeStreamState.initial()
      : isBusy = false,
        homeStreamItems = const [];

  HomeStreamState copyWith({
    bool isBusy,
    List<HomeStreamCardViewModelBase> homeStreamItems,
  }) {
    return HomeStreamState(
      isBusy: isBusy ?? this.isBusy,
      homeStreamItems: homeStreamItems ?? this.homeStreamItems,
    );
  }

  @override
  List<Object> get props => [isBusy, homeStreamItems];
}

class HomeStreamBloc extends Cubit<HomeStreamState> {
  final _repository = getIt<HomeStreamRepository>();
  final _navigator = getIt<NavigationService>();
  StreamSubscription _appTabSubscription;
  PaginatedListResponse<HomeStream> _lastStreamResponse;
  int _currentPage = 0;

  HomeStreamBloc({HomeStreamState initialState})
      : super(initialState ?? const HomeStreamState.initial()) {
    _appTabSubscription = _navigator.appTabStream.listen((tab) {
      if (state.homeStreamItems.isEmpty) return;
      if (tab == AppTab.home) {
        state.homeStreamItems[_currentPage].onActivate();
      } else {
        state.homeStreamItems[_currentPage].onDeactivate();
      }
    });
    _lastStreamResponse = PaginatedListResponse<HomeStream>.initial();
    _loadHomeStreamItems();
  }

  void dispose() {
    _appTabSubscription.cancel();
  }

  void setCurrentPage(int page) {
    state.homeStreamItems[_currentPage].onDeactivate();
    state.homeStreamItems[page].onActivate();
    if (page < state.homeStreamItems.length - 1) {
      state.homeStreamItems[page + 1].onWarmup();
    }
    _currentPage = page;
  }

  Future<void> _loadHomeStreamItems() async {
    emit(state.copyWith(isBusy: true));

    _lastStreamResponse = await _repository.loadHomeStream(
        nextCursor: _lastStreamResponse.nextCursor);

    emit(state.copyWith(
      isBusy: false,
      homeStreamItems: [
        ...state.homeStreamItems,
        ..._lastStreamResponse.list.map((item) {
          if (item is HomeStreamImage) {
            return HomeStreamImageCardViewModel(item);
          } else {
            return HomeStreamVideoCardViewModel(item);
          }
        })
      ],
    ));
    setCurrentPage(0);
  }
}
