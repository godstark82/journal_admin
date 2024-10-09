import 'package:journal_web/features/users/domain/repositories/users_repo.dart';

class UpdateUserJournalsUC {
  final UsersRepo usersRepo;

  UpdateUserJournalsUC( this.usersRepo);

  Future<void> call(String userId, List<String> journalIds) async {
    return await usersRepo.updateUserJournals(userId, journalIds);
  }
}
