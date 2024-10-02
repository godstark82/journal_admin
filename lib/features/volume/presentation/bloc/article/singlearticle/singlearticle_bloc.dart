import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/volume/data/models/article_model.dart';
import 'package:journal_web/features/volume/domain/usecases/article_usecase.dart';

part 'singlearticle_event.dart';
part 'singlearticle_state.dart';

class SinglearticleBloc extends Bloc<SinglearticleEvent, SinglearticleState> {
  final GetArticleByIdUseCase getArticleByIdUseCase;
  SinglearticleBloc(this.getArticleByIdUseCase)
      : super(SinglearticleInitial()) {
    on<LoadSingleArticleEvent>(_onLoadSingleArticle);
  }

  Future<void> _onLoadSingleArticle(
      LoadSingleArticleEvent event, Emitter<SinglearticleState> emit) async {
    emit(SingleArticleLoading());
    final result = await getArticleByIdUseCase.call({
      'articleId': event.articleId,
      'issueId': event.issueId,
      'volumeId': event.volumeId,
    });

    if (result is DataSuccess) {
      emit(SingleArticleLoaded(article: result.data!));
    }
    if (result is DataFailed) {
      emit(SingleArticleError(message: result.message!));
    }
  }
}
