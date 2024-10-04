import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/domain/repositories/article_repo.dart';

class AddArticleUC extends UseCase<void, ArticleModel> {
  final ArticleRepository articleRepository;

  AddArticleUC(this.articleRepository);

  @override
  Future<void> call(ArticleModel params) async {
    await articleRepository.addArticle(params);
  }
}
