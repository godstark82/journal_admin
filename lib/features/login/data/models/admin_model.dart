import 'package:journal_web/features/login/domain/entities/admin_enitiy.dart';

class AdminModel extends AdminEnitiy {
  AdminModel({
    super.email,
    super.password,
    super.role,
    super.name,
    super.id,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      email: json['email'],
      password: json['password'],
      role: json['role'],
      name: json['name'],
      id: json['id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
      'name': name,
      'id': id,
    };
  }
}
