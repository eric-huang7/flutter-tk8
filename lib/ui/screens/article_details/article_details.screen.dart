import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/data/models/article.model.dart';

import 'widgets/article_space_bar.dart';

const _lineHeight = 23.0 / 15.0;

class ArticleDetailsScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailsScreen({Key key, @required this.article})
      : assert(article != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ArticleDetailsState();
  }
}

class _ArticleDetailsState extends State<ArticleDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          body: _buildBody(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return _buildHeaderSliver(innerBoxIsScrolled);
          },
        ),
      ),
    );
  }

  List<Widget> _buildHeaderSliver(bool innerBoxIsScrolled) {
    return [
      SliverAppBar(
        expandedHeight: 220,
        pinned: true,
        brightness: Brightness.dark,
        // TODO: the FlexibleSpaceBar does not support everything from the design, so this is a bit of whacked and hacky for now.
        // we need to implement an own solution to support the collapsed background image, and additional buttons
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: ArticleSpaceBar(
            title: widget.article.headline,
            imageUrl: widget.article.previewImageUrl),
      )
    ];
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_getPublishedDate().toUpperCase(),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Gotham",
                      fontStyle: FontStyle.normal,
                      height: _lineHeight,
                      fontSize: 15.0,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(widget.article.subline,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontFamily: "Gotham",
                          fontStyle: FontStyle.normal,
                          height: _lineHeight,
                          fontSize: 15.0)),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
              child: Html(style: {
                "body": Style(
                  margin: EdgeInsets.zero,
                ),
                "p, li": Style(
                    fontSize: FontSize.large,
                    color: Colors.black,
                    fontFamily: "Gotham",
                    fontStyle: FontStyle.normal,
                    lineHeight: const LineHeight(_lineHeight)),
                "h2": Style(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: "RevxNeue",
                    fontStyle: FontStyle.normal,
                    fontSize: FontSize.xxLarge,
                    lineHeight: const LineHeight(_lineHeight)),
                "h3": Style(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: "RevxNeue",
                    fontStyle: FontStyle.normal,
                    fontSize: FontSize.xLarge,
                    lineHeight: const LineHeight(_lineHeight)),
                "h4": Style(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: "RevxNeue",
                    fontStyle: FontStyle.normal,
                    fontSize: FontSize.large,
                    lineHeight: const LineHeight(_lineHeight)),
                "img": Style(alignment: Alignment.center)
              }, data: widget.article.body.replaceAll("http://", "https://"))),
        ),
        SliverSafeArea(
          top: false,
          // Add minimum for Android devices
          minimum: const EdgeInsets.only(bottom: 20),
          sliver: SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add sharing function, but for that we need deep linking first.
                },
                // Could not find the icon from the design
                icon: const Icon(Icons.share),
                style: ElevatedButton.styleFrom(primary: TK8Colors.ocean),
                label: Text(translate('screens.articleDetails.buttons.share')),
              ),
            ),
          )),
        )
      ],
    );
  }

  String _getPublishedDate() {
    return DateFormat.yMMMMd().format(widget.article.publishedAt);
  }
}
