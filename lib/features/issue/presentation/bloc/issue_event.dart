part of 'issue_bloc.dart';

abstract class IssueEvent extends Equatable {
  const IssueEvent();

  @override
  List<Object> get props => [];
}

class GetIssueByIdEvent extends IssueEvent {
  final String issueId;

  const GetIssueByIdEvent(this.issueId);

  @override
  List<Object> get props => [issueId];
}

class GetIssueByVolumeIdEvent extends IssueEvent {
  final String volumeId;

  const GetIssueByVolumeIdEvent(this.volumeId);

  @override
  List<Object> get props => [volumeId];
}

class GetIssueByJournalIdEvent extends IssueEvent {
  final String journalId;

  const GetIssueByJournalIdEvent(this.journalId);

  @override
  List<Object> get props => [journalId];
}

class GetAllIssueEvent extends IssueEvent {
  const GetAllIssueEvent();

  @override
  List<Object> get props => [];
}

class AddIssueEvent extends IssueEvent {
  final IssueModel issue;

  const AddIssueEvent(this.issue);

  @override
  List<Object> get props => [issue];
}

class UpdateIssueEvent extends IssueEvent {
  final IssueModel issue;

  const UpdateIssueEvent(this.issue);

  @override
  List<Object> get props => [issue];
}

class DeleteIssueEvent extends IssueEvent {
  final String issueId;

  const DeleteIssueEvent(this.issueId);

  @override
  List<Object> get props => [issueId];
}
