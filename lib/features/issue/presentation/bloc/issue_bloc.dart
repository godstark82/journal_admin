import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/issue/data/models/issue_model.dart';
import 'package:journal_web/features/issue/domain/usecases/add_issue_uc.dart';
import 'package:journal_web/features/issue/domain/usecases/delete_issue_uc.dart';
import 'package:journal_web/features/issue/domain/usecases/get_all_issue_uc.dart';
import 'package:journal_web/features/issue/domain/usecases/get_issue_by_id_uc.dart';
import 'package:journal_web/features/issue/domain/usecases/get_issue_by_vid_uc.dart';
import 'package:journal_web/features/issue/domain/usecases/get_issues_by_jid_uc.dart';
import 'package:journal_web/features/issue/domain/usecases/update_issue_uc.dart';

part 'issue_event.dart';
part 'issue_state.dart';

class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final GetAllIssueUC _getAllIssueUC;
  final GetIssueByIdUseCase _getIssueByIdUseCase;
  final GetIssueByVolumeIdUseCase _getIssueByVolumeIdUseCase;
  final GetIssuesByJournalIdUseCase _getIssuesByJournalIdUseCase;
  final AddIssueUseCase _addIssueUseCase;
  final UpdateIssueUseCase _updateIssueUseCase;
  final DeleteIssueUseCase _deleteIssueUseCase;

  IssueBloc(
      this._getAllIssueUC,
      this._getIssueByIdUseCase,
      this._getIssueByVolumeIdUseCase,
      this._getIssuesByJournalIdUseCase,
      this._addIssueUseCase,
      this._updateIssueUseCase,
      this._deleteIssueUseCase)
      : super(IssueInitial()) {
    on<GetAllIssueEvent>(_onGetAllIssue);
    on<GetIssueByIdEvent>(_onGetIssueById);
    on<GetIssueByVolumeIdEvent>(_onGetIssueByVolumeId);
    on<GetIssueByJournalIdEvent>(_onGetIssuesByJournalId);
    on<AddIssueEvent>(_onAddIssue);
    on<UpdateIssueEvent>(_onUpdateIssue);
    on<DeleteIssueEvent>(_onDeleteIssue);
  }

  Future<void> _onGetIssueById(
      GetIssueByIdEvent event, Emitter<IssueState> emit) async {
    emit(LoadingIssueByIdState());

    final issue = await _getIssueByIdUseCase.call(event.issueId);
    if (issue is DataSuccess) {
      emit(LoadedIssueByIdState(issue: issue.data!));
    } else if (issue is DataFailed) {
      emit(ErrorIssueState(message: issue.message!));
    }
  }

  Future<void> _onGetIssueByVolumeId(
      GetIssueByVolumeIdEvent event, Emitter<IssueState> emit) async {
    emit(LoadingIssueByVolumeIdState());

    final issue = await _getIssueByVolumeIdUseCase.call(event.volumeId);
    if (issue is DataSuccess) {
      emit(LoadedIssueByVolumeIdState(issues: issue.data!));
    } else if (issue is DataFailed) {
      emit(ErrorIssueState(message: issue.message!));
    }
  }

  Future<void> _onGetIssuesByJournalId(
      GetIssueByJournalIdEvent event, Emitter<IssueState> emit) async {
    emit(LoadingIssueByJournalIdState());

    final issues = await _getIssuesByJournalIdUseCase.call(event.journalId);
    if (issues is DataSuccess) {
      emit(LoadedIssueByJournalIdState(issues: issues.data!));
    } else if (issues is DataFailed) {
      emit(ErrorIssueState(message: issues.message!));
    }
  }

  Future<void> _onAddIssue(
      AddIssueEvent event, Emitter<IssueState> emit) async {
    await _addIssueUseCase.call(event.issue);
    add(GetAllIssueEvent());
  }

  Future<void> _onUpdateIssue(
      UpdateIssueEvent event, Emitter<IssueState> emit) async {
    await _updateIssueUseCase.call(event.issue);
    add(GetAllIssueEvent());
  }

  Future<void> _onDeleteIssue(
      DeleteIssueEvent event, Emitter<IssueState> emit) async {
    await _deleteIssueUseCase.call(event.issueId);
    add(GetAllIssueEvent());
  }

  Future<void> _onGetAllIssue(
      GetAllIssueEvent event, Emitter<IssueState> emit) async {
    emit(LoadingAllIssueState());
    final issues = await _getAllIssueUC.call(null);
    if (issues is DataSuccess) {
      emit(LoadedAllIssueState(issues: issues.data!));
    } else if (issues is DataFailed) {
      emit(ErrorIssueState(message: issues.message!));
    }
  }
}
