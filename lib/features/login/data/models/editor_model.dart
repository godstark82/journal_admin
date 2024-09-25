import 'package:journal_web/features/login/domain/entities/editor_entity.dart';

class EditorModel extends EditorEntity {
  EditorModel(
      {required super.correspondingAddress,
      required super.country,
      required super.detailsCV,
      required super.email,
      required super.fullName,
      required super.journalName,
      required super.mobile,
      required super.password,
      required super.researchDomain,
      required super.title,
      required super.username});

  factory EditorModel.fromJson(Map<String, dynamic> json) {
    return EditorModel(
      correspondingAddress: json['correspondingAddress'],
      country: json['country'],
      detailsCV: json['detailsCV'],
      email: json['email'],
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
