import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/volume/data/models/issue_model.dart';
import 'package:journal_web/features/volume/domain/usecases/issue_usecases.dart';

part 'issue_event.dart';
part 'issue_state.dart';

class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final GetAllIssueUseCase getAllIssueUseCase;
  final CreateIssueUseCase createIssueUseCase;
  final DeleteIssueUseCase deleteIssueUseCase;
  final UpdateIssueUseCase updateIssueUseCase;
  final GetIssueByIdUseCase getSingleIssueUseCase;

  IssueBloc(
    this.getAllIssueUseCase,
    this.getSingleIssueUseCase,
    this.createIssueUseCase,
    this.deleteIssueUseCase,
    this.updateIssueUseCase,
  ) : super(IssueInitial()) {
    on<GetIssuesEvent>(_onGetIssues);
    on<AddIssueEvent>(_onAddIssue);
    on<DeleteIssueEvent>(_onDeleteIssue);
    on<UpdateIssueEvent>(_onUpdateIssue);
  }

  Future<void> _onGetIssues(
      GetIssuesEvent event, Emitter<IssueState> emit) async {
    emit(IssuesLoading());
    final issues = await getAllIssueUseCase.call(event.volumeId);
    log(issues.data!.length.toString());
    if (issues is DataSuccess) {
      emit(IssuesLoaded(issues: issues.data ?? []));
    } else {
      emit(IssuesError(message: 'Some Error Occured'));
    }
  }

  Future<void> _onAddIssue(
      AddIssueEvent event, Emitter<IssueState> emit) async {
    try {
      emit(IssuesLoading());
      await createIssueUseCase.call({
        'issue': event.issue,
        'volumeId': event.volumeId,
      });
      emit(IssueAdded());
      add(GetIssuesEvent(volumeId: event.volumeId));
    } catch (e) {
      log(e.toString());
      emit(IssuesError(message: e.toString()));
    }
  }

  Future<void> _onDeleteIssue(
      DeleteIssueEvent event, Emitter<IssueState> emit) async {
    emit(IssuesLoading());
    await deleteIssueUseCase.call({
      'issueId': event.issueId,
      'volumeId': event.volumeId,
    });
    add(GetIssuesEvent(volumeId: event.volumeId));
  }

  Future<void> _onUpdateIssue(
      UpdateIssueEvent event, Emitter<IssueState> emit) async {
    emit(IssuesLoading());
    await updateIssueUseCase.call(event.issue);
    add(GetIssuesEvent(volumeId: event.issue.volumeId!));
  }
}
