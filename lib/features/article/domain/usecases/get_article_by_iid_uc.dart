import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/domain/repositories/article_repo.dart';

class GetArticleByIssueIdUC
    extends UseCase<DataState<List<ArticleModel>>, String> {
  final ArticleRepository articleRepository;

  GetArticleByIssueIdUC(this.articleRepository);

  @override
  Future<DataState<List<ArticleModel>>> call(String params) async {
    return await articleRepository.getArticleByIssueId(params);
  }
}
