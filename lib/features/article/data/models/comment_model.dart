class CommentModel {
  String? name;
  String? content;

  CommentModel({this.name, this.content});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      name: json['name'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'content': content,
    };
  }
}