import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:journal_web/features/journal/domain/repositories/journal_repo.dart';

class GetJournalUc extends UseCase<DataState<JournalModel>, String> {
  final JournalRepo _journalRepo;

  GetJournalUc(this._journalRepo);

  @override
  Future<DataState<JournalModel>> call(String params) async {
    return _journalRepo.getJournalById(params);
  }
}
