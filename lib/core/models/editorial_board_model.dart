class EditorialBoardModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String institution;
  final String createdAt;

  EditorialBoardModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.institution,
    required this.createdAt,
  });

  factory EditorialBoardModel.fromJson(Map<String, dynamic> json) {
    return EditorialBoardModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      institution: json['institution'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'institution': institution,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'EditorialBoardModel(id: $id, name: $name, email: $email, role: $role, institution: $institution, createdAt: $createdAt)';
  }

  EditorialBoardModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? institution,
    String? createdAt,
  }) {
    return EditorialBoardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      institution: institution ?? this.institution,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
