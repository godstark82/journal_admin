import 'package:equatable/equatable.dart';
import 'package:journal_web/features/volume/domain/entities/issue_entity.dart';

class VolumeEntity extends Equatable {
  String? id;
  String? title;
  String? volumeNumber;
  String? description;
  bool? isActive;
  DateTime? createdAt;
  List<IssueEntity>? issues;

  VolumeEntity({
    this.id,
    this.volumeNumber,
    this.title,
    this.description,
    this.isActive,
    this.createdAt,
    this.issues,
  });

  @override
  List<Object?> get props => [id, title, createdAt, issues];
}
