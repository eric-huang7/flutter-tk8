import 'package:flutter/widgets.dart';
import 'package:tk8/data/api/base.api.dart';

abstract class MoreLoader<T> {
  List<T> _items = [];
  bool _isLoading = false;
  bool _canLoadMore = false;
  bool _hasError = false;
  String _nextCursor;

  List<T> get items => _items;
  bool get isLoading => _isLoading;
  bool get canLoadMore => _canLoadMore;
  bool get hasError => _hasError;
  String get nextCursor => _nextCursor;

  void onError(Error e);
  void notifyListeners();
  Future<PaginatedListResponse<T>> loadMoreItems();

  void addItems(Iterable<T> newItems, String nextCursor) {
    _items = [..._items, ...newItems];
    _nextCursor = nextCursor;
    _canLoadMore = newItems.isNotEmpty;
  }

  void loadMore() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      try {
        final response = await loadMoreItems();
        final newItems = response.list;
        addItems(newItems, response.nextCursor);
      } catch (e) {
        _hasError = true;
        onError(e);
      }

      _isLoading = false;
      notifyListeners();
    });
  }
}