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
    this.pdf,
    this.references,
    this.title,
  });
}
