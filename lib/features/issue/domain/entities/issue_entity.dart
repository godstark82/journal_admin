import 'package:equatable/equatable.dart';

class IssueEntity extends Equatable {
  final String id;
  final String title;
  final String issueNumber;
  final String volumeId;
  final String journalId;
  final String description;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isActive;

  const IssueEntity({
    required this.id,
    required this.title,
    required this.fromDate,
    required this.issueNumber,
    required this.isActive,
    required this.volumeId,
    required this.description,
    required this.toDate,
    required this.journalId,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        fromDate,
        toDate,
        journalId,
        issueNumber,
        volumeId,
        description,
        isActive
      ];
}
