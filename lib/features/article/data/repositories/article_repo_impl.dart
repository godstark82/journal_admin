import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/domain/repositories/article_repo.dart';
import 'package:journal_web/services/article/article_service.dart';

class ArticleRepoImpl implements ArticleRepository {
  final ArticleService articleService;

  ArticleRepoImpl(this.articleService);

  @override
  Future<void> addArticle(ArticleModel article) async {
    return await articleService.addArticle(article);
  }

  @override
  Future<void> deleteArticle(String id) async {
    return await articleService.deleteArticle(id);
  }

  @override
  Future<DataState<List<ArticleModel>>> getAllArticles() async {
    return await articleService.getAllArticles();
  }

  @override
  Future<DataState<ArticleModel>> getArticleById(String id) async {
    return await articleService.getArticleById(id);
  }

  @override
  Future<DataState<List<ArticleModel>>> getArticleByIssueId(
      String issueId) async {
    return await articleService.getArticleByIssueId(issueId);
  }

  @override
  Future<DataState<List<ArticleModel>>> getArticleByJournalId(
      String journalId) async {
    return await articleService.getArticleByJournalId(journalId);
  }

  @override
  Future<DataState<List<ArticleModel>>> getArticleByVolumeId(
      String volumeId) async {
    return await articleService.getArticleByVolumeId(volumeId);
  }

  @override
  Future<void> updateArticle(ArticleModel article) async {
    return await articleService.updateArticle(article);
  }
}
