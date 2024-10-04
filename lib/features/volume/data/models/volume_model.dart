import 'package:journal_web/features/volume/domain/entities/volume_entity.dart';

class VolumeModel extends VolumeEntity {
  const VolumeModel({
    required super.journalId,
    required super.description,
    required super.isActive,
    required super.id,
    required super.volumeNumber,
    required super.title,
    required super.createdAt,
  });

  factory VolumeModel.fromJson(Map<String, dynamic> json) {
    return VolumeModel(
      journalId: json['journalId'],
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
      'journalId': journalId,
      'title': title,
      'volumeNumber': volumeNumber,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'isActive': isActive,
    };
  }

  VolumeModel copyWith({
    String? journalId,
    String? description,
    bool? isActive,
    String? id,
    String? volumeNumber,
    String? title,
    DateTime? createdAt,
  }) {
    return VolumeModel(
      journalId: journalId ?? this.journalId,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      id: id ?? this.id,
      volumeNumber: volumeNumber ?? this.volumeNumber,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
