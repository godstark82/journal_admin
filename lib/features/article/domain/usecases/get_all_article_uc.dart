import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/domain/repositories/article_repo.dart';

class GetAllArticleUC extends UseCase<DataState<List<ArticleModel>>, void> {
  final ArticleRepository articleRepository;

  GetAllArticleUC(this.articleRepository);

  @override
  Future<DataState<List<ArticleModel>>> call(void params) async {
    return await articleRepository.getAllArticles();
  }
}
