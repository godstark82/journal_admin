import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';

class AdminEnitiy extends MyUser {
  AdminEnitiy({
     super.email,
     super.password,
     super.role,
     super.name,
     super.id,
  });
}
