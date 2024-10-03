import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/pages/data/models/page_model.dart';
import 'package:journal_web/features/pages/domain/repositories/pages_repo.dart';
import 'package:journal_web/services/page_service.dart';

class PagesRepoImpl implements PagesRepo {
  final PageService pageService;

  PagesRepoImpl(this.pageService);

  @override
  Future<void> addPage(PageModel page) async {
    await pageService.addPage(page);
  }

  @override
  Future<void> deletePage(String id) async {
    await pageService.deletePage(id);
  }

  @override
  Future<DataState<List<PageModel>>> getPages() async {
    return await pageService.getPages();
  }

  @override
  Future<void> updatePage(PageModel page) async {
    await pageService.updatePage(page);
  }

  @override
  Future<DataState<PageModel>> getPage(String id) async {
    return await pageService.getPage(id);
  }
}
