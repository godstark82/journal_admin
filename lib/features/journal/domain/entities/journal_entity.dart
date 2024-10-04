import 'package:equatable/equatable.dart';

class JournalEntity extends Equatable {
  final String id;
  final String title;
  final String domain;
  final DateTime createdAt;

  const JournalEntity(
      {required this.id,
      required this.title,
      required this.domain,
      required this.createdAt});

  @override
  List<Object?> get props => [id, title, domain, createdAt];
}
