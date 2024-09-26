import 'package:journal_web/features/login/domain/entities/author_entity.dart';

class AuthorModel extends AuthorEntity {
  AuthorModel({
    super.title,
    super.address,
    super.role,
    super.city,
    super.country,
    super.firstName,
    super.lastName,
    super.mail,
    super.orcId,
    super.username,
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
      firstName: json['firstName'],
      lastName: json['lastName'],
      mail: json['mail'],
      orcId: json['orcId'],
      username: json['username'],
      password: json['password'],
      designation: json['designation'],
      specialization: json['specialization'],
      fieldOfStudy: json['fieldOfStudy'],
      mobile: json['mobile'],
      state: json['state'],
      pinCode: json['pinCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'city': city,
      'country': country,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'mail': mail,
      'orcId': orcId,
      'username': username,
      'password': password,
      'designation': designation,
      'specialization': specialization,
      'fieldOfStudy': fieldOfStudy,
      'mobile': mobile,
      'state': state,
      'pinCode': pinCode,
    };
  }
}
