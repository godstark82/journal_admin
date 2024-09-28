import 'package:journal_web/features/article/data/models/author_article_model.dart';
import 'package:journal_web/features/article/domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  ArticleModel({
    super.id,
    super.abstractString,
    super.authors,
    super.documentType,
    super.image,
    super.createdAt,
    super.updatedAt,
    super.keywords,
    super.mainSubjects,
    super.pdf,
    super.references,
    super.title,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      abstractString: json['abstractString'],
      authors: List.from(json['authors'])
          .map((item) => ArticleAuthor.fromJson(item))
          .toList(),
      documentType: json['documentType'],
      image: json['image'],
      keywords: json['keywords'],
      mainSubjects: List.from(json['mainSubjects'])
          .map((item) => item.toString())
          .toList(),
      pdf: json['pdf'],
      references:
          List.from(json['references']).map((item) => item.toString()).toList(),
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'abstractString': abstractString,
      'authors': (authors)?.map((item) => item.toJson()),
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
}
