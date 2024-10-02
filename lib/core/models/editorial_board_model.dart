
class EditorialBoardModel {
  final String id;
  final String name;
  final String email;
  final String category;
  final String createdAt;

  EditorialBoardModel({
    required this.id,
    required this.name,
    required this.email,
    required this.category,
    required this.createdAt,
  });

  factory EditorialBoardModel.fromJson(Map<String, dynamic> json) {
    return EditorialBoardModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      category: json['category'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'category': category,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'EditorialBoardModel(id: $id, name: $name, email: $email, category: $category, createdAt: $createdAt)';
  }

  EditorialBoardModel copyWith({
    String? id,
    String? name,
    String? email,
    String? category,
    String? createdAt,
  }) {
    return EditorialBoardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
