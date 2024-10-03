import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/pages/domain/repositories/pages_repo.dart';

class DeletePageUsecase extends UseCase<void, String> {
  final PagesRepo pagesRepo;

  DeletePageUsecase(this.pagesRepo);

  @override
  Future<void> call(String params) async {
    return await pagesRepo.deletePage(params);
  }
}
