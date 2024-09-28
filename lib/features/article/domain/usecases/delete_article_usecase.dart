import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/article/domain/repositories/article_repo.dart';

class DeleteArticleUsecase extends UseCase<void, String> {
  final ArticleRepo articleRepo;

  DeleteArticleUsecase(this.articleRepo);
  @override
  Future<void> call(String params) async {
    return (await articleRepo.deleteArticle(params));
  }
}
