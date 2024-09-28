
import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';

class ReviewerEntity extends MyUser {
  String? title;

  String? journal;

  String? country;
  String? mobile;
  String? correspondingAddress;
  String? detailsCV;
  String? researchDomain;


  ReviewerEntity({
    this.title,
    this.journal,
    this.country,
    this.mobile,
    this.correspondingAddress,
    this.detailsCV,
    this.researchDomain,
    super.email,
    super.password,
    super.role,
    super.name,
    super.id,
  });
}
