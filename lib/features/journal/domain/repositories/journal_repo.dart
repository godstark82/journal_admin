import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';

abstract class JournalRepo {
  Future<DataState<List<JournalModel>>> getAllJournals();
  Future<DataState<JournalModel>> getJournalById(String id);
  Future<void> createJournal(JournalModel journal);
  Future<void> updateJournal(JournalModel journal);
  Future<void> deleteJournal(String id);
}
