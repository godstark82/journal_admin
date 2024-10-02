import 'package:journal_web/features/volume/data/models/article_model.dart';
import 'package:journal_web/features/volume/domain/entities/issue_entity.dart';

class IssueModel extends IssueEntity {
  IssueModel({
    super.id,
    super.title,
    super.fromDate,
    super.isActive,
    super.toDate,
    super.issueNumber,
    super.volumeId,
    super.description,
    List<ArticleModel>? super.articles,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'] ?? 'No id',
      isActive: json['isActive'] ?? false,
      title: json['title'] ?? 'No title',
      fromDate: DateTime.tryParse(json['fromDate'].toString()),
      toDate: DateTime.tryParse(json['toDate'].toString()),
      issueNumber: json['issueNumber'] ?? 'No issue number',
      volumeId: json['volumeId'] ?? 'No volume id',
      description: json['description'] ?? 'No description',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issueNumber': issueNumber,
      'volumeId': volumeId,
      'description': description,
      'isActive': isActive,
      'title': title,
      'fromDate': fromDate?.toIso8601String(),
      'toDate': toDate?.toIso8601String(),
    };
  }
}
