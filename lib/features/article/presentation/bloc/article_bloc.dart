import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/domain/usecases/add_article_uc.dart';
import 'package:journal_web/features/article/domain/usecases/delete_article_uc.dart';
import 'package:journal_web/features/article/domain/usecases/edit_article_uc.dart';
import 'package:journal_web/features/article/domain/usecases/get_all_article_uc.dart';
import 'package:journal_web/features/article/domain/usecases/get_article_by_id_uc.dart';
import 'package:journal_web/features/article/domain/usecases/get_article_by_iid_uc.dart';
import 'package:journal_web/features/article/domain/usecases/get_article_by_jid_uc.dart';
import 'package:journal_web/features/article/domain/usecases/get_article_by_vid_uc.dart';

part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final GetAllArticleUC getAllArticleUC;
  final GetArticleByVolumeIdUC getArticleByVolumeIdUC;
  final GetArticleByJournalIdUC getArticleByJournalIdUC;
  final GetArticleByIssueIdUC getArticleByIssueIdUC;
  final GetArticleByIdUC getArticleByIdUC;
  final AddArticleUC addArticleUC;
  final EditArticleUc editArticleUC;
  final DeleteArticleUC deleteArticleUC;

  ArticleBloc(
    this.getAllArticleUC,
    this.getArticleByVolumeIdUC,
    this.getArticleByJournalIdUC,
    this.getArticleByIssueIdUC,
    this.getArticleByIdUC,
    this.addArticleUC,
    this.editArticleUC,
    this.deleteArticleUC,
  ) : super(ArticleInitial()) {
    //
    on<GetAllArticleEvent>(_onGetAllArticleEvent);
    on<GetArticleByVolumeIdEvent>(_onGetArticleByVolumeIdEvent);
    on<GetArticleByJournalIdEvent>(_onGetArticleByJournalIdEvent);
    on<GetArticleByIssueIdEvent>(_onGetArticleByIssueIdEvent);
    on<GetArticleByIdEvent>(_onGetArticleByIdEvent);
    on<AddArticleEvent>(_onAddArticleEvent);
    on<EditArticleEvent>(_onEditArticleEvent);
    on<DeleteArticleEvent>(_onDeleteArticleEvent);
  }

  Future<void> _onGetAllArticleEvent(
      GetAllArticleEvent event, Emitter<ArticleState> emit) async {
    emit(AllArticleLoadingState());
    final result = await getAllArticleUC.call(null);
    if (result is DataSuccess) {
      emit(AllArticleLoadedState(articles: result.data!));
    } else if (result is DataFailed) {
      emit(ArticleErrorState(message: result.message!));
    }
  }

  Future<void> _onGetArticleByVolumeIdEvent(
      GetArticleByVolumeIdEvent event, Emitter<ArticleState> emit) async {
    emit(ArticleByVolumeIdLoadingState());
    final result = await getArticleByVolumeIdUC.call(event.volumeId);
    if (result is DataSuccess) {
      emit(ArticleByVolumeIdLoadedState(articles: result.data!));
    } else if (result is DataFailed) {
      emit(ArticleErrorState(message: result.message!));
    }
  }

  Future<void> _onGetArticleByJournalIdEvent(
      GetArticleByJournalIdEvent event, Emitter<ArticleState> emit) async {
    emit(ArticleByJournalIdLoadingState());
    final result = await getArticleByJournalIdUC.call(event.journalId);
    if (result is DataSuccess) {
      emit(ArticleByJournalIdLoadedState(articles: result.data!));
    } else if (result is DataFailed) {
      emit(ArticleErrorState(message: result.message!));
    }
  }

  Future<void> _onGetArticleByIssueIdEvent(
      GetArticleByIssueIdEvent event, Emitter<ArticleState> emit) async {
    emit(ArticleByIssueIdLoadingState());
    final result = await getArticleByIssueIdUC.call(event.issueId);
    if (result is DataSuccess) {
      emit(ArticleByIssueIdLoadedState(articles: result.data!));
    } else if (result is DataFailed) {
      emit(ArticleErrorState(message: result.message!));
    }
  }

  Future<void> _onGetArticleByIdEvent(
      GetArticleByIdEvent event, Emitter<ArticleState> emit) async {
    emit(ArticleByIdLoadingState());
    final result = await getArticleByIdUC.call(event.id);
    if (result is DataSuccess) {
      emit(ArticleByIdLoadedState(article: result.data!));
    } else if (result is DataFailed) {
      emit(ArticleErrorState(message: result.message!));
    }
  }

  Future<void> _onAddArticleEvent(
      AddArticleEvent event, Emitter<ArticleState> emit) async {
    await addArticleUC.call(event.article);
    add(GetAllArticleEvent());
  }

  Future<void> _onEditArticleEvent(
      EditArticleEvent event, Emitter<ArticleState> emit) async {
    await editArticleUC.call(event.article);
    add(GetAllArticleEvent());
  }

  Future<void> _onDeleteArticleEvent(
      DeleteArticleEvent event, Emitter<ArticleState> emit) async {
    await deleteArticleUC.call(event.id);
    add(GetAllArticleEvent());
  }
}
