import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/pages/data/models/page_model.dart';
import 'package:journal_web/features/pages/domain/repositories/pages_repo.dart';

class EditPageUsecase extends UseCase<void, PageModel> {
  final PagesRepo pagesRepo;

  EditPageUsecase(this.pagesRepo);

  @override
  Future<void> call(PageModel params) async {
    return await pagesRepo.updatePage(params);
  }
}
