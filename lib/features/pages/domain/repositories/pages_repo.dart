import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/pages/data/models/page_model.dart';

abstract class PagesRepo {
  Future<DataState<List<PageModel>>> getPagesByJournalId(String journalId);
  Future<DataState<PageModel>> getPage(String id);
  Future<void> addPage(PageModel page);
  Future<void> updatePage(PageModel page);
  Future<void> deletePage(String id);
}
