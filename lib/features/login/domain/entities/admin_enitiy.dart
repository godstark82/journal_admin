import 'package:journal_web/features/login/domain/entities/journal_user_entity.dart';

class AdminEnitiy extends JournalUserEntity {
  String? mail;
  String? pass;

  AdminEnitiy({this.mail, this.pass});
}
