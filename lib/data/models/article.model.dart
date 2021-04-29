import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:tk8/util/log.util.dart';

class Article extends Equatable {
  final String id;
  final String headline;
  final String subline;
  final String previewImageUrl;
  final String body;
  final DateTime publishedAt;
  final bool isRead;

  @visibleForTesting
  const Article(
      {@required this.id,
      @required this.headline,
      this.subline,
      @required this.previewImageUrl,
      @required this.body,
      @required this.publishedAt,
      this.isRead = false})
      : assert(id != null && id != ''),
        assert(headline != null && headline != ''),
        assert(previewImageUrl != null && previewImageUrl != ''),
        assert(body != null && body != ''),
        assert(publishedAt != null);

  @override
  List<Object> get props => [
        id,
        headline,
        previewImageUrl,
        subline,
        body,
        publishedAt,
        isRead,
      ];

  @override
  bool get stringify => true;

  factory Article.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    try {
      final currentUser = map['current_user'] ?? {};
      final isRead = currentUser['has_read'] ?? false;

      return Article(
          id: map['id'],
          headline: map['headline'],
          subline: map['subline'],
          previewImageUrl: map['preview_image_url'],
          isRead: isRead ?? false,
          body: map['body'],
          publishedAt: DateTime.tryParse(map['published_at']));
    } catch (e) {
      debugLogError('error parsing article element', e);
      return null;
    }
  }
}
