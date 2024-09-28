class ArticleAuthor {
  String? title;
  String? name;
  String? designation;

  ArticleAuthor({this.designation, this.name});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'designation': designation,
    };
  }

  factory ArticleAuthor.fromJson(Map<String, dynamic> map) {
    return ArticleAuthor(
      name: map['name'] != null ? map['name'] as String : null,
      designation:
          map['designation'] != null ? map['designation'] as String : null,
    );
  }
}
