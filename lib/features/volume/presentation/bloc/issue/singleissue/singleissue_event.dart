part of 'singleissue_bloc.dart';

sealed class SingleissueEvent extends Equatable {
  const SingleissueEvent();

  @override
  List<Object> get props => [];
}
class LoadSingleIssueEvent extends SingleissueEvent {
  final String issueId;
  final String volumeId;

  const LoadSingleIssueEvent({
    required this.issueId,
    required this.volumeId,
  });
}
