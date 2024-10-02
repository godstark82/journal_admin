part of 'singleissue_bloc.dart';

sealed class SingleissueState extends Equatable {
  const SingleissueState();

  @override
  List<Object> get props => [];
}

final class SingleissueInitial extends SingleissueState {}

class SingleIssueLoaded extends SingleissueState {
  final IssueModel issue;

  const SingleIssueLoaded({required this.issue});
}

class SingleIssueError extends SingleissueState {
  final String message;

  const SingleIssueError({required this.message});
}

class SingleIssueLoading extends SingleissueState {}
