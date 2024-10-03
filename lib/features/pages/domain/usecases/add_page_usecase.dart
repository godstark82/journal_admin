import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/pages/data/models/page_model.dart';
import 'package:journal_web/features/pages/domain/repositories/pages_repo.dart';

class AddPageUsecase extends UseCase<void, PageModel> {
  final PagesRepo repository;

  AddPageUsecase(this.repository);

  @override
  Future<void> call(PageModel params) async {
    return await repository.addPage(params);
  }
}
