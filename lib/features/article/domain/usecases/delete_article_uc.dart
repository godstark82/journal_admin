import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/domain/repositories/article_repo.dart';

class DeleteArticleUC extends UseCase<void, String> {
  final ArticleRepository articleRepository;

  DeleteArticleUC(this.articleRepository);

  @override
  Future<void> call(String params) async {
    await articleRepository.deleteArticle(params);
  }
}
