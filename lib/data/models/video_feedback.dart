import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class VideoFeedback extends Equatable {
  final String text;

  const VideoFeedback({
    @required this.text,
  }) : assert(text != null);

  factory VideoFeedback.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return VideoFeedback(text: map['text']);
  }

  @override
  List<Object> get props => [text];

  @override
  bool get stringify => true;
}
