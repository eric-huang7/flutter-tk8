import 'package:flutter/material.dart';
import 'package:tk8/data/util/more_loader.dart';

import 'adaptive_progress_indicator.dart';

class CommonOverviewScreen<T> extends StatelessWidget {
  final String title;
  final MoreLoader<T> loader;
  final Widget Function(T) builder;
  final void Function(T) onOpen;

  const CommonOverviewScreen({
    Key key,
    @required this.title,
    @required this.loader,
    @required this.builder,
    @required this.onOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(title),
        ),
        body: CustomScrollView(
          slivers: [
            if (loader.isLoading)
              const SliverFillRemaining(
                child: Center(child: AdaptiveProgressIndicator()),
              ),
            if (loader.items.isNotEmpty)
              SliverPadding(
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final item = loader.items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                            onTap: () => onOpen(item), child: builder(item)),
                      );
                    },
                    childCount: loader.items.length,
                  ),
                ),
                padding: const EdgeInsets.only(top: 16),
              ),
          ],
        ));
  }
}
