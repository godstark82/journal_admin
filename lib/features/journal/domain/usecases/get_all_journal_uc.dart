import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:journal_web/features/journal/domain/repositories/journal_repo.dart';

class GetAllJournalUC extends UseCase<DataState<List<JournalModel>>, void> {
  final JournalRepo _journalRepo;

  GetAllJournalUC(this._journalRepo);

  @override
  Future<DataState<List<JournalModel>>> call(void params) async {
    return _journalRepo.getAllJournals();
  }
}
