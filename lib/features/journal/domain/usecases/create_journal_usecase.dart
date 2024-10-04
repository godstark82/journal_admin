import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:journal_web/features/journal/domain/repositories/journal_repo.dart';

class CreateJournalUsecase extends UseCase<void, JournalModel> {
  final JournalRepo _journalRepo;

  CreateJournalUsecase(this._journalRepo);

  @override
  Future<void> call(JournalModel params) async {
    return _journalRepo.createJournal(params);
  }
}
