import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/ui/screens/articles_overview/articles_overview.viewmodel.dart';
import 'package:tk8/ui/widgets/common_overview_screen.dart';

import 'widgets/articles_list_item.dart';

class ArticlesOverviewScreen extends StatelessWidget {
  final AcademyCategory category;

  const ArticlesOverviewScreen({Key key, @required this.category})
      : assert(category != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ArticlesOverviewViewModel(category),
        child: const _ArticlesOverviewView());
  }
}

class _ArticlesOverviewView extends StatelessWidget {
  const _ArticlesOverviewView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticlesOverviewViewModel>(
      builder: (context, vm, child) {
        return CommonOverviewScreen<ArticleCategoryItem>(
          title: vm.title,
          loader: vm,
          builder: (item) => ArticlesListItem(article: item.article),
          onOpen: (item) => vm.openArticle(item),
        );
      },
    );
  }
}
