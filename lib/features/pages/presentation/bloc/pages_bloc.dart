import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/pages/data/models/page_model.dart';
import 'package:journal_web/features/pages/domain/usecases/add_page_usecase.dart';
import 'package:journal_web/features/pages/domain/usecases/delete_page_usecase.dart';
import 'package:journal_web/features/pages/domain/usecases/edit_page_usecase.dart';
import 'package:journal_web/features/pages/domain/usecases/get_page_usecase.dart';
import 'package:journal_web/features/pages/domain/usecases/get_pages_usecase.dart';

part 'pages_event.dart';
part 'pages_state.dart';

class PagesBloc extends Bloc<PagesEvent, PagesState> {
  final GetSinglePageUsecase getSinglePageUsecase;
  final GetPagesUsecase getPagesUsecase;
  final EditPageUsecase editPageUsecase;
  final DeletePageUsecase deletePageUsecase;
  final AddPageUsecase addPageUsecase;

  PagesBloc(this.getSinglePageUsecase, this.getPagesUsecase,
      this.editPageUsecase, this.deletePageUsecase, this.addPageUsecase)
      : super(PagesInitial()) {
    //
    on<GetSinglePageEvent>(_onGetSinglePage);
    on<GetAllPagesEvent>(_onGetAllPages);
    on<UpdatePageEvent>(_onUpdatePage);
    on<DeletePageEvent>(_onDeletePage);
    on<AddPageEvent>(_onAddPage);
  }

  Future<void> _onAddPage(AddPageEvent event, Emitter<PagesState> emit) async {
    await addPageUsecase.call(event.page);
    add(GetAllPagesEvent());
  }

  Future<void> _onGetSinglePage(
      GetSinglePageEvent event, Emitter<PagesState> emit) async {
    emit(SinglePageLoadingState());
    final page = await getSinglePageUsecase.call(event.id);
    if (page is DataSuccess) {
      emit(SinglePageLoadedState(page: page.data!));
    } else if (page is DataFailed) {
      emit(SinglePageErrorState(error: page.message!));
    }
  }

  Future<void> _onGetAllPages(
      GetAllPagesEvent event, Emitter<PagesState> emit) async {
    emit(AllPagesLoadingState());
    final pages = await getPagesUsecase.call({});
    if (pages is DataSuccess) {
      emit(AllPagesLoadedState(pages: pages.data!));
    } else if (pages is DataFailed) {
      emit(AllPagesErrorState(error: pages.message!));
    }
  }

  Future<void> _onUpdatePage(
      UpdatePageEvent event, Emitter<PagesState> emit) async {
    await editPageUsecase.call(event.page);
    add(GetAllPagesEvent());
  }

  Future<void> _onDeletePage(
      DeletePageEvent event, Emitter<PagesState> emit) async {
    await deletePageUsecase.call(event.id);
    add(GetAllPagesEvent());
  }
}
