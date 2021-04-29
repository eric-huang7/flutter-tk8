import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tk8/config/styles.config.dart';

enum MediaLibraryServiceError {
  userCanceled,
  accessDenied,
  other,
}

class MediaLibraryServiceException implements Exception {
  final MediaLibraryServiceError error;
  MediaLibraryServiceException(this.error);
}

class MediaLibraryService {
  final _picker = ImagePicker();

  Future<File> selectPhotoFromCamera() async {
    try {
      final picked = await _picker.getImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );
      if (picked == null) {
        throw MediaLibraryServiceException(
            MediaLibraryServiceError.userCanceled);
      }
      return File(picked.path);
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        throw MediaLibraryServiceException(
            MediaLibraryServiceError.accessDenied);
      } else {
        throw MediaLibraryServiceException(MediaLibraryServiceError.other);
      }
    }
  }

  Future<File> selectPhotoFromGallery() async {
    try {
      final picked = await _picker.getImage(source: ImageSource.gallery);
      if (picked == null) {
        throw MediaLibraryServiceException(
            MediaLibraryServiceError.userCanceled);
      }
      return File(picked.path);
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        throw MediaLibraryServiceException(
            MediaLibraryServiceError.accessDenied);
      } else {
        throw MediaLibraryServiceException(MediaLibraryServiceError.other);
      }
    }
  }

  Future<File> selectVideoFromGallery() async {
    try {
      final picked = await _picker.getVideo(source: ImageSource.gallery);
      if (picked == null) {
        throw MediaLibraryServiceException(
            MediaLibraryServiceError.userCanceled);
      }
      return File(picked.path);
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        throw MediaLibraryServiceException(
            MediaLibraryServiceError.accessDenied);
      } else {
        throw MediaLibraryServiceException(MediaLibraryServiceError.other);
      }
    }
  }

  Future<File> cropImageFile(
    String filePath,
    String title, {
    bool circularCrop = false,
  }) async {
    return ImageCropper.cropImage(
      sourcePath: filePath,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: title,
        toolbarColor: TK8Colors.ocean,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      iosUiSettings: IOSUiSettings(
        title: title,
        aspectRatioLockEnabled: true,
      ),
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: circularCrop ? CropStyle.circle : CropStyle.rectangle,
    );
  }
}
