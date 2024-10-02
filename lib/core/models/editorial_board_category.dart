class EditorialBoardCategory {
  final String title;
  final String createdAt;

  const EditorialBoardCategory({required this.createdAt, required this.title});

  factory EditorialBoardCategory.fromJson(Map<String, dynamic> json) {
    return EditorialBoardCategory(
      title: json['title'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'EditorialBoardCategory(title: $title, createdAt: $createdAt)';
  }

  EditorialBoardCategory copyWith({
    String? title,
    String? createdAt,
  }) {
    return EditorialBoardCategory(
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
