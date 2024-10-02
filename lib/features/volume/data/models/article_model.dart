import 'package:journal_web/features/volume/data/models/comment_model.dart';
import 'package:journal_web/features/volume/domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  ArticleModel({
    super.id,
    super.abstractString,
    super.authors,
    super.documentType,
    super.image,
    super.issueId,
    super.volumeId,
    super.createdAt,
    super.updatedAt,
    super.keywords,
    super.mainSubjects,
    super.pdf,
    super.references,
    super.title,
    super.comments,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      volumeId: json['volumeId'],
      issueId: json['issueId'],
      comments: json['comments'] != null
          ? List.from(json['comments'])
              .map((item) => CommentModel.fromJson(item))
              .toList()
          : [],
      id: json['id'],
      abstractString: json['abstractString'],
      authors: json['authors'] != null
          ? List.from(json['authors']).map((item) => item.toString()).toList()
          : [],
      documentType: json['documentType'],
      image: json['image'],
      keywords: json['keywords'] != null
          ? List.from(json['keywords']).map((item) => item.toString()).toList()
          : [],
      mainSubjects: json['mainSubjects'] != null
          ? List.from(json['mainSubjects'])
              .map((item) => item.toString())
              .toList()
          : [],
      pdf: json['pdf'],
      references: json['references'] != null
          ? List.from(json['references'])
              .map((item) => item.toString())
              .toList()
          : [],
      title: json['title'],
      createdAt: DateTime.tryParse(json['createdAt'].toString()),
      updatedAt: DateTime.tryParse(json['updatedAt'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'volumeId': volumeId,
      'issueId': issueId,
      'comments': comments?.map((item) => item.toJson()),
      'abstractString': abstractString,
      'authors': (authors)?.map((item) => item.toString()),
      'documentType': documentType,
      'image': image,
      'keywords': keywords,
      'mainSubjects': mainSubjects?.map((item) => item.toString()),
      'pdf': pdf,
      'references': references?.map((item) => item.toString()),
      'title': title,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ArticleModel copyWith({
    String? id,
    String? abstractString,
    String? volumeId,
    String? issueId,
    List<String>? authors,
    String? documentType,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CommentModel>? comments,
    List<String>? keywords,
    List<String>? mainSubjects,
    String? pdf,
    List<String>? references,
    String? title,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      abstractString: abstractString ?? this.abstractString,
      authors: authors ?? this.authors,
      volumeId: volumeId ?? this.volumeId,
      issueId: issueId ?? this.issueId,
      documentType: documentType ?? this.documentType,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      comments: comments ?? this.comments,
      keywords: keywords ?? this.keywords,
      mainSubjects: mainSubjects ?? this.mainSubjects,
      pdf: pdf ?? this.pdf,
      references: references ?? this.references,
      title: title ?? this.title,
    );
  }
}
