part of 'issue_bloc.dart';

abstract class IssueState extends Equatable {
  const IssueState();  

  @override
  List<Object> get props => [];
}
class IssueInitial extends IssueState {}

class LoadingIssueByIdState extends IssueState {}

class LoadedIssueByIdState extends IssueState {
  final IssueModel issue;

  const LoadedIssueByIdState({required this.issue});
}

class LoadingIssueByVolumeIdState extends IssueState {}

class LoadedIssueByVolumeIdState extends IssueState {
  final List<IssueModel> issues;

  const LoadedIssueByVolumeIdState({required this.issues});
}

class LoadingIssueByJournalIdState extends IssueState {}

class LoadedIssueByJournalIdState extends IssueState {
  final List<IssueModel> issues;

  const LoadedIssueByJournalIdState({required this.issues});
}

class LoadingAllIssueState extends IssueState {}

class LoadedAllIssueState extends IssueState {
  final List<IssueModel> issues;

  const LoadedAllIssueState({required this.issues});
}

class ErrorIssueState extends IssueState {
  final String message;

  const ErrorIssueState({required this.message});
}






