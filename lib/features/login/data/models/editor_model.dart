import 'package:journal_web/features/login/domain/entities/editor_entity.dart';

class EditorModel extends EditorEntity {
  EditorModel(
      {super.correspondingAddress,
      super.country,
      super.detailsCV,
      super.email,
      super.role,
      super.fullName,
      super.journalName,
      super.mobile,
      super.password,
      super.researchDomain,
      super.title,
      super.username});

  factory EditorModel.fromJson(Map<String, dynamic> json) {
    return EditorModel(
      correspondingAddress: json['correspondingAddress'],
      country: json['country'],
      detailsCV: json['detailsCV'],
      email: json['email'],
      role: json['role'],
      fullName: json['fullName'],
      journalName: json['journalName'],
      mobile: json['mobile'],
      password: json['password'],
      researchDomain: json['researchDomain'],
      title: json['title'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'correspondingAddress': correspondingAddress,
      'country': country,
      'detailsCV': detailsCV,
      'email': email,
      'role': role,
      'fullName': fullName,
      'journalName': journalName,
      'mobile': mobile,
      'password': password,
      'researchDomain': researchDomain,
      'title': title,
      'username': username,
    };
  }
}
