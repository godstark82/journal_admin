import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/domain/usecases/add_article_usecase.dart';
import 'package:journal_web/features/article/domain/usecases/delete_article_usecase.dart';
import 'package:journal_web/features/article/domain/usecases/get_articles_usecase.dart';
import 'package:journal_web/features/article/domain/usecases/update_article_usecase.dart';

part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final GetArticlesUsecase getArticlesUsecase;
  final UpdateArticleUsecase updateArticleUsecase;
  final DeleteArticleUsecase deleteArticleUsecase;
  final AddArticleUsecase addArticleUsecase;

  ArticleBloc(this.addArticleUsecase, this.deleteArticleUsecase,
      this.getArticlesUsecase, this.updateArticleUsecase)
      : super(ArticleInitial()) {
    on<ArticleAddEvent>(onAddArticle);
    on<ArticleLoadEvent>(onGetAllArticles);
    on<ArticleDeleteEvent>(onDeleteArticle);
    on<ArticleUpdateEvent>(onUpdateArticle);
  }

  void onGetAllArticles(
      ArticleLoadEvent event, Emitter<ArticleState> emit) async {
    emit(ArticleLoading());
    try {
      final articles = await getArticlesUsecase.call({});
      if (articles is DataSuccess && articles.data != null) {
        emit(ArticleLoaded(articles.data!));
      } else {
        emit(ArticleError('NULL'));
      }
    } catch (e) {
      emit(ArticleError(e.toString()));
    }
  }

  void onAddArticle(ArticleAddEvent event, Emitter<ArticleState> emit) async {
    emit(ArticleLoading());
    try {
      final article = await addArticleUsecase.call(event.article);
      if (article is DataSuccess && article.data != null) {
        emit(ArticleAddNewArticleState(article.data!));
      } else {
        emit(ArticleError('NULL'));
      }
    } catch (e) {
      emit(ArticleError(e.toString()));
    }
  }

  void onUpdateArticle(
      ArticleUpdateEvent event, Emitter<ArticleState> emit) async {
    emit(ArticleLoading());
    try {
      final article = await updateArticleUsecase.call(event.article);
      if (article is DataSuccess && article.data != null) {
        emit(ArticleAddNewArticleState(article.data!));
      } else {
        emit(ArticleError('NULL'));
      }
    } catch (e) {
      emit(ArticleError(e.toString()));
    }
  }

  void onDeleteArticle(
      ArticleDeleteEvent event, Emitter<ArticleState> emit) async {
    emit(ArticleLoading());
    try {
      await deleteArticleUsecase.call(event.id);
    } catch (e) {
      emit(ArticleError(e.toString()));
    }
  }
}
