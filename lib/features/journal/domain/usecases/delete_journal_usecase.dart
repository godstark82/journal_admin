import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/journal/domain/repositories/journal_repo.dart';

class DeleteJournalUsecase extends UseCase<void, String> {
  final JournalRepo _journalRepo;

  DeleteJournalUsecase(this._journalRepo);

  @override
  Future<void> call(String params) async {
    return _journalRepo.deleteJournal(params);
  }
}
