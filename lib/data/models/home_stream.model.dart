import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:tk8/data/models/video.model.dart';
import 'package:tk8/util/log.util.dart';

abstract class HomeStream {
  static HomeStream fromMap(Map<String, dynamic> map) {
    final type = map['type'];
    switch (type) {
      case HomeStreamImage.type:
        return HomeStreamImage.fromMap(map['attributes']);
      case HomeStreamVideo.type:
        return HomeStreamVideo.fromMap(map['attributes']);
    }
    return null;
  }
}

class HomeStreamImage extends Equatable implements HomeStream {
  static const type = 'image';

  final String id;
  final String previewImageUrl;
  final String imageUrl;

  const HomeStreamImage._({
    @required this.id,
    @required this.previewImageUrl,
    @required this.imageUrl,
  })  : assert(id != null && id != ''),
        assert(previewImageUrl != null && previewImageUrl != ''),
        assert(imageUrl != null && imageUrl != '');

  factory HomeStreamImage.fromMap(Map<String, dynamic> map) {
    try {
      return HomeStreamImage._(
        id: map['id'],
        previewImageUrl: map['preview_image_url'],
        imageUrl: map['image_url'],
      );
    } catch (e) {
      debugLogError('error parsing home stream image element', e);
      return null;
    }
  }

  @override
  String toString() =>
      'HomeStreamImage(id: $id, previewImageUrl: $previewImageUrl, imageUrl: $imageUrl)';

  @override
  List<Object> get props => [id, previewImageUrl, imageUrl];

  @override
  bool get stringify => true;
}

class HomeStreamVideo extends Equatable implements HomeStream {
  static const type = 'video';

  final Video video;

  const HomeStreamVideo._({
    @required this.video,
  }) : assert(video != null);

  factory HomeStreamVideo.fromMap(Map<String, dynamic> map) {
    try {
      return HomeStreamVideo._(
        video: Video.fromMap(map),
      );
    } catch (e) {
      debugLogError('error parsing home stream video element', e);
      return null;
    }
  }

  @override
  List<Object> get props => [video];

  @override
  bool get stringify => true;
}
