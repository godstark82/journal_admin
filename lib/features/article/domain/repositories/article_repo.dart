import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';

abstract class ArticleRepository {
  Future<DataState<List<ArticleModel>>> getArticleByVolumeId(String volumeId);
  Future<DataState<List<ArticleModel>>> getArticleByJournalId(String journalId);
  Future<DataState<List<ArticleModel>>> getArticleByIssueId(String issueId);
  Future<DataState<ArticleModel>> getArticleById(String id);
  Future<DataState<List<ArticleModel>>> getAllArticles();
  Future<void> addArticle(ArticleModel article);
  Future<void> updateArticle(ArticleModel article);
  Future<void> deleteArticle(String id);
  
}
