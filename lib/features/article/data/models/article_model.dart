import 'package:journal_web/features/article/data/models/comment_model.dart';
import 'package:journal_web/features/article/domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  ArticleModel(
      {required super.id,
      required super.abstractString,
      required super.authors,
      required super.issueId,
      required super.volumeId,
      required super.documentType,
      required super.image,
      required super.keywords,
      required super.mainSubjects,
      required super.createdAt,
      required super.updatedAt,
      required super.comments,
      required super.pdf,
      required super.references,
      required super.status,
      required super.title});

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      abstractString: json['abstractString'],
      authors: json['authors'],
      issueId: json['issueId'],
      volumeId: json['volumeId'],
      documentType: json['documentType'],
      image: json['image'],
      keywords: json['keywords'],
      mainSubjects: json['mainSubjects'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      comments: List<CommentModel>.from(
          (json['comments'] as List).map((e) => CommentModel.fromJson(e))),
      pdf: json['pdf'],
      references: json['references'],
      title: json['title'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'abstractString': abstractString,
      'authors': authors,
      'issueId': issueId,
      'volumeId': volumeId,
      'documentType': documentType,
      'image': image,
      'keywords': keywords,
      'mainSubjects': mainSubjects,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'comments': comments.map((e) => e.toJson()).toList(),
      'pdf': pdf,
      'references': references,
      'title': title,
      'status': status,
    };
  }

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      id: entity.id,
      abstractString: entity.abstractString,
      authors: entity.authors,
      issueId: entity.issueId,
      volumeId: entity.volumeId,
      documentType: entity.documentType,
      image: entity.image,
      keywords: entity.keywords,
      mainSubjects: entity.mainSubjects,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      comments: entity.comments,
      pdf: entity.pdf,
      references: entity.references,
      title: entity.title,
      status: entity.status,
    );
  }

  //copy with
  ArticleModel copyWith({
    String? id,
    String? abstractString,
    List<String>? authors,
    String? issueId,
    String? volumeId,
    String? documentType,
    String? image,
    List<String>? keywords,
    List<String>? mainSubjects,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CommentModel>? comments,
    String? pdf,
    List<String>? references,
    String? title,
    String? status,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      abstractString: abstractString ?? this.abstractString,
      authors: authors ?? this.authors,
      issueId: issueId ?? this.issueId,
      volumeId: volumeId ?? this.volumeId,
      documentType: documentType ?? this.documentType,
      image: image ?? this.image,
      keywords: keywords ?? this.keywords,
      mainSubjects: mainSubjects ?? this.mainSubjects,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      comments: comments ?? this.comments,
      pdf: pdf ?? this.pdf,
      references: references ?? this.references,
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }
}

enum ArticleStatus {
  pending('Pending'),
  accepted('Accepted'),
  rejected('Rejected');

  final String value;
  const ArticleStatus(this.value);
}
