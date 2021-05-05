import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tk8/util/log.util.dart';

import 'image.model.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final DateTime birthdate;
  final Image profileImage;
  final Image backgroudImage;
  final bool activated;

  const User._({
    @required this.id,
    @required this.username,
    @required this.birthdate,
    this.email,
    this.profileImage,
    this.backgroudImage,
    this.activated = false,
  })  : assert(id != null),
        assert(username != null),
        assert(birthdate != null);

  factory User.fromMap(Map<String, dynamic> map) {
    try {
      return User._(
        id: map['id'],
        username: map['name'],
        email: map['email'],
        birthdate: DateTime.tryParse(map['birthdate']),
        profileImage: Image.fromMap(map['profile_image']),
        backgroudImage: Image.fromMap(map['profile_background_image']),
        activated: map['activated'],
      );
    } catch (e) {
      debugLogError('failed to parse user', e);
      return null;
    }
  }

  @override
  List<Object> get props => [
        id,
        username,
        birthdate,
        profileImage,
        backgroudImage,
        activated,
      ];

  @override
  bool get stringify => true;
}
