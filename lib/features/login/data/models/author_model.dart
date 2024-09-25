import 'package:journal_web/features/login/domain/entities/author_entity.dart';

class AuthorModel extends AuthorEntity {
  AuthorModel({
    required super.title,
    required super.city,
    required super.country,
    required super.firstName,
    required super.lastName,
    required super.mail,
    required super.orcId,
    required super.username,
    required super.password,
    required super.designation,
    required super.specialization,
    required super.fieldOfStudy,
    required super.mobile,
    required super.state,
    required super.pinCode,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      title: json['title'],
      city: json['city'],
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
