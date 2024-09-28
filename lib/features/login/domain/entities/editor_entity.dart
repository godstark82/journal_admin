import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';

class EditorEntity extends MyUser {
  String? title;
  String? journalName;
  String? country;
  String? mobile;
  String? correspondingAddress;
  String? detailsCV;
  String? researchDomain;

  EditorEntity({
    this.correspondingAddress,
    this.country,
    this.detailsCV,
     super.email,
     super.password,
    this.journalName,
    this.mobile,
     super.role,
     super.name,
     super.id,
    this.researchDomain,
    this.title,
  });
}
