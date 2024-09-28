import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/domain/repositories/article_repo.dart';

class AddArticleUsecase extends UseCase<DataState<ArticleModel>, ArticleModel> {
  final ArticleRepo articleRepo;

  AddArticleUsecase(this.articleRepo);
  @override
  Future<DataState<ArticleModel>> call(ArticleModel params) async {
    return (await articleRepo.addArticle(params));
  }
}
