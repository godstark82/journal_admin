import 'package:journal_web/features/article/data/models/comment_model.dart';
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
    super.comments,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      comments: json['comments'] != null
          ? List.from(json['comments'])
              .map((item) => CommentModel.fromJson(item))
              .toList()
          : [],
      id: json['id'],
      abstractString: json['abstractString'],
      authors:
          List.from(json['authors']).map((item) => item.toString()).toList(),
      documentType: json['documentType'],
      image: json['image'],
      keywords:
          List.from(json['keywords']).map((item) => item.toString()).toList(),
      mainSubjects: List.from(json['mainSubjects'])
          .map((item) => item.toString())
          .toList(),
      pdf: json['pdf'],
      references:
          List.from(json['references']).map((item) => item.toString()).toList(),
      title: json['title'],
      createdAt: DateTime.tryParse(json['createdAt'].toString()),
      updatedAt: DateTime.tryParse(json['updatedAt'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
}
