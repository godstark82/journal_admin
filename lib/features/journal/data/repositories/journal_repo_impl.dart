import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:journal_web/features/journal/domain/repositories/journal_repo.dart';
import 'package:journal_web/services/journal_services.dart';

class JournalRepoImpl implements JournalRepo {
  final JournalServices _journalServices;

  JournalRepoImpl(this._journalServices);

  @override
  Future<void> createJournal(JournalModel journal) {
    return _journalServices.addJournal(journal);
  }

  @override
  Future<void> deleteJournal(String id) {
    return _journalServices.deleteJournal(id);
  }

  @override
  Future<DataState<List<JournalModel>>> getAllJournals() {
    return _journalServices.getAllJournals();
  }

  @override
  Future<DataState<JournalModel>> getJournalById(String id) {
    return _journalServices.getJournalById(id);
  }

  @override
  Future<void> updateJournal(JournalModel journal) {
    return _journalServices.updateJournal(journal);
  }
}
