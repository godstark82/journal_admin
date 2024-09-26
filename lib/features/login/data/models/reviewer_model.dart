import 'package:journal_web/features/login/domain/entities/reviewer_entity.dart';

class ReviewerModel extends ReviewerEntity {
  ReviewerModel(
      {super.title,
      super.firstName,
      super.lastName,
      super.email,
      super.journal,
      super.role,
      super.username,
      super.password,
      super.country,
      super.mobile,
      super.correspondingAddress,
      super.detailsCV,
      super.researchDomain});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
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
        role: json['role'],
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
