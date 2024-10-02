import 'package:equatable/equatable.dart';
import 'package:journal_web/features/volume/domain/entities/article_entity.dart';

class IssueEntity extends Equatable {
  String? id;
  String? title;
  String? issueNumber;
  String? volumeId;
  String? description;
  DateTime? fromDate;
  DateTime? toDate;
  bool? isActive;
  List<ArticleEntity>? articles;

  IssueEntity({
    this.id,
    this.title,
    this.fromDate,
    this.issueNumber,
    this.isActive,
    this.volumeId,
    this.description,
    this.toDate,
    this.articles,
  });

  @override
  List<Object?> get props => [id, title, fromDate, toDate, articles, issueNumber, volumeId, description, isActive];
}
