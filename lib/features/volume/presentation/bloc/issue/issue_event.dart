part of 'issue_bloc.dart';

sealed class IssueEvent extends Equatable {
  const IssueEvent();

  @override
  List<Object> get props => [];
}

class GetIssuesEvent extends IssueEvent {
  final String volumeId;

  const GetIssuesEvent({required this.volumeId});
}



class AddIssueEvent extends IssueEvent {
  final IssueModel issue;
  final String volumeId;

  const AddIssueEvent({required this.issue, required this.volumeId});
}

class DeleteIssueEvent extends IssueEvent {
  final String volumeId;
  final String issueId;

  const DeleteIssueEvent({required this.volumeId, required this.issueId});
}

class UpdateIssueEvent extends IssueEvent {
  final IssueModel issue;


  const UpdateIssueEvent({required this.issue});
}
