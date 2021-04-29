import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:tk8/util/log.util.dart';

class Image extends Equatable {
  final String previewUrl;
  final String fullUrl;

  @visibleForTesting
  const Image({
    this.previewUrl,
    this.fullUrl,
  }) : assert(
          previewUrl != null || fullUrl != null,
          'At least one of previewUrl or fullUrl has to be set',
        );

  factory Image.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    try {
      return Image(
        previewUrl: map['preview_image_url'],
        fullUrl: map['full_image_url'],
      );
    } catch (e) {
      debugLogError('failed to parse image object', e);
      return null;
    }
  }

  @override
  List<Object> get props => [previewUrl, fullUrl];

  @override
  bool get stringify => true;
}
