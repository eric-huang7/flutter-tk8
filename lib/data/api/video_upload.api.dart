import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tk8/util/image.util.dart';
import 'package:tk8/util/log.util.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'base.api.dart';

// TODO: Turn into a separate class, not extension on API
extension VideoUploadApi on Api {
  Future<void> uploadVideo(File file,
      {String chapterId, String exerciseId}) async {
    final filename = _fileNameFromPath(file.path);
    final uploadInfo = await _createNewPresignedUploadUrl(chapterId, filename);

    final videoBytes = await file.readAsBytes();
    final response =
        await http.put(Uri.parse(uploadInfo.uploadUrl), body: videoBytes);
    if (response.statusCode >= 300) {
      debugLogError('failed to upload video: ${response.statusCode}');
    }
    debugLog('$filename uploaded to $uploadInfo.uploadUrl');

    await _postNewVideoMetaData(
        chapterId, exerciseId, uploadInfo.filename, file);
  }

  Future<_VideoUploadInfo> _createNewPresignedUploadUrl(
      String chapterId, String filename) async {
    final body = {
      'upload_url': {
        'filename': filename,
      }
    };
    final result = await post(
      path: 'chapters/$chapterId/user_videos/upload_urls',
      body: body,
    );
    return _VideoUploadInfo.fromMap(result['data']);
  }

  Future<Uint8List> _getVideoThumbnail(File videoFile) async {
    return VideoThumbnail.thumbnailData(
      video: videoFile.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 256,
      quality: 25,
      timeMs: 250,
    );
  }

  Future<void> _postNewVideoMetaData(
    String chapterId,
    String exerciseId,
    String filename,
    File videoFile,
  ) async {
    final previewBytes = await _getVideoThumbnail(videoFile);

    final controller = VideoPlayerController.file(videoFile);
    await controller.initialize();

    var body = <String, dynamic>{};
    if (exerciseId != null) {
      body = {
        'user_video': {
          'filename': filename,
          'runtime_seconds': controller.value.duration.inSeconds,
          'preview_image': base64FromBytes(previewBytes, 'jpeg'),
          'exercise_id': exerciseId
        },
      };
    } else {
      body = {
        'user_video': {
          'filename': filename,
          'runtime_seconds': controller.value.duration.inSeconds,
          'preview_image': base64FromBytes(previewBytes, 'jpeg'),
        },
      };
    }

    await post(path: 'chapters/$chapterId/user_videos', body: body);
  }

  // there's a known issue on android where videos filepath have a jpg extension
  // https://github.com/flutter/flutter/issues/52419
  String _fileNameFromPath(String filePath) {
    final uri = Uri.parse(filePath);
    final filename = uri.pathSegments.last;
    if (Platform.isIOS) {
      return filename;
    }
    return '$filename.mp4';
  }
}

class _VideoUploadInfo extends Equatable {
  final String uploadUrl;
  final String filename;

  const _VideoUploadInfo({
    @required this.uploadUrl,
    @required this.filename,
  })  : assert(uploadUrl != null),
        assert(filename != null);

  factory _VideoUploadInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return _VideoUploadInfo(
      uploadUrl: map['upload_url'],
      filename: map['filename'],
    );
  }

  @override
  List<Object> get props => [uploadUrl, filename];

  @override
  bool get stringify => true;
}
