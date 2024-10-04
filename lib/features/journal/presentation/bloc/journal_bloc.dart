import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:journal_web/features/journal/domain/usecases/create_journal_usecase.dart';
import 'package:journal_web/features/journal/domain/usecases/delete_journal_usecase.dart';
import 'package:journal_web/features/journal/domain/usecases/get_all_journal_uc.dart';
import 'package:journal_web/features/journal/domain/usecases/get_journal_uc.dart';
import 'package:journal_web/features/journal/domain/usecases/update_journal_usecase.dart';


part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final GetAllJournalUC _getAllJournalUC;
  final CreateJournalUsecase _createJournalUsecase;
  final DeleteJournalUsecase _deleteJournalUsecase;
  final GetJournalUc _getJournalByIdUC;
  final UpdateJournalUsecase _updateJournalUsecase;

  JournalBloc(
      this._getAllJournalUC,
      this._createJournalUsecase,
      this._deleteJournalUsecase,
      this._getJournalByIdUC,
      this._updateJournalUsecase)
      : super(JournalInitial()) {
    on<GetAllJournalEvent>(_onGetAllJournal);
    on<CreateJournalEvent>(_onCreateJournal);
    on<DeleteJournalEvent>(_onDeleteJournal);
    on<GetJournalByIdEvent>(_onGetJournalById);
    on<UpdateJournalEvent>(_onUpdateJournal);
  }

  void _onGetAllJournal(
      GetAllJournalEvent event, Emitter<JournalState> emit) async {
    emit(JournalsLoading());
    final result = await _getAllJournalUC.call(null);
    if (result is DataSuccess) {
      emit(JournalsLoaded(journals: result.data!));
    } else {
      emit(JournalError(message: result.message ?? 'NO DATA FOUND'));
    }
  }

  void _onCreateJournal(
      CreateJournalEvent event, Emitter<JournalState> emit) async {
    await _createJournalUsecase.call(event.journal);
    add(GetAllJournalEvent());
  }

  void _onDeleteJournal(
      DeleteJournalEvent event, Emitter<JournalState> emit) async {
    await _deleteJournalUsecase.call(event.id);
    add(GetAllJournalEvent());
  }

  void _onGetJournalById(
      GetJournalByIdEvent event, Emitter<JournalState> emit) async {
    emit(JournalByIdLoading());
    final result = await _getJournalByIdUC.call(event.id);
    if (result is DataSuccess) {
      emit(JournalByIdLoaded(journal: result.data!));
    } else {
      emit(JournalError(message: result.message ?? 'NO DATA FOUND'));
    }
  }

  void _onUpdateJournal(
      UpdateJournalEvent event, Emitter<JournalState> emit) async {
    await _updateJournalUsecase.call(event.journal);
    add(GetAllJournalEvent());
  }
}
