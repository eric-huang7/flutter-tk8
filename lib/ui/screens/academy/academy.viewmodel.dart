import 'package:flutter/material.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/services/services.dart';

class AcademyViewModel extends ChangeNotifier {
  final _userRepo = getIt<UserRepository>();
  final _navigator = getIt<NavigationService>();
  List<AcademyCategory> _categories = [];
  List<ChapterCategoryItem> _chapters = [];
  AcademyCategory chapterCategory;
  bool _isLoading = false;

  List<AcademyCategory> get categories => _categories;

  List<ChapterCategoryItem> get chapters => _chapters;

  bool get isLoading => _isLoading;

  AcademyViewModel() {
    _loadCategories();
  }

  String get userName => _userRepo.myProfileUser?.username;

  Future<void> _loadCategories() async {
    if (_categories.isEmpty) {
      _isLoading = true;
      notifyListeners();
    }
    try {
      final categories = await getIt<Api>().getAcademyCategories();

      _categories = categories
          .where((element) => element.type != AcademyCategoryType.chapter)
          .toList();

      chapterCategory = categories
          .where((element) => element.type == AcademyCategoryType.chapter)
          .first;
      _chapters =
          chapterCategory.items.whereType<ChapterCategoryItem>().toList();
    } on Exception {
      getIt<NavigationService>().showGenericErrorAlertDialog(
        onRetry: _loadCategories,
        showDefaultAction: false,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void openChapter(ChapterCategoryItem chapter) {
    _navigator.openChapterDetailsScreen(chapter.chapter);
  }

  void openChapterOverview(AcademyCategory category) {
    _navigator.openChapterOverview(category);
  }
}
