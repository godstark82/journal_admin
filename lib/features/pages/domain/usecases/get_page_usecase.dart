import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/pages/data/models/page_model.dart';
import 'package:journal_web/features/pages/domain/repositories/pages_repo.dart';

class GetSinglePageUsecase extends UseCase<DataState<PageModel>, String> {
  final PagesRepo pagesRepo;

  GetSinglePageUsecase(this.pagesRepo);

  @override
  Future<DataState<PageModel>> call(String params) async {
    return await pagesRepo.getPage(params);
  }
}
