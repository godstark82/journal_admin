import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';

class AuthorEntity extends MyUser {
  String? title;
  String? orcId;
  String? designation;
  String? specialization;
  String? fieldOfStudy;
  String? mobile;
  String? country;
  String? state;
  String? city;
  String? pinCode;
  String? address;

  AuthorEntity({
    this.title,
    super.role,
    super.email,
    super.password,
    super.name,
    super.id,
    this.address,
    this.orcId,
    this.designation,
    this.specialization,
    this.fieldOfStudy,
    this.mobile,
    this.country,
    this.state,
    this.city,
    this.pinCode,
  });
}
