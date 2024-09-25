import 'package:journal_web/features/login/domain/entities/reviewer_entity.dart';

class ReviewerModel extends ReviewerEntity {
  ReviewerModel(
      {required super.title,
      required super.firstName,
      required super.lastName,
      required super.email,
      required super.journal,
      required super.username,
      required super.password,
      required super.country,
      required super.mobile,
      required super.correspondingAddress,
      required super.detailsCV,
      required super.researchDomain});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'journal': journal,
      'username': username,
      'password': password,
      'country': country,
      'mobile': mobile,
      'correspondingAddress': correspondingAddress,
      'detailsCV': detailsCV,
      'researchDomain': researchDomain
    };
  }

  factory ReviewerModel.fromJson(Map<String, dynamic> json) {
    return ReviewerModel(
        title: json['title'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        journal: json['journal'],
        username: json['username'],
        password: json['password'],
        country: json['country'],
        mobile: json['mobile'],
        correspondingAddress: json['correspondingAddress'],
        detailsCV: json['detailsCV'],
        researchDomain: json['researchDomain']);
  }
}
