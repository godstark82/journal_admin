import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';

class AuthorEntity extends MyUser {
  String? title;
  String? orcId;
  String? specialization;
  String? fieldOfStudy;
  String? mobile;
  String? address;
  String? cvPdfUrl;
  List<String>? journalIds;

  AuthorEntity({
    this.title,
    super.role,
    super.email,
    super.password,
    super.name,
    super.id,
    this.address,
    this.orcId,
    super.designation,
    this.specialization,
    this.fieldOfStudy,
    this.mobile,
    this.cvPdfUrl,
    this.journalIds,
  });
}
