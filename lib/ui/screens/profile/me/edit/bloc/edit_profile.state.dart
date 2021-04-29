import 'dart:io';

import 'package:equatable/equatable.dart';

enum ProfileImageSourceType { web, file }

class ProfileImageData extends Equatable {
  final ProfileImageSourceType type;
  final String location;
  final File file;

  const ProfileImageData._({
    this.type,
    this.location,
    this.file,
  });

  factory ProfileImageData.web(String url) {
    try {
      return ProfileImageData._(
        type: ProfileImageSourceType.web,
        location: url,
      );
    } catch (_) {
      return null;
    }
  }

  factory ProfileImageData.file(File file) {
    try {
      return ProfileImageData._(
        type: ProfileImageSourceType.file,
        file: file,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object> get props => [type, location, file?.path];

  @override
  bool get stringify => true;
}

class ProfileDataField<T> extends Equatable {
  final T value;
  final String error;

  const ProfileDataField(this.value, {this.error});

  @override
  List<Object> get props => [value, error];

  @override
  bool get stringify => true;
}

class EditProfileState extends Equatable {
  final bool isBusy;
  final bool isProfileImageChanged;
  final bool isBackgroundImageChanged;
  final ProfileImageData profileImage;
  final ProfileImageData backgroundImage;
  final ProfileDataField<String> username;
  final ProfileDataField<String> birthdate;

  const EditProfileState({
    this.isBusy,
    this.isProfileImageChanged,
    this.isBackgroundImageChanged,
    this.profileImage,
    this.backgroundImage,
    this.username,
    this.birthdate,
  });

  const EditProfileState.initial()
      : isBusy = false,
        isProfileImageChanged = false,
        isBackgroundImageChanged = false,
        profileImage = null,
        backgroundImage = null,
        username = const ProfileDataField(''),
        birthdate = const ProfileDataField('');

  EditProfileState copyWith({
    bool isBusy,
    bool isProfileImageChanged,
    bool isBackgroundImageChanged,
    ProfileImageData profileImage,
    ProfileImageData backgroundImage,
    ProfileDataField<String> username,
    ProfileDataField<String> birthdate,
  }) {
    return EditProfileState(
      isBusy: isBusy ?? this.isBusy,
      isProfileImageChanged:
          isProfileImageChanged ?? this.isProfileImageChanged,
      isBackgroundImageChanged:
          isBackgroundImageChanged ?? this.isBackgroundImageChanged,
      profileImage: profileImage ?? this.profileImage,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      username: username ?? this.username,
      birthdate: birthdate ?? this.birthdate,
    );
  }

  @override
  List<Object> get props => [
        isBusy,
        isProfileImageChanged,
        isBackgroundImageChanged,
        profileImage,
        backgroundImage,
        username,
        birthdate,
      ];

  @override
  bool get stringify => true;
}
