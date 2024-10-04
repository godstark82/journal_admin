import 'package:equatable/equatable.dart';

abstract class VolumeEntity extends Equatable {
  final String id;
  final String journalId;
  final String title;
  final String volumeNumber;
  final String description;
  final bool isActive;
  final DateTime createdAt;

  const VolumeEntity({
    required this.id,
    required this.volumeNumber,
    required this.title,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.journalId,
  });

  @override
  List<Object?> get props =>
      [id, title, createdAt, journalId, volumeNumber, description, isActive];
}
