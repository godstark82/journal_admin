part of 'issue_bloc.dart';

sealed class IssueState extends Equatable {
  const IssueState();

  @override
  List<Object> get props => [];
}

final class IssueInitial extends IssueState {}

class IssuesLoading extends IssueState {}

class IssuesLoaded extends IssueState {
  final List<IssueModel> issues;

  const IssuesLoaded({required this.issues});
}



class IssuesError extends IssueState {
  final String message;

  const IssuesError({required this.message});
}

// add issue
class IssueAdded extends IssueState {}
