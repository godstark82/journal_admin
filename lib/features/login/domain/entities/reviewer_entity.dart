
import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';

class ReviewerEntity extends MyUser {
  String? title;

  List<String>? journalIds;
  String? country;
  String? mobile;
  String? correspondingAddress;
  String? cvPdfUrl;
  String? researchDomain;


  ReviewerEntity({
    this.title,
    this.journalIds,
    this.country,
    this.mobile,
    this.correspondingAddress,
    this.cvPdfUrl,
    this.researchDomain,
    super.email,
    super.password,
    super.role,
    super.name,
    super.id,
  });
}
