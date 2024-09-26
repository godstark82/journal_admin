import 'package:journal_web/features/login/domain/entities/journal_user_entity.dart';

class EditorEntity extends JournalUserEntity {
  String? title;
  String? fullName;
  String? journalName;
  String? email;
  String? username;
  String? password;
  String? country;
  String? mobile;
  String? correspondingAddress;
  String? detailsCV;
  String? researchDomain;
  String? role;

  EditorEntity(
      {this.correspondingAddress,
      this.country,
      this.detailsCV,
      this.email,
      this.role,
      this.fullName,
      this.journalName,
      this.mobile,
      this.password,
      this.researchDomain,
      this.title,
      this.username});
}
