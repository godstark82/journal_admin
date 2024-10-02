import 'package:journal_web/features/volume/domain/entities/volume_entity.dart';
import 'package:journal_web/features/volume/data/models/issue_model.dart';

class VolumeModel extends VolumeEntity {
  VolumeModel({
    super.description,
    super.isActive,
    super.id,
    super.volumeNumber,
    super.title,
    super.createdAt,
    List<IssueModel>? super.issues,
  });

  factory VolumeModel.fromJson(Map<String, dynamic> json) {
    return VolumeModel(
      id: json['id'],
      volumeNumber: json['volumeNumber'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      description: json['description'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'volumeNumber': volumeNumber,
      'createdAt': createdAt?.toIso8601String(),
      'description': description,
      'isActive': isActive,
    };
  }
}
