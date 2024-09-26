import 'package:journal_web/features/login/domain/entities/journal_user_entity.dart';

class AuthorEntity extends JournalUserEntity {
  String? title;
  String? firstName;
  String? middle;
  String? lastName;
  String? mail;
  String? orcId;
  String? username;
  String? password;
  String? designation;
  String? specialization;
  String? fieldOfStudy;
  String? phone;
  String? mobile;
  String? country;
  String? state;
  String? city;
  String? pinCode;
  String? address;
  String? role;

  AuthorEntity({
    this.title,
    this.role,
    this.address,
    this.firstName,
    this.middle,
    this.lastName,
    this.mail,
    this.orcId,
    this.username,
    this.password,
    this.designation,
    this.specialization,
    this.fieldOfStudy,
    this.phone,
    this.mobile,
    this.country,
    this.state,
    this.city,
    this.pinCode,
  });
}
