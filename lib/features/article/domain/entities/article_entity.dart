import 'package:journal_web/features/article/data/models/comment_model.dart';

abstract class ArticleEntity {
  final String id;
  final String title;
  final String issueId;
  final String volumeId;
  final String documentType;
  final String status;
  final List<String> authors;
  final String pdf;
  final String abstractString;
  final List<String> keywords;
  final List<String> mainSubjects;
  final List<String> references;
  final String image;
  final List<CommentModel> comments;
  final DateTime createdAt;
  final DateTime updatedAt;

  ArticleEntity({
    required this.id,
    required this.status,
    required this.abstractString,
    required this.authors,
    required this.issueId,
    required this.volumeId,
    required this.documentType,
    required this.image,
    required this.keywords,
    required this.mainSubjects,
    required this.createdAt,
    required this.updatedAt,
    required this.comments,
    required this.pdf,
    required this.references,
    required this.title,
  });
}
