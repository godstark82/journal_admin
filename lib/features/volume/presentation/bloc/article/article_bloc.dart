import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/features/volume/data/models/article_model.dart';
import 'package:journal_web/features/volume/domain/usecases/article_usecase.dart';

part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final GetArticlesByIssueIdUseCase getArticlesByIssueIdUseCase;
  final CreateArticleUseCase createArticleUseCase;
  final DeleteArticleUseCase deleteArticleUseCase;
  final UpdateArticleUseCase updateArticleUseCase;
  final GetArticleByIdUseCase getArticleByIdUseCase;

  ArticleBloc(
    this.getArticleByIdUseCase,
    this.getArticlesByIssueIdUseCase,
    this.createArticleUseCase,
    this.deleteArticleUseCase,
    this.updateArticleUseCase,
  ) : super(ArticleInitial()) {
    on<AddArticleEvent>(_onAddArticle);
    on<DeleteArticleEvent>(_onDeleteArticle);
    on<UpdateArticleEvent>(_onUpdateArticle);
  }

  Future<void> _onAddArticle(
      AddArticleEvent event, Emitter<ArticleState> emit) async {
    emit(ArticlesLoading());
    await createArticleUseCase.call({
      'article': event.article,
      'issueId': event.issueId,
      'volumeId': event.volumeId,
    });
  }

  Future<void> _onDeleteArticle(
      DeleteArticleEvent event, Emitter<ArticleState> emit) async {
    emit(ArticlesLoading());
    await deleteArticleUseCase.call({
      'articleId': event.articleId,
      'issueId': event.issueId,
      'volumeId': event.volumeId,
    });
  }

  Future<void> _onUpdateArticle(
      UpdateArticleEvent event, Emitter<ArticleState> emit) async {
    emit(ArticlesLoading());
    await updateArticleUseCase.call({
      'article': event.article,
      'issueId': event.issueId,
      'volumeId': event.volumeId,
    });
  }
}
