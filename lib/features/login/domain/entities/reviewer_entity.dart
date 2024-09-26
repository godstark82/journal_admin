import 'package:journal_web/features/login/domain/entities/journal_user_entity.dart';

class ReviewerEntity extends JournalUserEntity {
  String? title;
  String? firstName;
  String? lastName;
  String? email;
  String? journal;
  String? username;
  String? password;
  String? country;
  String? mobile;
  String? correspondingAddress;
  String? detailsCV;
  String? researchDomain;
  String? role;

  ReviewerEntity({
    this.title,
    this.role,
    this.firstName,
    this.lastName,
    this.email,
    this.journal,
    this.username,
    this.password,
    this.country,
    this.mobile,
    this.correspondingAddress,
    this.detailsCV,
    this.researchDomain,
  });
}
