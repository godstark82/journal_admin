import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';

abstract class ArticleRepo {

  Future<DataState<List<ArticleModel>>> getAllArticles();

  Future<DataState<ArticleModel>> addArticle(ArticleModel article);

  Future<DataState<ArticleModel>> updateArticle(ArticleModel article);

  Future<void> deleteArticle(String id);

}