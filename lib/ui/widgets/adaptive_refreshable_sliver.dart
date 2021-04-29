import 'dart:io';

import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';

class AdaptiveRefreshableSliver extends StatelessWidget {
  final RefreshCallback onRefresh;
  final List<Widget> slivers;
  final ScrollController controller;

  const AdaptiveRefreshableSliver({
    Key key,
    this.onRefresh,
    this.slivers,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) return _buildContent(context);
    return CupertinoScrollbar(child: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    if (Platform.isIOS || onRefresh == null) return _buildList(context);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: <Widget>[
        if (Platform.isIOS && onRefresh != null)
          CupertinoSliverRefreshControl(
            onRefresh: onRefresh,
          ),
        ...slivers,
      ],
    );
  }
}
