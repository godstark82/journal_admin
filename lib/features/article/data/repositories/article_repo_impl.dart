import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/domain/repositories/article_repo.dart';
import 'package:journal_web/services/article/article_service.dart';

class ArticleRepoImpl implements ArticleRepo {
  final ArticleService articleService;
  const ArticleRepoImpl(this.articleService);
  @override
  Future<DataState<ArticleModel>> addArticle(ArticleModel article) async {
    return await articleService.addArticle(article);
  }

  @override
  Future<void> deleteArticle(String id) async {
    await articleService.deleteArticle(id);
  }

  @override
  Future<DataState<List<ArticleModel>>> getAllArticles() async {
    return await articleService.getAllArticles();
  }

  @override
  Future<DataState<ArticleModel>> updateArticle(ArticleModel article) async {
    return await articleService.updateArticle(article);
  }
}
