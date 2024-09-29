import 'package:journal_web/features/article/data/models/comment_model.dart';

abstract class ArticleEntity {
  String? id;
  String? title;
  String? documentType;
  List<String>? authors;
  String? pdf;
  String? abstractString;
  List<String>? keywords;
  List<String>? mainSubjects;
  List<String>? references;
  String? image;
  List<CommentModel>? comments;
  DateTime? createdAt;
  DateTime? updatedAt;

  ArticleEntity({
    this.id,
    this.abstractString,
    this.authors,
    this.documentType,
    this.image,
    this.keywords,
    this.mainSubjects,
    this.createdAt,
    this.updatedAt,
    this.comments,
    this.pdf,
    this.references,
    this.title,
  });
}
