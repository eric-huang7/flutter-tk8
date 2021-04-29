import 'package:equatable/equatable.dart';

class ApiCredentials extends Equatable {
  final String id;
  final String secret;

  const ApiCredentials(this.id, this.secret);

  @override
  List<Object> get props => [id, secret];

  @override
  bool get stringify => true;
}
