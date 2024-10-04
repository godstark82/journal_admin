import 'package:journal_web/features/issue/domain/entities/issue_entity.dart';

class IssueModel extends IssueEntity {
  const IssueModel({
    required super.id,
    required super.title,
    required super.issueNumber,
    required super.volumeId,
    required super.journalId,
    required super.description,
    required super.fromDate,
    required super.toDate,
    required super.isActive,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'],
      title: json['title'],
      issueNumber: json['issueNumber'],
      volumeId: json['volumeId'],
      journalId: json['journalId'],
      description: json['description'],
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'issueNumber': issueNumber,
      'volumeId': volumeId,
      'journalId': journalId,
      'description': description,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  IssueModel copyWith({
    String? id,
    String? title,
    String? issueNumber,
    String? volumeId,
    String? journalId,
    String? description,
    DateTime? fromDate,
    DateTime? toDate,
    bool? isActive,
  }) {
    return IssueModel(
      id: id ?? this.id,
      title: title ?? this.title,
      issueNumber: issueNumber ?? this.issueNumber,
      volumeId: volumeId ?? this.volumeId,
      journalId: journalId ?? this.journalId,
      description: description ?? this.description,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      isActive: isActive ?? this.isActive,
    );
  }
}
