import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/domain/repositories/article_repo.dart';

class GetArticleByIdUC extends UseCase<DataState<ArticleModel>, String> {
  final ArticleRepository articleRepository;

  GetArticleByIdUC(this.articleRepository);

  @override
  Future<DataState<ArticleModel>> call(String params) async {
    return await articleRepository.getArticleById(params);
  }
}
