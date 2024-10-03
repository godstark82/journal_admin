import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/pages/data/models/page_model.dart';
import 'package:journal_web/features/pages/domain/repositories/pages_repo.dart';

class GetPagesUsecase extends UseCase<DataState<List<PageModel>>, void> {
  final PagesRepo pagesRepo;

  GetPagesUsecase(this.pagesRepo);

  @override
  Future<DataState<List<PageModel>>> call(void params) async {
    return await pagesRepo.getPages();
  }
}
