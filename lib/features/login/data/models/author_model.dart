import 'package:journal_web/features/login/domain/entities/author_entity.dart';

class AuthorModel extends AuthorEntity {
  AuthorModel({
    super.title,
    super.address,
    super.role,
    super.city,
    super.country,
    super.orcId,
    super.email,
    super.name,
    super.id,
    super.password,
    super.designation,
    super.specialization,
    super.fieldOfStudy,
    super.mobile,
    super.state,
    super.pinCode,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      title: json['title'],
      city: json['city'],
      role: json['role'],
      country: json['country'],
      name: json['name'],
      id: json['id'],
      email: json['email'],
      password: json['password'],
      orcId: json['orcId'],
      designation: json['designation'],
      specialization: json['specialization'],
      fieldOfStudy: json['fieldOfStudy'],
      mobile: json['mobile'],
      state: json['state'],
      pinCode: json['pinCode'],
      address: json['address'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'city': city,
      'country': country,
      
      'role': role,
      'orcId': orcId,
      'password': password,
      'designation': designation,
      'specialization': specialization,
      'fieldOfStudy': fieldOfStudy,
      'mobile': mobile,
      'state': state,
      'pinCode': pinCode,
      'address': address,
      'name': name,
      'id': id,
      'email': email,
    };
  }
}
